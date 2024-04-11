local signs = require("share.icons")
local ua = require("utils.appearance")
local cfg = require("aryon.config")

-- setup customized UI for lsp
ua.setup_lsp_float_borders(cfg.ui.float.border)
ua.setup_lsp_diagnostics_icons(signs.error, signs.warn, signs.hint, signs.info)
ua.setup_lsp_diagnostics_text(signs.diagnostics_prefix, cfg.ui.virtual_text_space)

