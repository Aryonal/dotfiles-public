local M = {}

---@param servers string[]: list of lsp servers to configure
function M.enable(servers, capabilities)
    capabilities = capabilities or {}

    local opts = {
        capabilities = capabilities,
    }

    for _, server in ipairs(servers) do
        vim.lsp.config(server, opts)
        vim.lsp.enable(server)
    end
end

---@param semantic_tokens boolean: whether to enable semantic tokens or not
function M.capabilities_with_blink(semantic_tokens)
    local cap = vim.lsp.protocol.make_client_capabilities()

    local ok, blink = pcall(require, "blink.cmp")
    if ok then
        cap = blink.get_lsp_capabilities(cap)
    end

    if not semantic_tokens then
        cap = vim.tbl_deep_extend("force",
            cap,
            {
                textDocument = {
                    semanticTokens = vim.NIL,
                }
            }
        )
    end

    return cap
end

return M
