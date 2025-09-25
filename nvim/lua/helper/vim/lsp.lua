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
function M.capabilities(semantic_tokens)
    local cap = vim.lsp.protocol.make_client_capabilities()

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

-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
---@param client vim.lsp.Client
---@param method vim.lsp.protocol.Method
---@param bufnr? integer some lsp support methods only in specific files
---@return boolean
function M.client_supports_method(client, method, bufnr)
    if vim.fn.has "nvim-0.11" == 1 then
        return client:supports_method(method, bufnr)
    else
        ---@diagnostic disable-next-line: param-type-mismatch
        return client.supports_method(method, { bufnr = bufnr })
    end
end

--- REF: https://github.com/nvim-lua/kickstart.nvim/blob/3338d3920620861f8313a2745fd5d2be39f39534/init.lua#L588-L615
function M.lsp_highlight_documents(client, bufnr)
    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    if client and M.client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
        local highlight_augroup = vim.api.nvim_create_augroup("lua/helper/vim/lsp.lua::CursorMoved", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("lua/helper/vim/lsp.lua::LspDetach", { clear = true }),
            callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = "utils/lsp.lua/hl", buffer = event2.buf }
            end,
        })
    end
end

return M
