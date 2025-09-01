return {
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        keys = {
            { "<leader>lsp", "<cmd>LspInfo<CR>", desc = "[LSP] Info" },
        }
    },
    {
        "mason-org/mason.nvim",
        config = function()
            local mason = require("mason")
            mason.setup({
                ui = { border = require("config").ui.float.border },
            })
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig", -- to have lsp/ configs ready, and make :LspInfo available
        },
        event = require("x.helper.lazy").events_presets.LazyFileAndVeryLazy,
        config = function()
            local mason_lspconfig = require("mason-lspconfig")

            mason_lspconfig.setup({
                ensure_installed = {},
                automatic_installation = false,
                automatic_enable = false,
            })

            local lsp_util = require("x.helper.vim.lsp")
            local servers = mason_lspconfig.get_installed_servers()

            local function client_capabilities()
                return lsp_util.capabilities_with_blink(require("config").lsp.semantic_tokens)
            end

            lsp_util.enable(servers, client_capabilities())
        end,
    },
}
