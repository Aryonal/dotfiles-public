local custom_aug = vim.api.nvim_create_augroup("aryon/lsp.lua", { clear = true })

vim.api.nvim_create_autocmd({ "LspAttach" }, {
    group = custom_aug,
    desc = "Attach LSP client to buffer",
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client == nil then
            return
        end
        require("aryon.config.lsp").on_attach(client, ev.buf)
    end,
})

local signs = require("assets.icons")
local uvim = require("utils.vim")
local cfg = require("aryon.config")

-- setup customized UI for lsp float, e.g. hover
uvim.setup_lsp_float_borders(cfg.ui.float.lsp_hover_border)
uvim.setup_lsp_diagnostics_icons(signs.error, signs.warn, signs.hint, signs.info)
uvim.setup_lsp_diagnostics_virtual_text(false, signs.diagnostics_prefix, cfg.ui.virtual_text_space, {
    [vim.diagnostic.severity.ERROR] = signs.error,
    [vim.diagnostic.severity.WARN] = signs.warn,
    [vim.diagnostic.severity.HINT] = signs.hint,
    [vim.diagnostic.severity.INFO] = signs.info,
})
