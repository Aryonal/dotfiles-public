return {
    "rebelot/kanagawa.nvim",
    enabled = false,
    lazy = false,
    -- version = "*",
    config = function()
        require("kanagawa").setup({
            overrides = function(colors)
                local theme = colors.theme
                local bg = colors.theme.ui.bg

                local Color = require("kanagawa.lib.color")
                local err = Color(theme.diag.error)
                local warn = Color(theme.diag.warning)
                local info = Color(theme.diag.info)
                local hint = Color(theme.diag.hint)
                local ok = Color(theme.diag.ok)

                local diag_bg = function(c)
                    return c:brighten(-0.65, bg):saturate(-0.6):to_hex()
                end

                local err_bg = diag_bg(err)
                local warn_bg = diag_bg(warn)
                local info_bg = diag_bg(info)
                local hint_bg = diag_bg(hint)
                local ok_bg = diag_bg(ok)

                return {
                    IlluminatedWordText = { link = "CursorLine" },
                    IlluminatedWordRead = { link = "CursorLine" },
                    IlluminatedWordWrite = { link = "CursorLine" },
                    GitSignsCurrentLineBlame = { fg = colors.theme.ui.nontext, bold = true },
                    -- builtin
                    DiagnosticError = { fg = theme.diag.error, bg = err_bg },
                    DiagnosticWarn = { fg = theme.diag.warning, bg = warn_bg },
                    DiagnosticInfo = { fg = theme.diag.info, bg = info_bg },
                    DiagnosticHint = { fg = theme.diag.hint, bg = hint_bg },
                    DiagnosticOk = { fg = theme.diag.ok, bg = ok_bg },
                    NonText = { link = "Whitespace" },
                    -- transparent float
                    NormalFloat = { bg = "none" },
                    FloatBorder = { bg = "none" },
                    FloatTitle = { bg = "none" },
                }
            end,
            compile = false,
        })

        require("kanagawa").load("dragon") -- wave, dragon, lotus
    end,
}
