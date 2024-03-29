local M = {}

---build on_attach function from config
---@param cfg table: configuration table: `share.config`
---@return function: on_attach function
function M.build_on_attach(cfg)
    ---the on_attach function for lspconfig, executed on LspAttach
    ---@param client any: client
    ---@param bufnr any: buffer number
    return function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        local m = require("share.ft").lsp_on_attach_exclude_map

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
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok, _ = pcall(require, "cmp_nvim_lsp")
if ok then
    local c = require("cmp_nvim_lsp").default_capabilities()
    c.textDocument.completion.completionItem.snippetSupport = true
    capabilities = c
end

-- REF: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

M.capabilities = capabilities

return M
