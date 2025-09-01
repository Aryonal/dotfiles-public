local custom_aug = vim.api.nvim_create_augroup("aryon/lsp.lua", { clear = true })

local cfg = require("config")
local ft = cfg.ft
local lsp_utils = require("x.helper.lsp")

local function _lsp_hover()
    local _cfg = require("config")
    vim.lsp.buf.hover({
        border = _cfg.ui.float.lsp_float_border,
    })
end

local function _lsp_signature_help()
    local _cfg = require("config")
    vim.lsp.buf.signature_help({
        border = _cfg.ui.float.lsp_float_border,
    })
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

    -- setup on_attach function for lsp
    local bmap = require("x.helper.vim").set_buffer_keymap
    for _, keymap in ipairs(keymaps) do
        bmap(keymap, bufnr)
    end
end

--- @param client vim.lsp.Client: lsp client
--- @param bufnr number: buffer number
local function on_attach(client, bufnr)
    local _cfg = require("config")
    if ft.lsp_on_attach_exclude_map[vim.bo[bufnr].filetype] then
        return
    end

    -- default to be on
    if not _cfg.lsp.semantic_tokens then
        local cap = client.server_capabilities.semanticTokensProvider
        client.server_capabilities.semanticTokensProvider = vim.tbl_deep_extend("force", cap or {}, {
            full = false,
            range = false,
        })
    end

    -- default to be off
    if _cfg.lsp.inlay_hints then
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

local icons = require("assets.icons")
vim.diagnostic.config({
    float = {
        border = cfg.ui.float.border,
        source = true, -- Or "always"
        -- format = function(diagnostic)
        --     return string.format("%s:%s: %s", diagnostic.source, diagnostic.code, diagnostic.message)
        -- end,
    },
    underline = true,
    virtual_text = nil,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.error,
            [vim.diagnostic.severity.WARN] = icons.warn,
            [vim.diagnostic.severity.HINT] = icons.hint,
            [vim.diagnostic.severity.INFO] = icons.info,
        },
    },
})
