return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        lazy = true,
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
                filetypes = {
                    yaml = false,
                    markdown = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ["."] = false,
                },
            })

            -- FIXME: error message when opening specific file
            -- ```
            -- [Copilot] copilot_node_command(node) is not executable
            -- ```
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = {
            "zbirenbaum/copilot.lua",
        },
        lazy = true,
        config = function()
            require("copilot_cmp").setup()
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        version = "*",
        lazy = true,
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lua",
            "zbirenbaum/copilot-cmp",
            "L3MON4D3/LuaSnip",
            "onsails/lspkind.nvim",
        },
        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            local luasnip = require("luasnip") ---@diagnostic disable-line: different-requires
            local cmp = require("cmp")
            local feedkeys = require("cmp.utils.feedkeys")
            local keymap = require("cmp.utils.keymap")
            local signs = require("share.icons")

            -- REF: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
            local function has_words_before()
                ---@diagnostic disable-next-line: deprecated
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local function get_snippet_setup()
                return {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                }
            end

            local function get_window_setup()
                local opts = require("aryon.config").ui.float
                local win_opts = {
                    border = opts.border,
                    winhighlight = opts.highlights,
                }
                return {
                    -- REF: https://github.com/hrsh7th/nvim-cmp#recommended-configuration
                    completion = cmp.config.window.bordered(win_opts),
                    documentation = cmp.config.window.bordered(win_opts),
                }
            end

            local function get_default_view_setup()
                return {                -- REF: https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#basic-customisations
                    entries = "custom", -- can be "custom", "wildmenu" or "native"
                }
            end

            local function get_format_name_only_setup()
                return {
                    format = function(_, vim_item)
                        vim_item.kind = ""
                        vim_item.menu = ""
                        return vim_item
                    end,
                }
            end

            local function get_default_format_setup()
                local lspkind_ok, lspkind = pcall(require, "lspkind")
                local source_map = {
                    buffer = "[Buffer]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    latex_symbols = "[LaTeX]",
                    nvim_lsp_signature_help = "[Signature]",
                    copilot = "[Copilot]",
                }
                if lspkind_ok then
                    return {
                        format = lspkind.cmp_format({
                            mode = "symbol_text",  -- show only symbol annotations
                            maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                            preset = "default",
                            symbol_map = {
                                Copilot = "",
                            },
                            menu = source_map,
                        }),
                    }
                end
                -- without lspkind
                return {
                    format = function(entry, vim_item)
                        -- Kind icons
                        vim_item.kind = string.format("%s %s", signs.lsp_kind[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
                        -- Source
                        vim_item.menu = source_map[entry.source.name]
                        return vim_item
                    end,
                }
            end

            local function next_item(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end

            local function next_item_cmdline()
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    feedkeys.call(keymap.t("<C-z>"), "n")
                end
            end

            local function next_item_prompt(fallback)
                if cmp.visible() and has_words_before() then -- for copilot
                    cmp.select_next_item()
                    -- elseif has_words_before() then -- disable this for copilot
                    --     cmp.complete()
                else
                    fallback()
                end
            end

            local function prev_item(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end

            local function prev_item_cmdline()
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    feedkeys.call(keymap.t("<C-z>"), "n")
                end
            end

            local function luasnip_next_placeholder(fallback)
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end

            local function luasnip_prev_placeholder(fallback)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end

            local function get_keymap_setup()
                return {
                    ["<C-f>"] = cmp.mapping(luasnip_next_placeholder, { "i" }),
                    ["<C-b>"] = cmp.mapping(luasnip_prev_placeholder, { "i" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                    ["<C-e>"] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<Tab>"] = cmp.mapping(next_item_prompt, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(prev_item, { "i", "s" }),
                    ["<Down>"] = cmp.mapping(next_item, { "i", "s" }),
                    ["<C-n>"] = cmp.mapping(next_item, { "i", "s" }),
                    ["<Up>"] = cmp.mapping(prev_item, { "i", "s" }),
                    ["<C-p>"] = cmp.mapping(prev_item, { "i", "s" }),
                }
            end

            -- REF: https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua
            local function get_cmdline_keymap_setup()
                return {
                    ["<Tab>"] = {
                        c = next_item_cmdline,
                    },
                    ["<S-Tab>"] = {
                        c = prev_item_cmdline,
                    },
                    ["<Down>"] = {
                        c = next_item,
                    },
                    ["<Up>"] = {
                        c = prev_item,
                    },
                    ["<C-e>"] = {
                        c = cmp.mapping.close(),
                    },
                }
            end

            local function get_default_sources_setup()
                return {
                    { name = "copilot" },
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "nvim_lua" },
                }
            end

            local function get_sort_setup()
                return {
                    -- REF: https://github.com/hrsh7th/nvim-cmp/issues/183
                    comparators = {
                        require("copilot_cmp.comparators").prioritize,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.exact,
                        cmp.config.compare.kind,
                        cmp.config.compare.locality,
                        cmp.config.compare.score,
                        cmp.config.compare.offset,
                        -- cmp.config.compare.sort_text,
                        -- cmp.config.compare.length,
                        -- cmp.config.compare.order,
                    },
                }
            end

            -- config for lsp + nvim-cmp

            -- Setup nvim-cmp.
            cmp.setup({
                snippet = get_snippet_setup(),
                window = get_window_setup(),
                view = get_default_view_setup(),
                formatting = get_default_format_setup(),
                mapping = get_keymap_setup(),
                sources = get_default_sources_setup(),
                sorting = get_sort_setup(),
            })

            -- Set configuration for specific filetype.
            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    -- { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
                }, {
                    { name = "buffer" },
                }),
            })

            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline("/", {
                mapping = get_cmdline_keymap_setup(),
                -- mapping = cmp.mapping.preset.cmdline(), -- ref: https://github.com/hrsh7th/nvim-cmp/issues/875#issuecomment-1214416687
                view = {
                    entries = "custom", -- can be "custom", "wildmenu" or "native"
                },
                formatting = get_format_name_only_setup(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = get_cmdline_keymap_setup(),
                -- mapping = cmp.mapping.preset.cmdline(), -- ref: https://github.com/hrsh7th/nvim-cmp/issues/875#issuecomment-1214416687
                view = {
                    entries = "custom", -- can be "custom", "wildmenu" or "native"
                },
                formatting = get_format_name_only_setup(),
                sources = {
                    { name = "cmdline" },
                    { name = "path" },
                },
            })

            -- setup hl for copilot
            vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#72c44d" })
        end,
    },
    {
        "saadparwaiz1/cmp_luasnip",
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                dependencies = {
                    "rafamadriz/friendly-snippets",
                },
                version = "*",
                -- install jsregexp (optional!).
                build = "make install_jsregexp",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
            "hrsh7th/nvim-cmp", -- load after nvim-cmp
        },
        event = { "InsertEnter", "CmdlineEnter" },
    },
}
