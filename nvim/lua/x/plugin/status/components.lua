---@diagnostic disable: unused-local
local hl = require("x.plugin.status.hl")
local lua_utils = require("x.helper.lua")
local debounce = require("x.helper.lua").cached_debounce

local M = {}

---@alias StatusComponent function(StatusContext, Options): string

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
local function _filename(ctx, opts)
    if not ctx or not ctx.filename then
        return opts.icons.noname
    end

    -- Determine if this is the active window
    local is_active = ctx.is_current
    local bold_hl = is_active and "MyStatusLineBold" or "MyStatusLineNCBold"

    if ctx.filename == "" then
        return hl.with_hl(opts.icons.noname, bold_hl)
    end

    local full_path = require("x.helper.path").shorten_path(
        vim.fn.fnamemodify(ctx.filename, ":."),
        "/",
        opts.filename.truncation_target
    )

    -- Split path into directory and filename parts
    local dir_path = vim.fn.fnamemodify(full_path, ":h")
    local filename = vim.fn.fnamemodify(full_path, ":t")

    -- Build the formatted string with highlights
    local result = "%<"

    -- Add directory path with normal highlight (if not current dir)
    if dir_path ~= "." then
        result = result .. dir_path .. "/"
    end

    -- Add filename with appropriate bold highlight
    result = result .. hl.with_hl(filename, bold_hl)

    return result
end

local _debounced_filenames = function(key)
    return debounce(1000, key, _filename)
end

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
function M.filename(ctx, opts)
    return _debounced_filenames(ctx.win_id or -1)(ctx, opts)
end

function M.winid(ctx, opts)
    if not ctx or not ctx.win_id then
        return ""
    end

    -- Get the window number
    local win_number = vim.api.nvim_win_get_number(ctx.win_id)
    return string.format("%d", win_number)
end

---For debugging
---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
function M.debug(ctx, opts)
    if not ctx then
        return ""
    end

    local time = os.date("%H:%M:%S")
    return string.format(
        "%s: file:%s buf:%s %s ",
        ctx.win_id or "nil",
        ctx.filename or "nil",
        ctx.buf or "nil",
        time
    )
end

local function _buffer_flags(bufnr, winid)
    local flags = ""
    -- Modified flag
    if bufnr ~= nil and vim.bo[bufnr].modified then
        flags = flags .. "[+]"
    end
    -- Modifiable
    if bufnr ~= nil and not vim.bo[bufnr].modifiable then
        flags = flags .. "[-]"
    end
    -- Readonly flag
    if bufnr ~= nil and vim.bo[bufnr].readonly then
        flags = flags .. "[RO]"
    end
    -- Help buffer flag
    if bufnr ~= nil and vim.bo[bufnr].buftype == "help" then
        flags = flags .. "[Help]"
    end
    -- Preview flag
    if winid ~= nil and vim.wo[winid] ~= nil and vim.wo[winid].previewwindow then
        flags = flags .. "[Preview]"
    end
    return flags
end

local _get_tab_label = function(n, noname)
    local buflist = vim.fn.tabpagebuflist(n)
    local winnr = vim.fn.tabpagewinnr(n)
    local winid = vim.fn.win_getid(winnr, n)
    local bufnr = buflist[winnr]
    local file = vim.fn.bufname(bufnr)
    local filename = vim.fn.fnamemodify(file, ":t")
    local label = filename ~= "" and filename or noname
    return label
end

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
function M.tabs(ctx, opts)
    local current_tab = vim.fn.tabpagenr()
    local prev_tab = vim.fn.tabpagenr("#")
    local total_tabs = vim.fn.tabpagenr("$")

    local s = ""

    -- Add the tabs
    for i = 1, total_tabs do
        local is_current = i == current_tab
        local label = _get_tab_label(i, opts.icons.noname)
        local box_size = lua_utils.utf8_char_count(label) + 5

        label = label .. _buffer_flags(ctx.buf, ctx.win_id)
        label = i .. ":" .. label
        if i == prev_tab then
            label = label .. "-"
        end
        if i == current_tab then
            label = label .. "*"
        end

        -- Use builtin tabline formatting for minimum width (label length + 4)
        local min_width = box_size

        if is_current then
            s = s .. "%#TabLineSel#"
        else
            s = s .. "%#TabLine#"
        end
        s = s .. "%" .. i .. "T"
        s = s .. "%-" .. min_width .. "( " .. label .. " %)"
    end

    -- Fill the rest of the tabline
    s = s .. "%#TabLineFill#%T"

    return s
end

---@param ctx customs.status.StatusContext?
---@param opts customs.status.StatusOptions
---@param hls? table<string, string> Key is one of ['hint', 'info', 'warn', 'error'], value is highlight group
---@return string
local function _diagnostics(ctx, opts, hls)
    local res = {}

    local diag = vim.diagnostic.get(ctx and ctx.buf or nil)

    for _, d in ipairs(diag) do
        res[d.severity] = (res[d.severity] or 0) + 1
    end

    local lv_hint = res[vim.diagnostic.severity["HINT"]]
    local lv_info = res[vim.diagnostic.severity["INFO"]]
    local lv_warn = res[vim.diagnostic.severity["WARN"]]
    local lv_err = res[vim.diagnostic.severity["ERROR"]]

    local hl_hint = hls and hls.hint
    local hl_info = hls and hls.info
    local hl_warn = hls and hls.warn
    local hl_err = hls and hls.error

    local components = {}

    if lv_hint ~= nil and lv_hint > 0 then
        local s = ""
        s = s .. hl.with_hl(opts.icons.hint .. lv_hint, hl_hint)
        table.insert(components, s)
    end
    if lv_info ~= nil and lv_info > 0 then
        local s = ""
        s = s .. hl.with_hl(opts.icons.info .. lv_info, hl_info)
        table.insert(components, s)
    end
    if lv_warn ~= nil and lv_warn > 0 then
        local s = ""
        s = s .. hl.with_hl(opts.icons.warn .. lv_warn, hl_warn)
        table.insert(components, s)
    end
    if lv_err ~= nil and lv_err > 0 then
        local s = ""
        s = s .. hl.with_hl(opts.icons.err .. lv_err, hl_err)
        table.insert(components, s)
    end

    if #components == 0 then
        return ""
    end

    local result = table.concat(components, " ")
    return result
end

local _debounced_status_diagnostics = function(key)
    return debounce(1000, key, _diagnostics)
end
local _debounced_tabline_diagnostics = debounce(1000, "global", _diagnostics)

---@param ctx customs.status.StatusContext?
---@param opts customs.status.StatusOptions
---@return string
function M.tabline_diagnostics(ctx, opts)
    return _debounced_tabline_diagnostics(ctx, opts, opts.tabline_diagnostics.style and {
        hint = "MyTabLineDiagnosticHint",
        info = "MyTabLineDiagnosticInfo",
        warn = "MyTabLineDiagnosticWarn",
        error = "MyTabLineDiagnosticError"
    } or {
        hint = "MyStatusLineItalic",
        info = "MyStatusLineItalic",
        warn = "MyStatusLineItalic",
        error = "MyStatusLineItalic"
    })
end

---@param ctx customs.status.StatusContext?
---@param opts customs.status.StatusOptions
---@return string
function M.status_diagnostics(ctx, opts)
    if not ctx then
        return ""
    end
    return _debounced_status_diagnostics(ctx.win_id or -1)(ctx, opts, opts.status_diagnostics.style and {
        hint = "MyStatusLineDiagnosticHint",
        info = "MyStatusLineDiagnosticInfo",
        warn = "MyStatusLineDiagnosticWarn",
        error = "MyStatusLineDiagnosticError"
    } or {
        hint = "MyStatusLineItalic",
        info = "MyStatusLineItalic",
        warn = "MyStatusLineItalic",
        error = "MyStatusLineItalic"
    })
end

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
function M.g_git_branch(ctx, opts)
    if not vim.g.statusline_git_branch or vim.g.statusline_git_branch == "" then
        return ""
    end
    return opts.icons.git_branch .. " " .. vim.g.statusline_git_branch
end

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
function M.file_encoding(ctx, opts)
    if not ctx or not ctx.buf then
        return ""
    end
    local fc = vim.bo.fileencoding
    if fc == "utf-8" or fc == "" then
        return ""
    end
    return string.format("[%s]", fc)
end

local format_map = {
    ["dos"] = "CRLF",
    ["unix"] = "LF",
    ["mac"] = "CR",
}

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
function M.file_format(ctx, opts)
    if not ctx or not ctx.buf then
        return ""
    end
    local ff = vim.bo[ctx.buf].fileformat
    if ff == "unix" or ff == "" then
        return ""
    end
    return format_map[ff]
end

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
function M.indentation(ctx, opts)
    if not ctx or not ctx.buf then
        return ""
    end

    local bo = vim.bo[ctx.buf]

    local spacetab = " Tab "
    local indents = bo.tabstop
    local expandtab = bo.expandtab
    local softtabstop = bo.softtabstop
    local shifts = bo.shiftwidth

    if expandtab then
        spacetab = " "
        indents = softtabstop
        if indents < 0 then
            indents = shifts
        end
    end
    return spacetab .. indents .. ":" .. shifts
end

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
local function _pwd(ctx, opts)
    if not ctx or not ctx.buf then
        return ""
    end

    return require("x.helper.path").get_cwd_short(opts.pwd.truncation_target)
end

local _debounced_pwd = debounce(1000, "global", _pwd)

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
function M.pwd(ctx, opts)
    return _debounced_pwd(ctx, opts)
end

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
function M.diff(ctx, opts)
    if not ctx or not ctx.buf then
        return ""
    end

    local gitsigns = vim.b[ctx.buf].gitsigns_status_dict

    local diff = {
        added = 0,
        modified = 0,
        removed = 0
    }
    if gitsigns then
        diff = {
            added = gitsigns.added or 0,
            modified = gitsigns.changed or 0,
            removed = gitsigns.removed or 0
        }
    end

    local s = ""
    if diff.added > 0 then
        s = s .. hl.with_hl(opts.icons.diff_added .. diff.added, opts.diff.style and "MyStatusLineDiffAdded")
    end
    if diff.modified > 0 then
        s = s .. hl.with_hl(opts.icons.diff_modified .. diff.modified, opts.diff.style and "MyStatusLineDiffChanged")
    end
    if diff.removed > 0 then
        s = s .. hl.with_hl(opts.icons.diff_removed .. diff.removed, opts.diff.style and "MyStatusLineDiffRemoved")
    end

    return s
end

function M.location(ctx, opts)
    if not ctx or not ctx.buf then
        return ""
    end

    local pd = math.min(14, ctx.win_width - 64)
    pd = pd < 0 and 0 or pd
    return "%-" .. pd .. ".(%l,%c%V%) %P" -- default
end

return M
