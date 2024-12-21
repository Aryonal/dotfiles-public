---@diagnostic disable: deprecated, unused-function, unused-local
return {
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        lazy = true,
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = false,
                    auto_trigger = false,
                },
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
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/nvim-cmp",
        },
        version = "v2.*",
        lazy = true,
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        enabled = false,
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-path",
            "onsails/lspkind.nvim",
            "saadparwaiz1/cmp_luasnip",
            "zbirenbaum/copilot-cmp",
        },
        event = require("utils.lazy").events.SetC,
        config = function()
            local luasnip = require("luasnip")
            local cmp = require("cmp")
            local feedkeys = require("cmp.utils.feedkeys")
            local keymap = require("cmp.utils.keymap")
            local types = require("cmp.types")
            local signs = require("share.icons")

            -- REF: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
            local function has_words_before()
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
                    cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end

            local function prev_item(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end

            local function next_item_or_show()
                if cmp.visible() then
                    cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
                else
                    cmp.complete()
                end
            end

            local function prev_item_or_show()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })
                else
                    cmp.complete()
                end
            end

            local function next_item_cmdline()
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    feedkeys.call(keymap.t("<C-z>"), "n")
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
                    ["<C-x>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }), -- replace omni func
                    ["<C-y>"] = cmp.config.disable,
                    ["<C-c>"] = cmp.mapping(cmp.mapping.abort(), { "i" }),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<Tab>"] = cmp.mapping(next_item, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(prev_item, { "i", "s" }),
                    ["<Down>"] = cmp.mapping(next_item, { "i", "s" }),
                    ["<Up>"] = cmp.mapping(prev_item, { "i", "s" }),
                    ["<C-j>"] = cmp.mapping(next_item, { "i", "s" }),
                    ["<C-k>"] = cmp.mapping(prev_item, { "i", "s" }),
                    -- mock omni func
                    ["<C-n>"] = { i = next_item_or_show },
                    ["<C-p>"] = { i = prev_item_or_show },
                }
            end

            -- REF: https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua
            local function get_cmdline_keymap_setup()
                return {
                    ["<C-x>"] = { c = cmp.mapping.complete() }, -- replace omni func
                    ["<Tab>"] = { c = next_item_cmdline },
                    ["<S-Tab>"] = { c = prev_item_cmdline },
                    -- ["<Down>"] = { c = next_item }, -- for cmd history
                    -- ["<Up>"] = { c = prev_item },
                    -- ["<C-n>"] = { c = next_item_or_show },
                    -- ["<C-p>"] = { c = prev_item_or_show },
                    ["<C-c>"] = { c = cmp.mapping.close() },
                }
            end

            local function get_default_sources_setup()
                return {
                    { name = "copilot" },
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "nvim_lua" },
                    { name = "lazydev", group_index = 0 } -- set group index to 0 to skip loading LuaLS completions
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
                sources = {
                    { name = "copilot" },
                    { name = "buffer" },
                },
            })

            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline("/", {
                mapping = get_cmdline_keymap_setup(),
                view = {
                    entries = "custom", -- can be "custom", "wildmenu" or "native"
                },
                formatting = get_format_name_only_setup(),
                sources = { { name = "buffer" } },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = get_cmdline_keymap_setup(),
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
            vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#72c44d", default = true })
        end,
    },
}
