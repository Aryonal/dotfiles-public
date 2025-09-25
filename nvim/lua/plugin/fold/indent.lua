local M = {}

---@class plugin.fold.Cache
---@field line string
---@field indent integer
---@field empty boolean
---@field prev_non_empty integer?
---@field next_non_empty integer?

---@class plugin.fold.BufCache
---@field tick integer
---@field bufnr integer
---@field line_cache table<integer, plugin.fold.Cache>

---@type table<integer, plugin.fold.BufCache>
local buf_cache = {}

local function new_buf_cache(bufnr)
    return {
        tick = vim.api.nvim_buf_get_changedtick(bufnr),
        bufnr = bufnr,
        line_cache = {},
    }
end


local function is_empty(line)
    return line:match("^%s*$") ~= nil
end

local function indent(line)
    return #line:match("^%s*") or 0
end

---@param lnum integer
---@param bcache plugin.fold.BufCache
---@return plugin.fold.Cache
local function get_line_cache(lnum, bcache)
    local cache = bcache.line_cache[lnum]
    if cache then
        return cache
    end

    -- cache miss
    local line = vim.fn.getline(lnum)

    local new_cache = {
        line = line,
        indent = indent(line),
        empty = is_empty(line),
    }
    bcache.line_cache[lnum] = new_cache

    return new_cache
end

---@param lnum integer
---@param bcache plugin.fold.BufCache
---@return plugin.fold.Cache?
local function next_non_empty_line_cache(lnum, bcache)
    local total_lines = vim.fn.line("$")

    local line = get_line_cache(lnum, bcache)
    if line.next_non_empty then
        if line.next_non_empty == -1 then
            return nil -- no next non-empty line
        end
        return get_line_cache(line.next_non_empty, bcache)
    end

    local p = line.next_non_empty or lnum + 1
    while p < total_lines do
        local l = get_line_cache(p, bcache)
        if not l.empty then
            bcache.line_cache[lnum].next_non_empty = p -- always hit
            bcache.line_cache[p].prev_non_empty = lnum -- always hit
            return l
        else
            bcache.line_cache[p].prev_non_empty = lnum -- always hit
        end
        p = l.next_non_empty or p + 1
    end

    bcache.line_cache[lnum].next_non_empty = -1 -- always hit
end

---@param lnum integer
---@param bcache plugin.fold.BufCache
---@return plugin.fold.Cache?
local function prev_non_empty_line(lnum, bcache)
    local line = get_line_cache(lnum, bcache)
    if line.prev_non_empty then
        if line.prev_non_empty == -1 then
            return nil -- no previous non-empty line
        end
        return get_line_cache(line.prev_non_empty, bcache)
    end

    local q = line.prev_non_empty or lnum - 1
    while q > 0 do
        local l = get_line_cache(q, bcache)
        if not l.empty then
            bcache.line_cache[lnum].prev_non_empty = q -- always hit
            bcache.line_cache[q].next_non_empty = lnum -- always hit
            return l
        else
            bcache.line_cache[q].next_non_empty = lnum -- always hit
        end
        q = l.prev_non_empty or q - 1
    end

    bcache.line_cache[lnum].prev_non_empty = -1 -- always hit
end

-- TODO: implement this function
---@param lnum integer
---@param bcache plugin.fold.BufCache
---@return plugin.fold.Cache?
local function prev_min_indent_non_empty_line_before_wall(lnum, bcache)
    local line = get_line_cache(lnum, bcache)

    local min_before_wall = nil

    local q = line.prev_non_empty or lnum - 1
    while q > 0 do
        local l = get_line_cache(q, bcache)
        if l.indent <= line.indent then
            -- l is the wall
            break
        end
        if not l.empty then
            bcache.line_cache[lnum].prev_non_empty = q -- always hit
            bcache.line_cache[q].next_non_empty = lnum -- always hit
            if not min_before_wall or l.indent < min_before_wall.indent then
                min_before_wall = l
            end
        else
            bcache.line_cache[q].next_non_empty = lnum -- always hit
        end
        q = l.prev_non_empty or q - 1
    end

    return min_before_wall
end

function M.indent_foldexpr()
    -- Fallback to default fold expression if treesitter is not available
    -- Indentation based folding rules:
    -- - Folding level is determined by the indentation of the current line
    -- - If current line is empty, it checks the next and previous non-empty lines, pick the max level
    -- - Folding starts if non empty line exists between next non empty line with the same or smaller indent,
    --     e.g. >4 if next non empty line level is 4;
    --     If there's no next non empty line, assume next non empty line is at level 0.
    --     (OPTIMIZE): in most case, the fold level increases step by step, so we can just check the next line
    -- - Folding ends if non empty line exists between previous non empty line with the same or smaller indent,
    --     e.g. <4 if previous non empty line level is 4;
    --     If there's no previous non empty line, assume previous non empty line is at level 0

    local bufnr = vim.api.nvim_get_current_buf()
    local bcache = buf_cache[bufnr] or new_buf_cache(bufnr)

    if bcache.tick ~= vim.api.nvim_buf_get_changedtick(bufnr) then
        -- Cache is outdated, reset it
        bcache = new_buf_cache(bufnr)
    end
    buf_cache[bufnr] = bcache

    local lnum = vim.v.lnum
    local line = get_line_cache(lnum, bcache)
    local indent = line.indent
    local level = string.format("%d", indent)

    if line.empty then
        local next = next_non_empty_line_cache(lnum, bcache)
        local next_indent = next and next.indent or 0
        local prev = prev_non_empty_line(lnum, bcache)
        local prev_indent = prev and prev.indent or 0

        indent = math.max(next_indent, prev_indent)
        return string.format("%d", indent)
    end

    -- if the next non empty line has a higher level, e.g. 4, change current level to >4
    -- if the previous non empty line has a lower level, e.g. 2, change current level to <2

    local next = next_non_empty_line_cache(lnum, bcache) or {}
    local next_indent = next.indent or 0
    if next_indent > indent then
        return string.format(">%d", next_indent)
    end

    local prev = prev_min_indent_non_empty_line_before_wall(lnum, bcache) or {}
    local prev_indent = prev.indent or 0
    if prev_indent > indent then
        return string.format("<%d", prev_indent)
    end

    return level
end

function M.forward_indent_foldexpr()
    -- Fallback to default fold expression if treesitter is not available
    -- Indentation based folding rules:
    -- - Folding level is determined by the indentation of the current line
    -- - If current line is empty, it checks the next and previous non-empty lines, pick the max level
    -- - Folding starts if non empty line exists between next non empty line with the same or smaller indent,
    --     e.g. >4 if next non empty line level is 4;
    --     If there's no next non empty line, assume next non empty line is at level 0.
    --     (OPTIMIZE): in most case, the fold level increases step by step, so we can just check the next line
    -- - Folding ends if non empty line exists between previous non empty line with the same or smaller indent,
    --     e.g. <4 if previous non empty line level is 4;
    --     If there's no previous non empty line, assume previous non empty line is at level 0

    local bufnr = vim.api.nvim_get_current_buf()
    local bcache = buf_cache[bufnr] or new_buf_cache(bufnr)

    if bcache.tick ~= vim.api.nvim_buf_get_changedtick(bufnr) then
        -- Cache is outdated, reset it
        bcache = new_buf_cache(bufnr)
    end
    buf_cache[bufnr] = bcache

    local lnum = vim.v.lnum
    local line = get_line_cache(lnum, bcache)
    local indent = line.indent
    local level = string.format("%d", indent)

    if line.empty then
        local next = next_non_empty_line_cache(lnum, bcache)
        local next_indent = next and next.indent or 0

        indent = next_indent
        return string.format("%d", indent)
    end

    -- if the next non empty line has a higher level, e.g. 4, change current level to >4

    local next = next_non_empty_line_cache(lnum, bcache) or {}
    local next_indent = next.indent or 0
    if next_indent > indent then
        return string.format(">%d", next_indent)
    end

    return level
end

return M
