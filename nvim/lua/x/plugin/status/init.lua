---@diagnostic disable: unused-local
local get_context = require("x.plugin.status.ctx").get_context
local comp        = require("x.plugin.status.components")
local lsp         = require("x.plugin.status.lsp")
local hl          = require("x.plugin.status.hl")


local M = {}

---@class customs.status.StatusOptions
---@field [string] any future configuration options

---@type customs.status.StatusOptions
local _opts = {
    statusline_exclude = {
        filetypes = {
            "TelescopePrompt",
            "lazy",
            "mason",
            "toggleterm",
            "no-neck-pain",
            "", -- empty filetype
        },
        buftypes = {
            "nofile",
            "prompt",
        },
        filenames = {
            "COMMIT_EDITMSG",
            "MERGE_MSG",
        },
    },
    icons = {
        git_branch = "",
        noname = "[無名]",
        hint = "H:",
        info = "I:",
        warn = "W:",
        err = "E:",
        diff_added = "+",
        diff_modified = "~",
        diff_removed = "-",
        lsp_waiting = "…",
        lsp_ready = "✓",
    },
    tabline = {
        style = true, -- custom hl
    },
    -- Components options
    filename = {
        style = true, -- custom hl
        truncation_target = 64,
    },
    status_diagnostics = {
        style = false,  -- custom hl
        min_width = 66, -- minimum window width to show component
    },
    tabline_diagnostics = {
        style = true, -- custom hl
    },
    diff = {
        style = false,  -- custom hl
        min_width = 68, -- mininum window width to show component
    },
    pwd = {
        truncation_target = 32,
    },
    indentation = {
        min_width = 60, -- mininum window width to show component
    },
    lsp_status = {
        min_width = 70,           -- minimum window width to show component
        show_progress_msg = true, -- show progress message
        progress_msg_length = 32, -- max length of progress message, should be > 3
        ignored = {
            "null-ls",
            "copilot",
            "lsp_lines",
        }
    }
}

M.default_opts = _opts

---@param s string
---@param left integer?
---@param right integer?
local function with_padding(s, left, right)
    if not s or s == "" then
        return ""
    end
    left = left or 0
    right = right or 0
    if left > 0 then
        s = string.rep(" ", left) .. s
    end
    if right > 0 then
        s = s .. string.rep(" ", right)
    end
    return s
end


---@param fn StatusComponent
---@param w integer
---@return StatusComponent
local function with_win_min_width(fn, w)
    return function(ctx, opts)
        if ctx and ctx.win_width and ctx.win_width >= w then
            return fn(ctx, opts)
        end
        return ""
    end
end

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
local function statusline_left(ctx, opts)
    return
        " " ..
        with_padding(comp.winid(ctx, opts), 0, 1) ..
        with_padding(comp.filename(ctx, opts), 0, 0) ..
        with_padding("%m%r%h%w", 0, 1) ..
        with_padding(with_win_min_width(comp.diff, opts.diff.min_width)(ctx, opts), 0, 1)
end

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
local function statusline_right(ctx, opts)
    return
        " " .. -- left padding
        with_padding(with_win_min_width(lsp.lsp_status, opts.lsp_status.min_width)(ctx, opts), 0, 1) ..
        with_padding(comp.file_encoding(ctx, opts), 0, 1) ..
        with_padding(comp.file_format(ctx, opts), 0, 1) ..
        with_padding(with_win_min_width(comp.indentation, opts.indentation.min_width)(ctx, opts), 0, 3) ..
        comp.location(ctx, opts)
end

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
local function statusline_center(ctx, opts)
    return with_padding(with_win_min_width(comp.status_diagnostics, opts.status_diagnostics.min_width)(ctx, opts), 1, 1)
end

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
local function statusline_inactive_left(ctx, opts)
    return
        " " ..
        with_padding(comp.winid(ctx, opts), 0, 1) ..
        with_padding(comp.filename(ctx, opts), 0, 0) ..
        with_padding("%m%r%h%w", 0, 1)
end

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
local function statusline_inactive_right(ctx, opts)
    return
        "  " .. -- left padding
        comp.location(ctx, opts)
end

---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
---@return string
local function statusline_inactive_center(ctx, opts)
    return ""
end

function M.tabline()
    local ctx = get_context()
    if not ctx then
        return ""
    end

    local pwd = with_padding(comp.pwd(ctx, _opts), 1, 1)
    if _opts.tabline.style and pwd ~= "" then
        -- NOTE: tabline is not so frequently refeshed,
        --   mode is not reflected in real time
        local mode_hl = "MyTabLineHeader"
        pwd = hl.with_hl(pwd, mode_hl)
        pwd = pwd .. " "
    end

    return
        pwd ..
        with_padding(comp.g_git_branch(ctx, _opts), 0, 1) ..
        with_padding(comp.tabline_diagnostics(nil, _opts), 0, 1) ..
        with_padding(comp.tabs(ctx, _opts), 1, 0)
end

function M.statusline()
    local ctx = get_context()
    if not ctx then
        return ""
    end

    -- TODO: disable statusline for certain buf/ft
    if vim.tbl_contains(_opts.statusline_exclude.filetypes, ctx.filetype) then
        return ""
    end
    if vim.tbl_contains(_opts.statusline_exclude.buftypes, ctx.buftype) then
        return ""
    end
    if vim.tbl_contains(_opts.statusline_exclude.filenames, ctx.filename) then
        return ""
    end

    -- Apply mode-based highlight for active statusline
    if ctx.is_current then
        local left = statusline_left(ctx, _opts)
        local center = statusline_center(ctx, _opts)
        local right = statusline_right(ctx, _opts)

        local active = left .. "%=" .. center .. "%=" .. right
        return hl.with_hl(active, "StatusLine")
    else
        local left = statusline_inactive_left(ctx, _opts)
        local center = statusline_inactive_center(ctx, _opts)
        local right = statusline_inactive_right(ctx, _opts)
        local inactive = left .. "%=" .. center .. "%=" .. right
        return inactive
    end
end

---@param opts customs.status.StatusOptions?
function M.setup(opts)
    _opts = vim.tbl_deep_extend("force", _opts, opts or {})

    require("x.plugin.status.hl").setup(_opts)

    vim.o.statusline = "%!v:lua.require('x.plugin.status').statusline()"
    vim.o.tabline = "%!v:lua.require('x.plugin.status').tabline()"

    vim.o.showtabline = 2 -- Always show tabline
end

return M
