local M = {}

local cfg = require("aryon.config")

local capabilities = require("share.lsp").capabilities
local on_attach_builder = require("share.lsp").build_on_attach

local function attach_keymaps(bufnr)
    -- Mappings.
    local keymaps = {
        { key = "<leader>wa", cmd = vim.lsp.buf.add_workspace_folder,                                        desc = "[LSP] Add workspace folders" },
        { key = "<leader>wr", cmd = vim.lsp.buf.remove_workspace_folder,                                     desc = "[LSP] Remove workspace folders" },
        { key = "<leader>wl", cmd = function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc = "[LSP] List workspace folders" },
        { key = "<leader>f",  cmd = function() vim.lsp.buf.format({ async = false }) end,                    desc = "[LSP] Formatting" },
        { key = "<leader>f",  cmd = function() vim.lsp.buf.format({ async = false }) end,                    desc = "[LSP] Formatting",              mode = "v" },
        { key = "<leader>rn", cmd = vim.lsp.buf.rename,                                                      desc = "[LSP] Rename" },
        { key = "<leader>ca", cmd = vim.lsp.buf.code_action,                                                 desc = "[LSP] Code action" },
        { key = "<leader>sg", cmd = vim.lsp.buf.signature_help,                                              desc = "[LSP] Signature" },
        { key = "<C-s>",      cmd = vim.lsp.buf.signature_help,                                              desc = "[I][LSP] Signature",            mode = "i" },
    }

    -- setup on_attach function for lsp
    local bmap = require("utils.keymap").set_buffer
    for _, keymap in ipairs(keymaps) do
        bmap(keymap, bufnr)
    end
end

local function on_attach(client, bufnr)
    on_attach_builder(cfg)(client, bufnr)
    attach_keymaps(bufnr)
end

-- TODO: use `LspAttach` event
M.on_attach = on_attach
M.capabilities = capabilities

M.gopls = {
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- gopls semantic tokens support
        if not cfg.lsp.semantic_tokens then
            return
        end
        if not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
                range = true,
            }
        end
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
                fieldalignment = false,
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
            format = {
                enable = true,
            },
        },
    },
}

return M
