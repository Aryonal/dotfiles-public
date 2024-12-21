--- Statusline utility functions
--- This module provides utility functions for statusline components.
--- Example usage:
--- ```lua
--- vim.o.tabline = "%!v:lua.require('utils.statusline').config().tabline_string()"
--- ```
local M = {
    -- default config
    cfg = {
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
                normal_hl = "TabLine",
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

local comps = require("utils.statusline.components").setup(M.cfg)

function M.statusline_string(win_id)
    local dyna_info = string.format(
        "%s%s %s %s %s",
        comps.gitsigns_b_branch(nil, nil),
        comps.git_g_status(),
        comps.indentation(),
        comps.file_encoding(),
        comps.file_format()
    )

    local filepath = comps.filepath(M.cfg.icons.noname)
    if M.cfg.hl.enabled and M.cfg.hl.statusline.enabled and M.cfg.hl.statusline.bold then
        filepath = string.format(
            "%%#%sBold#%s%%#%s#",
            M.cfg.hl.statusline.normal_hl,
            filepath,
            M.cfg.hl.statusline.normal_hl
        )
    end

    local statusline = string.format(
        " %s %%<%%q%s%%m%%r%%h%%w %s%%= %s %%= %s %%-15(%%l,%%c%%V%%)%%P ",
        comps.winnr(win_id),
        filepath,
        comps.gitsigns_diff(M.cfg.hl.statusline.normal_hl),
        comps.diagnostics(0, M.cfg.hl.statusline.normal_hl),
        dyna_info
    )

    if M.cfg.hl.statusline.bold then
        statusline = statusline
    end

    return statusline
end

function M.inactive_statusline_string(win_id)
    local statusline = string.format(
        " %s %%<%%q%s%%m%%r%%h%%w%%=  %%-15(%%l,%%c%%V%%)%%P ",
        comps.winnr(win_id),
        comps.filepath()
    )

    return statusline
end

function M.global_statusline_string()
    return M.statusline_string()
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
    return string.format(
        "%%#TabLineFill#%s%s%s%%#TabLine#%s",
        comps.cwd(),
        git_info,
        diag_info,
        comps.tabs()
    )
end

function M.ensure_statuslines(augroup)
    if M.cfg.statusline.global then
        vim.o.laststatus = 3
        vim.o.statusline = "%!v:lua.require('utils.statusline').global_statusline_string()"
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
                    "%!v:lua.require('utils.statusline').statusline_string(" .. win_id .. ")"
                    or "%!v:lua.require('utils.statusline').inactive_statusline_string(" .. win_id .. ")"
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
    vim.o.tabline = "%!v:lua.require('utils.statusline').tabline_string()"
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
                    "%!v:lua.require('utils.statusline').winbar_string()"
                    or "%!v:lua.require('utils.statusline').inactive_winbar_string()"
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
    -- hl --
    require("utils.statusline.hl").setup(M.cfg)

    if cfg == nil then
        return M
    end
    M.cfg = vim.tbl_deep_extend("force", M.cfg, cfg)

    return M
end

return M
