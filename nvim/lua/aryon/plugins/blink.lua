local ui = require("aryon.config").ui
local signs = require("share.icons")

return {
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "giuxtaposition/blink-cmp-copilot",
        },
        version = "*",
        opts = {
            keymap = {
                preset = "enter",
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<C-y>"] = { "scroll_documentation_up", "fallback" },
                ["<C-e>"] = { "scroll_documentation_down", "fallback" },
                ["<C-b>"] = { "snippet_backward", "fallback" },
                ["<C-f>"] = { "snippet_forward", "fallback" },
                ["<C-c>"] = { "hide", "fallback" },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono"
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "copilot" },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
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
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = ui.float.border,
                    winhighlight = ui.float.highlights,
                },
            },
            completion = {
                list = {
                    selection = "manual",
                },
                documentation = {
                    window = {
                        border = ui.float.border,
                        winhighlight = ui.float.highlights,
                    },
                    auto_show = true,
                    auto_show_delay_ms = 500,
                },
                menu = {
                    border = ui.float.border,
                    winhighlight = ui.float.highlights,
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
        },
        opts_extend = { "sources.default" }
    }
}
