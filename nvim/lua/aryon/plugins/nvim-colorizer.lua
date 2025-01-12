return {
    "NvChad/nvim-colorizer.lua",
    event = require("utils.lazy").events_presets.LazyFile,
    config = function()
        -- Exclude some filetypes from highlighting by using `!`
        -- REF: https://github.com/norcalli/nvim-colorizer.lua#customization
        require("colorizer").setup({
            filetypes = { "*" },
            user_default_options = {
                -- RGB = true, -- #RGB hex codes
                -- RRGGBB = true, -- #RRGGBB hex codes
                names = false, -- "Name" codes like Blue or blue
                -- RRGGBBAA = false, -- #RRGGBBAA hex codes
                -- AARRGGBB = false, -- 0xAARRGGBB hex codes
                -- rgb_fn = false, -- CSS rgb() and rgba() functions
                -- hsl_fn = false, -- CSS hsl() and hsla() functions
                -- css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                -- css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                -- -- Available modes for `mode`: foreground, background,  virtualtext
                -- mode = "background", -- Set the display mode.
                -- -- Available methods are false / true / "normal" / "lsp" / "both"
                -- -- True is same as normal
                -- tailwind = false, -- Enable tailwind colors
                -- -- parsers can contain values used in |user_default_options|
                -- sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
                -- virtualtext = "■",
                -- -- update color values even if buffer is not focused
                -- -- example use: cmp_menu, cmp_docs
                -- always_update = false,
            },
            -- all the sub-options of filetypes apply to buftypes
            buftypes = {},
        })
    end,
}
