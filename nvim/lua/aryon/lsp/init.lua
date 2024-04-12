local M = {}

local cfg = require("aryon.config")
local ft = require("aryon.config.ft")

local function lsp_buf_keymaps(bufnr)
    if ft.lsp_on_attach_exclude_map[vim.bo[bufnr].filetype] then
        return
    end

    -- Mappings.
    local list_work_dirs_fn = function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end
    local sync_format_fn = function() vim.lsp.buf.format({ async = false }) end
    local keymaps = {
        { key = "<leader>wa", cmd = vim.lsp.buf.add_workspace_folder,    desc = "[LSP] Add workspace folders" },
        { key = "<leader>wr", cmd = vim.lsp.buf.remove_workspace_folder, desc = "[LSP] Remove workspace folders" },
        { key = "<leader>wl", cmd = list_work_dirs_fn,                   desc = "[LSP] List workspace folders" },
        { key = "<leader>f",  cmd = sync_format_fn,                      desc = "[LSP] Formatting" },
        { key = "<leader>f",  cmd = sync_format_fn,                      desc = "[LSP] Formatting",              mode = "v" },
        { key = "<leader>rn", cmd = vim.lsp.buf.rename,                  desc = "[LSP] Rename" },
        { key = "<leader>ca", cmd = vim.lsp.buf.code_action,             desc = "[LSP] Code action" },
        { key = "<leader>sg", cmd = vim.lsp.buf.signature_help,          desc = "[LSP] Signature" },
        { key = "<C-s>",      cmd = vim.lsp.buf.signature_help,          desc = "[I][LSP] Signature",            mode = "i" },
    }

    -- setup on_attach function for lsp
    local bmap = require("utils.vim").set_buffer_keymap
    for _, keymap in ipairs(keymaps) do
        bmap(keymap, bufnr)
    end
end

local function on_attach(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local m = require("aryon.config.ft").lsp_on_attach_exclude_map

    if m[vim.bo.filetype] then
        return
    end

    -- default to be on
    if not cfg.lsp.semantic_tokens then
        client.server_capabilities.semanticTokensProvider = nil
    end

    -- default to be off
    if cfg.lsp.inlay_hints then
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hints.enable(bufnr, true)
        end
    end
    lsp_buf_keymaps(bufnr)
end

local function client_capabilities()
    local cap = vim.lsp.protocol.make_client_capabilities()

    local ok, _ = pcall(require, "cmp_nvim_lsp")
    if ok then
        local c = require("cmp_nvim_lsp").default_capabilities()
        c.textDocument.completion.completionItem.snippetSupport = true
        cap = c
    end

    -- REF: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
    cap.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }

    return cap
end

-- TODO: use `LspAttach` event
M.on_attach = on_attach
M.capabilities = client_capabilities()

M.default = {
    on_attach = on_attach,
    capabilities = capabilities,
}

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
