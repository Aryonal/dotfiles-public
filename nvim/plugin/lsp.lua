-- print("[debug] Loading aryon.keymaps")
-- local cfg = require("config").keymaps

local function _diagnostic_float()
    vim.diagnostic.open_float()
end

local function _diagnostic_prev()
    vim.diagnostic.goto_prev()
end

local function _diagnostic_next()
    vim.diagnostic.goto_next()
end

local global_lsp_bindings = {
    { "<leader>e", _diagnostic_float, desc = "[LSP] Diagnostics (float)" },
    { "]d",        _diagnostic_next,  desc = "[LSP] Next Diagnostic" },
    { "[d",        _diagnostic_prev,  desc = "[LSP] Previous Diagnostic" },
}
local bindings = {}

vim.list_extend(bindings, global_lsp_bindings)

for _, key in ipairs(bindings) do
    vim.keymap.set(key.mode or "n", key[1], key[2], {
        desc = key.desc
    })
end

local custom_aug = vim.api.nvim_create_augroup("lua/plugin/lsp.lua", { clear = true }) -- TODO: rename

-- local cfg = require("config")
-- local ft = cfg.ft
local lsp_utils = require("helper.vim.lsp")

local function _lsp_hover()
    vim.lsp.buf.hover()
end

local function _lsp_signature_help()
    vim.lsp.buf.signature_help()
end

local list_work_dirs_fn = function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end

--- @param bufnr number: buffer number
local function lsp_buf_keymaps(bufnr)
    -- Mappings.
    local keymaps = {
        { "<C-s>",      _lsp_signature_help,                 desc = "[I][LSP] Signature",            mode = "i" },
        { "<leader>sg", _lsp_signature_help,                 desc = "[LSP] Signature" },
        { "<leader>wa", vim.lsp.buf.add_workspace_folder,    desc = "[LSP] Add workspace folders" },
        { "<leader>wl", list_work_dirs_fn,                   desc = "[LSP] List workspace folders" },
        { "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "[LSP] Remove workspace folders" },
        { "grl",        vim.lsp.codelens.run,                desc = "[LSP] Run Codelens" },
        { "K",          _lsp_hover,                          desc = "[LSP] Hover" },
    }

    for _, key in ipairs(keymaps) do
        vim.keymap.set(key.mode or "n", key[1], key[2], { desc = key.desc, buffer = bufnr })
    end
end

--- @param client vim.lsp.Client: lsp client
--- @param bufnr number: buffer number
local function on_attach(client, bufnr)
    if require("excluded-ft").lsp_on_attach_exclude_map[vim.bo[bufnr].filetype] then
        return
    end

    -- default to be on
    if not Config.lsp_semantic_tokens then
        local cap = client.server_capabilities.semanticTokensProvider
        client.server_capabilities.semanticTokensProvider = vim.tbl_deep_extend("force", cap or {}, {
            full = false,
            range = false,
        })
    end

    -- default to be off
    if Config.lsp_inlay_hints then
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end

    -- auto refresh codelens
    if lsp_utils.client_supports_method(client, vim.lsp.protocol.Methods.textDocument_codeLens, bufnr) then
        local au = vim.api.nvim_create_augroup("lua/plugin/lsp.lua", { clear = true }) -- TODO: rename

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

    if lsp_utils.client_supports_method(client, vim.lsp.protocol.Methods.textDocument_foldingRange, bufnr) then
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    lsp_buf_keymaps(bufnr)
end


vim.api.nvim_create_autocmd({ "LspAttach" }, {
    group = custom_aug,
    desc = "Attach LSP client to buffer",
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client == nil then
            return
        end
        on_attach(client, ev.buf)
    end,
})

-- local icons = require("assets.icons")
vim.diagnostic.config({
    float = {
        source = true, -- Or "always"
    },
    underline = true,
    virtual_text = nil,
    severity_sort = true,
})
