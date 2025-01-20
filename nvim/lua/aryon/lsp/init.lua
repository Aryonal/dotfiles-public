local M = {}

local cfg = require("aryon.config")
local ft = require("aryon.config.ft")

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
        { "<leader>ca", vim.lsp.buf.code_action,             desc = "[LSP] Code action" },
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
    -- Enable completion triggered by <c-x><c-o>
    -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local m = require("aryon.config.ft").lsp_on_attach_exclude_map

    if m[vim.bo.filetype] then
        return
    end

    -- default to be on
    if not cfg.lsp.semantic_tokens then
        -- TODO: setting semanticTokensProvider to nil doesn't work for kotlin-ls
        if client.name == "kotlin_language_server" then
        else
            client.server_capabilities.semanticTokensProvider = nil
        end
    end

    -- default to be off
    if cfg.lsp.inlay_hints then
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end


    if client.supports_method("textDocument/codeLens") then
        local au = vim.api.nvim_create_augroup("aryon/lsp/init.lua", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            group = au,
            buffer = bufnr,
            desc = "refresh codelens",
            callback = function()
                if client.is_stopped() then
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

    local ok, nvim_cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
        local c = nvim_cmp_lsp.default_capabilities()
        c.textDocument.completion.completionItem.snippetSupport = true
        cap = vim.tbl_deep_extend("force", {}, cap, c)
    end

    local ok, blink = pcall(require, "blink.cmp")
    if ok then
        cap = blink.get_lsp_capabilities(cap)
    end

    -- REF: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
    cap.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }

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

M.custom_servers = {
    gopls = {
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
                    assignVariableTypes = false,
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
    },
    lua_ls = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            -- use .luarc.json
        },
    },
    eslint = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            workingDirectories = { mode = "auto" },
        },
    },
    graphql = {
        on_attach = on_attach,
        capabilities = capabilities,
        -- need to set root_dir for graphql manually
        -- root_dir = lspconfig.util.root_pattern(".graphqlconfig", ".graphqlrc", "package.json"),
    },
    kotlin_language_server = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            formatting = {
                formatter = "none", -- none or ktfmt
            }
        },
    },
}

return M
