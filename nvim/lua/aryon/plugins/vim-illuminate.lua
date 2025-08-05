return {
    "RRethy/vim-illuminate", -- To highlight occurrences under cursor
    event = require("utils.lazy").events_presets.LazyFile,
    enabled = true,
    init = function()
        vim.cmd([[
            hi! link IlluminatedWordRead LspReferenceText
            hi! link IlluminatedWordWrite LspReferenceText
            hi! link IlluminatedWordText LspReferenceText
        ]])
        require("utils.vim").create_autocmd({
            events = { "ColorScheme" },
            group_name = "aryon/illuminate.lua",
            desc = "Link IlluminatedWord* to Visual",
            callback = function()
                vim.cmd([[
                    hi! link IlluminatedWordRead LspReferenceText
                    hi! link IlluminatedWordWrite LspReferenceText
                    hi! link IlluminatedWordText LspReferenceText
                ]])
            end,
        })
    end,
    config = function()
        local ft = require("aryon.config.ft")

        -- default configuration
        require("illuminate").configure({
            -- providers: provider used to get references in the buffer, ordered by priority
            providers = {
                "lsp",
                "treesitter",
                "regex",
            },
            -- delay: delay in milliseconds
            delay = 600,
            -- filetype_overrides: filetype specific overrides.
            -- The keys are strings to represent the filetype while the values are tables that
            -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
            filetype_overrides = {},
            -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
            filetypes_denylist = ft.illuminate_exclude,
            -- filetypes_allowlist: filetypes to illuminate, this is overridden by filetypes_denylist
            -- filetypes_allowlist = {},
            -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
            -- modes_denylist = {},
            -- modes_allowlist: modes to illuminate, this is overridden by modes_denylist
            -- modes_allowlist = {},
            -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
            -- Only applies to the 'regex' provider
            -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
            -- providers_regex_syntax_denylist = {},
            -- providers_regex_syntax_allowlist: syntax to illuminate, this is overridden by providers_regex_syntax_denylist
            -- Only applies to the 'regex' provider
            -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
            -- providers_regex_syntax_allowlist = {},
            -- under_cursor: whether or not to illuminate under the cursor
            under_cursor = true,
        })
    end,
}
