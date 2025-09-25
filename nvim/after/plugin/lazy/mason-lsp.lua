local _setup_once = require("helper.lua").once(function()
    -- packadd mason.nvim
    if MiniDeps then
        MiniDeps.add({ source = "mason-org/mason.nvim" })
        MiniDeps.add({ source = "mason-org/mason-lspconfig.nvim" })
    end

    local ok, mason = pcall(require, "mason")
    if not ok then
        return
    end
    mason.setup()

    local servers = {}

    local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not ok then
        return
    end
    mason_lspconfig.setup({
        ensure_installed = {},
        automatic_installation = false,
        automatic_enable = false,
    })
    servers = mason_lspconfig.get_installed_servers()

    local lsp_util = require("helper.vim.lsp")

    lsp_util.enable(servers, lsp_util.capabilities(Config.lsp_semantic_tokens or false))
end)

require("helper.lazy").once_on_events(
    "after/plugin/LSP.lua",
    { "BufReadPre", "BufWritePre", "BufNewFile" },
    _setup_once
)

