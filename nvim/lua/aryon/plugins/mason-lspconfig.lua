return {
    {
        "williamboman/mason.nvim",
        config = function()
            local mason = require("mason")
            mason.setup({
                ui = { border = require("aryon.config").ui.float.border },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        init = function()
            require("utils.vim").create_autocmd({
                events = { "ColorScheme" },
                group_name = "aryon/lspconfig.lua",
                desc = "Link LspInfoBorder to FloatBorder",
                callback = function()
                    vim.cmd([[
                        hi! link LspInfoBorder FloatBorder
                    ]])
                end,
            })
        end,
        config = function()
            -- border for LspInfo window
            -- REF: https://neovim.discourse.group/t/lspinfo-window-border/1566/2
            local win = require("lspconfig.ui.windows")
            win.default_options = {
                border = require("aryon.config").ui.float.border,
            }
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        event = require("utils.lazy").events.setA,
        config = function()
            local mason_lspconfig = require("mason-lspconfig")

            mason_lspconfig.setup({ -- will internally run `require("lspconfig.**")`
                -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "sumneko_lua" }
                -- This setting has no relation with the `automatic_installation` setting.
                ensure_installed = {},

                -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
                -- This setting has no relation with the `ensure_installed` setting.
                -- Can either be:
                --   - false: Servers are not automatically installed.
                --   - true: All servers set up via lspconfig are automatically installed.
                --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
                --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
                automatic_installation = false,
            })

            -- TODO: replaced with mason-lspconfig automatic server setup
            local ok, lspconfig = pcall(require, "lspconfig")
            if not ok then
                return
            end

            local lsp = require("aryon.lsp")
            local servers = mason_lspconfig.get_installed_servers()

            for _, server in ipairs(servers) do
                local cfg = lsp.default
                if lsp.custom_servers[server] then
                    cfg = lsp.custom_servers[server]
                end
                -- other servers
                -- patches
                if server == "graphql" then
                    cfg.root_dir = lspconfig.util.root_pattern(".graphqlconfig", ".graphqlrc", "package.json")
                end

                lspconfig[server].setup(cfg)
            end
        end,
    },
}
