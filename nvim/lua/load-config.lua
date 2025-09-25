if vim.g.debug then print("[debug] sourcing lua/load-config.lua") end

Config = {
    lsp_semantic_tokens = false,
    lsp_inlay_hints = false,
    lsp_float_border = "rounded",
    plugin_blink_cfg = {
        custom_ui = {
            enabled = false,
            border = "none",
        }
    }
}

_G.Config = Config
