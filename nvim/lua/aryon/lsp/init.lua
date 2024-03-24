local M = {}

local capabilities = require("share.lsp").capabilities
local on_attach_share = require("share.lsp").on_attach

local function attach_keymaps(bufnr)
    -- setup on_attach function for lsp
    local bmap = require("utils.keymap").set_buffer

    -- Mappings.
    bmap({
        key = "<leader>wa",
        cmd = "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
        desc = "[LSP] Add workspace folders",
    }, bufnr)
    bmap({
        key = "<leader>wr",
        cmd = "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
        desc = "[LSP] Remove workspace folders",
    }, bufnr)
    bmap({
        key = "<leader>wl",
        cmd = "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
        desc = "[LSP] List workspace folders",
    }, bufnr)
    bmap({
        key = "<leader>f",
        cmd = function()
            vim.lsp.buf.format({ async = false })
        end,
        desc = "[LSP] Formatting",
    }, bufnr)
    bmap({
        key = "<leader>f",
        mode = "v",
        cmd = function()
            vim.lsp.buf.format({ async = false })
        end,
        desc = "[LSP] Formatting",
    }, bufnr)

    bmap({
        key = "<leader>rn",
        cmd = "<cmd>lua vim.lsp.buf.rename()<CR>",
        desc = "[LSP] Rename",
    }, bufnr)
    bmap({
        key = "<leader>ca",
        cmd = "<cmd>lua vim.lsp.buf.code_action()<CR>",
        desc = "[LSP] Code action",
    }, bufnr)
    bmap({
        key = "<leader>sg",
        cmd = "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        desc = "[LSP] Signature",
    }, bufnr)
    bmap({
        key = "<C-s>",
        cmd = "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        mode = "i",
        desc = "[I][LSP] Signature",
    }, bufnr)
end

local function on_attach(client, bufnr)
    on_attach_share(client, bufnr)
    attach_keymaps(bufnr)
end

M.on_attach = on_attach
M.capabilities = capabilities

M.gopls = {
    on_attach = function(client, bufnr)
        if not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
                range = true,
            }
        end
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
        -- REF: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/go.lua#L23-L56
        gopls = {
            gofumpt = true,
            codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
            },
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
            analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
            buildFlags = { "-tags=wireinject", "-tags=tests" },
        },
    },
}

M.sumneko = {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        -- fix diagnostics "undefined global `vim`"
        -- REF: https://www.reddit.com/r/neovim/comments/khk335/comment/gglrg7k/?utm_source=share&utm_medium=web2x&context=3
        -- can be configured in .luarc.json as well
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
}

return M
