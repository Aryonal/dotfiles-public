local M = {}

local cfg = require("aryon.config")
local ft = require("aryon.config.ft")
local lsp_utils = require("utils.lsp")


--- @param bufnr number: buffer number
local function lsp_buf_keymaps(bufnr)
    if ft.lsp_on_attach_exclude_map[vim.bo[bufnr].filetype] then
        return
    end

    -- Mappings.
    local list_work_dirs_fn = function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end
    -- local sync_format_fn = function() vim.lsp.buf.format({ async = false }) end
    local keymaps = {
        { "<leader>wa", vim.lsp.buf.add_workspace_folder,    desc = "[LSP] Add workspace folders" },
        { "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "[LSP] Remove workspace folders" },
        { "<leader>wl", list_work_dirs_fn,                   desc = "[LSP] List workspace folders" },
        -- { "<leader>f",  sync_format_fn,                      desc = "[LSP] Formatting" },
        -- { "<leader>f",  sync_format_fn,                      desc = "[LSP] Formatting",              mode = "v" },
        { "<leader>rn", vim.lsp.buf.rename,                  desc = "[LSP] Rename" },
        -- { "grn",        vim.lsp.buf.rename,                  desc = "[LSP] Rename" },
        { "<leader>ca", vim.lsp.buf.code_action,             desc = "[LSP] Code action" },
        -- { "gra",        vim.lsp.buf.code_action,             desc = "[LSP] Code action" },
        { "<leader>cl", vim.lsp.codelens.run,                desc = "[LSP] Run Codelens" },
        { "<leader>sg", vim.lsp.buf.signature_help,          desc = "[LSP] Signature" },
        { "<C-s>",      vim.lsp.buf.signature_help,          desc = "[I][LSP] Signature",            mode = "i" },
    }

    -- setup on_attach function for lsp
    local bmap = require("utils.vim").set_buffer_keymap
    for _, keymap in ipairs(keymaps) do
        bmap(keymap, bufnr)
    end
end

--- @param client vim.lsp.Client: lsp client
--- @param bufnr number: buffer number
local function on_attach(client, bufnr)
    if require("aryon.config.ft").lsp_on_attach_exclude_map[vim.bo.filetype] then
        return
    end

    -- default to be on
    if not cfg.lsp.semantic_tokens then
        local cap = client.server_capabilities.semanticTokensProvider
        client.server_capabilities.semanticTokensProvider = vim.tbl_deep_extend("force", cap or {}, {
            full = false,
            range = false,
        })
    end

    -- default to be off
    if cfg.lsp.inlay_hints then
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end

    -- auto refresh codelens
    if lsp_utils.client_supports_method(client, vim.lsp.protocol.Methods.textDocument_codeLens, bufnr) then
        local au = vim.api.nvim_create_augroup("aryon/lsp/init.lua", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            group = au,
            buffer = bufnr,
            desc = "refresh codelens",
            callback = function()
                if client:is_stopped() then
                    return
                end
                vim.lsp.codelens.refresh({ bufnr = bufnr })
            end,
        })
    end

    lsp_buf_keymaps(bufnr)
end

local function client_capabilities()
    local cap = vim.lsp.protocol.make_client_capabilities()

    local ok, blink = pcall(require, "blink.cmp")
    if ok then
        cap = blink.get_lsp_capabilities(cap)
    end

    -- REF: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
    cap.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }

    if not cfg.lsp.semantic_tokens then
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

local capabilities = client_capabilities()

-- TODO: use `LspAttach` event
M.on_attach = on_attach
M.capabilities = capabilities

M.default = {
    on_attach = on_attach,
    capabilities = capabilities,
}

---@param servers string[]: list of lsp servers to configure
function M.enable(servers)
    local opts = {
        capabilities = capabilities,
    }

    for _, server in ipairs(servers) do
        vim.lsp.config(server, opts)
        vim.lsp.enable(server)
    end
end

return M
