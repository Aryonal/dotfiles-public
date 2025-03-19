return {
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
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
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        event = require("utils.lazy").events_presets.setA,
        config = function()
            local mason_lspconfig = require("mason-lspconfig")

            mason_lspconfig.setup({
                ensure_installed = {},
                automatic_installation = false,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "netmute/ctags-lsp.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
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

            local cfg = lsp.default
            cfg.filetypes = require("aryon.config").ctags.languages

            lspconfig.ctags_lsp.setup(cfg)
        end,
    },
}
