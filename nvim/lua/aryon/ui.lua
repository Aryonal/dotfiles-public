local signs = require("share.icons")
local uvim = require("utils.vim")
local cfg = require("aryon.config")

-- setup customized UI for lsp float, e.g. hover
uvim.setup_lsp_float_borders(cfg.ui.float.border)
uvim.setup_lsp_diagnostics_icons(signs.error, signs.warn, signs.hint, signs.info)
uvim.setup_lsp_diagnostics(false, signs.diagnostics_prefix, cfg.ui.virtual_text_space, {
    [vim.diagnostic.severity.ERROR] = signs.error,
    [vim.diagnostic.severity.WARN] = signs.warn,
    [vim.diagnostic.severity.HINT] = signs.hint,
    [vim.diagnostic.severity.INFO] = signs.info,
})

local git_watcher = require("utils.git_watcher").new(function(status)
    if vim.g.statusline_git_status == nil then
        vim.g.statusline_git_status = 0
    end

    status.n_changed = status.n_changed or 0
    if vim.g.statusline_git_status ~= status.n_changed then
        vim.g.statusline_git_status = status.n_changed

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
local stl = require("utils.statusline").setup({
    statusline = cfg.ui.statusline,
    tabline = cfg.ui.tabline,
})

local augroup = vim.api.nvim_create_augroup("utils/statusline.lua", {})

stl.ensure_tabline()
stl.ensure_statuslines(augroup)
-- stl.ensure_winbar(augroup)

-- vim.o.winbar = "%!v:lua.require('aryon.ui').statusline_string()"

return M
