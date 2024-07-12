local signs = require("share.icons")
local ua = require("utils.vim")
local cfg = require("aryon.config")

-- setup customized UI for lsp
ua.setup_lsp_float_borders(cfg.ui.float.border)
ua.setup_lsp_diagnostics_icons(signs.error, signs.warn, signs.hint, signs.info)
ua.setup_lsp_diagnostics_text(signs.diagnostics_prefix, cfg.ui.virtual_text_space)

local git_watcher = require("utils.git").new(function(status)
    if vim.g[cfg.vim.g_var_git_status] == nil then
        vim.g[cfg.vim.g_var_git_status] = 0
    end

    status.n_changed = status.n_changed or 0
    if vim.g[cfg.vim.g_var_git_status] ~= status.n_changed then
        vim.g[cfg.vim.g_var_git_status] = status.n_changed

        vim.schedule(function()
            vim.cmd([[
                redrawtabline
            ]])
        end)
    end
end)

git_watcher:start()

local M = {}

-- setup statusline and tabline
local stl = require("utils.statusline").config({
    g_var = {
        git_status = cfg.vim.g_var_git_status
    }
})

function M.tabline_string()
    return stl.tabline_string()
end

vim.o.tabline = "%!v:lua.require('aryon.ui').tabline_string()"
vim.o.showtabline = 2

return M
