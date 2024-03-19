local M = {}

-- Setup the float window border of hover window
--
-- Example:
-- ```lua
-- setup_lsp_float_borders("single")
-- ```
--
-- `default_border` is a string of default border style of lspconfig float window. Example: `default_border = "single"`
function M.setup_lsp_float_borders(default_border)
    -- border for lsp floating windows
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or default_border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end
end

-- Setup the LSP diagnostics icons.
--
-- `error_sign`, `warn_sign`, `hint_sign`, `info_sign` are strings of the icons. Example: `error_sign = ""`
function M.setup_lsp_diagnostics_icons(error_sign, warn_sign, hint_sign, info_sign)
    -- setup diagnostics icons
    local _signs = { Error = error_sign, Warn = warn_sign, Hint = hint_sign, Info = info_sign }
    for type, icon in pairs(_signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
end

-- Setup the LSP diagnostics virtual text.
--
-- Example:
-- ```lua
-- require("appearance").setup_lsp_diagnostics_text("■", 2)
-- ```
--
-- `diagnostics_prefix` is a string of the prefix of the virtual text. Example: `diagnostics_prefix = "■"`
-- `virtual_text_spaces` is a number of the spaces between the prefix and the message. Example: `virtual_text_spaces = 2`
function M.setup_lsp_diagnostics_text(diagnostics_prefix, virtual_text_spaces)
    -- print("prefix: "..diagnostics_prefix.."\nspaces: "..tostring(virtual_text_spaces))
    diagnostics_prefix = diagnostics_prefix or "■"
    virtual_text_spaces = virtual_text_spaces or 2
    -- print("prefix: "..diagnostics_prefix.."\nspaces: "..tostring(virtual_text_spaces))

    vim.diagnostic.config({
        signs = true,
        float = {
            source = true, -- Or "always"
            -- format = function(diagnostic)
            --     return string.format("%s:%s: %s", diagnostic.source, diagnostic.code, diagnostic.message)
            -- end,
        },
        underline = true,
        -- virtual_text = false,
        virtual_text = {
            source = "if_many", -- Or "always"
            spacing = virtual_text_spaces, -- TODO: not working
            prefix = diagnostics_prefix,
            -- format = function(diagnostic)
            --     return string.format("%s:%s: %s", diagnostic.source, diagnostic.code, diagnostic.message)
            -- end,
        },
        severity_sort = true,
    })
end

return M
