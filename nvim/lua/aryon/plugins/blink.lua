--- TODOs
--- - [ ] custom appearance for editor and cmdline
--- - [ ] custom sources for editor and cmdline


local signs = require("assets.icons")

return {
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "giuxtaposition/blink-cmp-copilot",
            "zbirenbaum/copilot.lua",
            "Kaiser-Yang/blink-cmp-avante",
        },
        version = "*",
        config = function()
            local ui = vim.g.aryon_config.ui
            local winopts = function()
                if ui.blink.custom_ui.enabled then
                    return {
                        border = ui.blink.custom_ui.border,
                        winhighlight = ui.blink.custom_ui.winhighlight,
                    }
                else
                    return {}
                end
            end

            require("blink-cmp").setup {
                keymap = {
                    preset = "none",
                    -- select in menu
                    ["<Tab>"] = { "select_next", "fallback" },
                    ["<Down>"] = { "select_next", "fallback" },
                    ["<C-n>"] = { "select_next", "fallback" },
                    ["<S-Tab>"] = { "select_prev", "fallback" },
                    ["<Up>"] = { "select_prev", "fallback" },
                    ["<C-p>"] = { "select_prev", "fallback" },
                    ["<CR>"] = { "accept", "fallback" },
                    -- others
                    ["<C-y>"] = { "scroll_documentation_up", "fallback" },
                    ["<C-e>"] = { "scroll_documentation_down", "fallback" },
                    ["<C-b>"] = { "snippet_backward", "fallback" },
                    ["<C-f>"] = { "snippet_forward", "fallback" },
                    -- vis
                    ["<C-c>"] = { "hide", "fallback" },
                    ["<C-x>"] = { "show", "fallback" },
                    -- ["<C-x><C-o>"] = { "show", "fallback" },
                },
                appearance = {
                    use_nvim_cmp_as_default = false,
                    nerd_font_variant = "mono"
                },
                sources = {
                    default = { "lsp", "path", "snippets", "buffer", "copilot" }, -- , "markdown"
                    providers = {
                        -- markdown = {
                        --     name = "RenderMarkdown",
                        --     module = "render-markdown.integ.blink",
                        -- },
                        copilot = {
                            name = "copilot",
                            module = "blink-cmp-copilot",
                            min_keyword_length = 0,
                            score_offset = 100,
                            async = true,
                            transform_items = function(_, items)
                                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                                local kind_idx = #CompletionItemKind + 1
                                CompletionItemKind[kind_idx] = "Copilot"
                                for _, item in ipairs(items) do
                                    item.kind = kind_idx
                                end
                                return items
                            end,
                        },
                        lsp = {
                            min_keyword_length = 0, -- Number of characters to trigger provider
                        },
                        snippets = {
                            min_keyword_length = 0,
                        },
                        buffer = {
                            min_keyword_length = 3,
                            max_items = 5,
                        },
                        avante = {
                            module = "blink-cmp-avante",
                            name = "Avante",
                            opts = {
                                -- options for blink-cmp-avante
                            }
                        }
                    },
                },
                signature = {
                    enabled = true,
                    window = winopts(),
                },
                completion = {
                    list = {
                        selection = { preselect = false, auto_insert = true },
                    },
                    documentation = {
                        window = winopts(),
                        auto_show = true,
                        auto_show_delay_ms = 500,
                    },
                    menu = {
                        border = winopts().border or nil,
                        winhighlight = winopts().winhighlight or nil,
                        draw = {
                            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
                            components = {
                                kind_icon = {
                                    text = function(ctx)
                                        return signs.lsp_kind[ctx.kind] .. ctx.icon_gap or
                                            ctx.kind_icon .. ctx.icon_gap
                                    end,
                                },
                            }

                        },
                    },
                },
                cmdline = {
                    enabled = true,
                    sources = function()
                        local type = vim.fn.getcmdtype()
                        -- Search forward and backward
                        if type == "/" or type == "?" then
                            return { "buffer" }
                        end
                        -- Commands
                        if type == ":" then
                            return { "cmdline" }
                        end
                        return {}
                    end,
                    keymap = {
                        preset = "inherit",

                        ["<CR>"] = { "accept_and_enter", "fallback" },
                        ["<Tab>"] = { "show", "select_next", "fallback" },
                    },
                    completion = {
                        menu = { auto_show = true },
                        list = {
                            selection = { preselect = false, auto_insert = true },
                        },

                    },
                },
            }
        end
    }
}
