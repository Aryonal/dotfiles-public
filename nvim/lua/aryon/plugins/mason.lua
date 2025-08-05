return {
    {
        "mason-org/mason.nvim",
        config = function()
            local mason = require("mason")
            mason.setup({
                ui = { border = require("aryon.config").ui.float.border },
            })
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig", -- to have lsp/ configs ready, and make :LspInfo available
        },
        event = require("utils.lazy").events_presets.setA,
        config = function()
            local mason_lspconfig = require("mason-lspconfig")

            mason_lspconfig.setup({
                ensure_installed = {},
                automatic_installation = false,
                automatic_enable = false,
            })

            local lsp = require("aryon.config.lsp")
            local servers = mason_lspconfig.get_installed_servers()

            lsp.enable(servers)
        end,
    },
}
