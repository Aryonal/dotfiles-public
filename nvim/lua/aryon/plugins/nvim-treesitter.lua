return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = "all",

            -- Install languages synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- List of parsers to ignore installing
            -- ignore phpdoc for m1 mac. REF: https://github.com/claytonrcarter/tree-sitter-phpdoc/issues/15
            ignore_install = { "phpdoc" },

            -- experimental feature
            -- REF: https://github.com/nvim-treesitter/nvim-treesitter#indentation
            indent = {
                enable = true,
            },

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
                -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
                -- the name of the parser)
                -- list of language that will be disabled
                -- disable = { "c", "rust" },

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
        })

        -- REF: https://www.jmaguire.tech/posts/treesitter_folding/
        -- local o = vim.o
        -- o.foldlevel = 20
        -- o.foldmethod = "expr"
        -- o.foldexpr = "nvim_treesitter#foldexpr()" -- use `zx` to fix

        -- prettify folding text
        -- TODO: enable syntax highlighting  -- see: kevinhwang91/nvim-ufo
        -- FIXME: endLineText wrong in Python
        -- vim.cmd([[
        --     function! GetSpaces(foldLevel)
        --         if &expandtab == 1
        --             " Indenting with spaces
        --             let str = repeat(" ", a:foldLevel / (&shiftwidth + 1) - 1)
        --             return str
        --         elseif &expandtab == 0
        --             " Indenting with tabs
        --             return repeat(" ", indent(v:foldstart) - (indent(v:foldstart) / &shiftwidth))
        --         endif
        --     endfunction

        --     function! MyFoldText()
        --         let startLineText = getline(v:foldstart)
        --         let endLineText = trim(getline(v:foldend))
        --         let indentation = GetSpaces(foldlevel("."))
        --         let spaces = repeat(" ", 200)

        --         let str = indentation . startLineText . "..." . endLineText . spaces

        --         return str
        --     endfunction

        --     " Custom display for text when folding
        --     set foldtext=MyFoldText()
        -- ]])
    end,
}
