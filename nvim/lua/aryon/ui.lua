local signs = require("share.icons")
local ua = require("utils.vim")
local cfg = require("aryon.config")

-- setup customized UI for lsp
ua.setup_lsp_float_borders(cfg.ui.float.border)
ua.setup_lsp_diagnostics_icons(signs.error, signs.warn, signs.hint, signs.info)
ua.setup_lsp_diagnostics_text(signs.diagnostics_prefix, cfg.ui.virtual_text_space)

-- setup statusline and tabline
local stl = require("utils.statusline").config({
    g_var = {
        git_status = cfg.vim.g_git_status_var
    }
}) -- use default
local git_watcher = require("utils.git").new(function(status)
    if vim.g[stl.cfg.g_vars.git_status] == nil then
        vim.g[stl.cfg.g_vars.git_status] = 0
    end

    vim.g[stl.cfg.g_vars.git_status] = status.n_changed and status.n_changed or 0
end)

git_watcher:start()

local M = {}

function M.tabline_string()
    return stl.tabline_string()
end

vim.o.tabline = "%!v:lua.require('aryon.ui').tabline_string()"
vim.o.showtabline = 2

return M
