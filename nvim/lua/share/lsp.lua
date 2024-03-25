local M = {}

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local m = require("share.ft").lsp_on_attach_exclude_map

    if m[vim.bo.filetype] then
        return
    end

    -- if client.server_capabilities.inlayHintProvider then
    --     vim.lsp.inlay_hints.enable(bufnr, true) -- FIX: enabled in > v0.10.0
    -- end
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
