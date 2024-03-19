-- setup customized UI for lsp
local signs = require("share.icons")
local ua = require("utils.appearance")

ua.setup_lsp_float_borders(require("aryon.config").ui.float.border)
ua.setup_lsp_diagnostics_icons(signs.error, signs.warn, signs.hint, signs.info)
ua.setup_lsp_diagnostics_text(signs.diagnostics_prefix, require("aryon.config").ui.virtual_text_space)

vim.cmd([[
    hi link LspCodeLens DiagnosticsWarn
]])
