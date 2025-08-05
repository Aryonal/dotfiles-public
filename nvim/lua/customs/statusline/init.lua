--- Statusline utility functions
--- This module provides utility functions for statusline components.
--- Example usage:
--- ```lua
--- -- Setup with optional configuration overrides
--- require("customs.statusline").setup({
---   -- config overrides, e.g., icons = { git_branch = "" }
--- })
---
--- -- If needed, manually assign statusline or tabline:
--- vim.o.tabline = "%!v:lua.require('customs.statusline').tabline.string()"
--- vim.o.statusline = "%!v:lua.require('customs.statusline').statusline.string(0)"
--- ```

local stat_utils = require("customs.statusline.utils")
local ctx_from_win_id = stat_utils.ctx_from_win_id

local M = {
    -- default config
    cfg = {
        style = {
            powerline = false,
        },
        hl = {
            enabled = true,
            statusline = {
                enabled = true,
                normal_hl = "StatusLine",
                bold = true,
                diag = false,
                diff = false,
            },
            tabline = {
                enabled = true,
                normal_hl = "TabLineFill",
                bold = true,
                diag = true,
            },
        },
        icons = {
            git_branch = "",
            noname = "[無名]",
            hint = "H:",
            info = "I:",
            warn = "W:",
            err = "E:",
        },
        tabline = {
            hide_if_only_one_tab = false,
            excluded_ft = {}
        },
        statusline = {
            global = false,
            excluded_ft = {},
        },
        winbar = {
            excluded_ft = {},
        }
    },
}

-- Load components module and initialize with default config
local components = require("customs.statusline.components")
local comps = components.setup(M.cfg)

function M.statusline_string(win_id)
    local ctx = ctx_from_win_id(win_id)

    local branch = comps.gitsigns_b_branch(ctx, nil, nil) or ""
    local dyna_info = string.format(
        "%s%s %s %s %s",
        branch,
        branch ~= "" and comps.git_g_status() or "",

        comps.indentation(ctx),
        comps.file_encoding(),
        comps.file_format()
    )

    local filepath = comps.filepath(ctx, M.cfg.icons.noname)
    if M.cfg.hl.enabled and M.cfg.hl.statusline.enabled and M.cfg.hl.statusline.bold then
        filepath = stat_utils.wrap_hl(
            filepath,
            M.cfg.hl.statusline.normal_hl .. "Bold",
            M.cfg.hl.statusline.normal_hl
        )
    end

    local statusline = string.format(
        " %s %%<%%q%s%%m%%r%%h%%w %s%%= %s %%= %s %%-15(%%l,%%c%%V%%)%%P ",
        comps.winnr(ctx),
        filepath,
        comps.gitsigns_diff(M.cfg.hl.statusline.normal_hl),
        comps.diagnostics(ctx, M.cfg.hl.statusline.normal_hl),
        dyna_info
    )

    if M.cfg.hl.statusline.bold then
        statusline = statusline
    end

    return statusline
end

function M.inactive_statusline_string(win_id)
    local ctx = ctx_from_win_id(win_id)
    local statusline = string.format(
        " %s %%<%%q%s%%m%%r%%h%%w%%=  %%-15(%%l,%%c%%V%%)%%P ",
        comps.winnr(ctx),
        comps.filepath(ctx, M.cfg.icons.noname)
    )

    return statusline
end

function M.global_statusline_string()
    return M.statusline_string(0)
end

function M.nop_statusline_string()
    return "%#StatusLineNC#"
end

function M.winbar_string(win_id)
    local winbar = ""
    return winbar
end

function M.inactive_winbar_string(win_id)
    local winbar = ""
    return winbar
end

function M.tabline_string()
    local git_info = comps.gitsigns_g_branch()
    local diag_info = comps.diagnostics(nil, M.cfg.hl.tabline.normal_hl)
    if git_info ~= "" then
        local status = comps.git_g_status()
        git_info = string.format(" %s%s", git_info, status)
    end
    if diag_info ~= "" then
        diag_info = string.format(" ( %s )> ", diag_info)
    else
        diag_info = " > "
    end

    local cwd = comps.cwd()
    if M.cfg.hl.enabled and M.cfg.hl.tabline.enabled and M.cfg.hl.tabline.bold then
        cwd = require("customs.statusline.utils").wrap_hl(
            cwd,
            M.cfg.hl.tabline.normal_hl .. "Bold",
            M.cfg.hl.tabline.normal_hl
        )
    end
    return string.format(
        "%%#%s#%s%s%s%%#TabLine#%s",
        M.cfg.hl.tabline.normal_hl,
        cwd,
        git_info,
        diag_info,
        comps.tabs()
    )
end

function M.ensure_statuslines(augroup)
    if M.cfg.statusline.global then
        vim.o.laststatus = 3
        vim.o.statusline = "%!v:lua.require('customs.statusline').global_statusline_string()"
        return
    end
    -- REF: mini.statusline
    local render = vim.schedule_wrap(function()
        -- NOTE: Use `schedule_wrap()` to properly work inside autocommands because
        -- they might temporarily change current window
        local cur_win_id, is_global_stl = vim.api.nvim_get_current_win(), vim.o.laststatus == 3
        for _, win_id in ipairs(vim.api.nvim_list_wins()) do
            -- do not show statusline if current buffer win is excluded
            local buf = vim.api.nvim_win_get_buf(win_id)
            local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
            if vim.list_contains(M.cfg.statusline.excluded_ft, filetype) then
                vim.wo[win_id].statusline = M.nop_statusline_string()
            else
                vim.wo[win_id].statusline = (win_id == cur_win_id) and
                    "%!v:lua.require('customs.statusline').statusline_string(" .. win_id .. ")"
                    or "%!v:lua.require('customs.statusline').inactive_statusline_string(" .. win_id .. ")"
            end
        end
    end)

    local gr = augroup or vim.api.nvim_create_augroup("utils/statusline.lua", {})

    local au = function(event, pattern, callback, desc)
        vim.api.nvim_create_autocmd(event, { group = gr, pattern = pattern, callback = callback, desc = desc })
    end

    au({ "WinEnter", "BufWinEnter" }, "*", render, "Ensure statusline content")
end

function M.ensure_tabline()
    vim.o.tabline = "%!v:lua.require('customs.statusline').tabline_string()"
    vim.o.showtabline = 2
end

-- DEPRECATED: function is broken
function M.ensure_winbar(augroup)
    local render = vim.schedule_wrap(function()
        -- NOTE: Use `schedule_wrap()` to properly work inside autocommands because
        -- they might temporarily change current window
        local cur_win_id, is_global_stl = vim.api.nvim_get_current_win(), vim.o.laststatus == 3
        for _, win_id in ipairs(vim.api.nvim_list_wins()) do
            -- do not show statusline if current buffer win is excluded
            local buf = vim.api.nvim_win_get_buf(win_id)
            local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
            if vim.list_contains(M.cfg.winbar.excluded_ft, filetype) then
                vim.wo[win_id].winbar = nil
            else
                vim.wo[win_id].winbar = (win_id == cur_win_id) and
                    "%!v:lua.require('customs.statusline').winbar_string()"
                    or "%!v:lua.require('customs.statusline').inactive_winbar_string()"
            end
        end
    end)

    local gr = augroup or vim.api.nvim_create_augroup("utils/statusline.lua", {})

    local au = function(event, pattern, callback, desc)
        vim.api.nvim_create_autocmd(event, { group = gr, pattern = pattern, callback = callback, desc = desc })
    end

    au({ "WinEnter", "BufWinEnter" }, "*", render, "Ensure winbar content")
end

function M.setup(cfg)
    -- Merge user configuration into defaults
    if cfg ~= nil then
        M.cfg = vim.tbl_deep_extend("force", M.cfg, cfg)
    end

    -- Setup highlights
    require("customs.statusline.hl").setup(M.cfg)

    -- Re-initialize components with updated config
    comps = components.setup(M.cfg)

    -- Ensure autocommands for statusline, tabline, and winbar
    -- M.ensure_statuslines()
    -- M.ensure_tabline()
    -- M.ensure_winbar()

    return M
end

-- Structured module API
-- Group related functionality under nested tables
M.statusline = {
    string = M.statusline_string,
    inactive = M.inactive_statusline_string,
    global = M.global_statusline_string,
    nop = M.nop_statusline_string,
    ensure = M.ensure_statuslines,
}
M.tabline = {
    string = M.tabline_string,
    ensure = M.ensure_tabline,
}
M.winbar = {
    string = M.winbar_string,
    inactive = M.inactive_winbar_string,
    ensure = M.ensure_winbar,
}
M.config = M.cfg

return M
