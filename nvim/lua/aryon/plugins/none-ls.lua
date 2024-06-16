---@diagnostic disable: missing-parameter
return {
    "nvimtools/none-ls.nvim",
    enabled = true,
    dependencies = { "nvim-lua/plenary.nvim", "mason.nvim" },
    init = function()
        require("utils.vim").create_autocmd({
            events = { "ColorScheme" },
            group_name = "aryon/none-ls.lua",
            desc = "Link NulllsInfoBorder to FloatBorder",
            callback = function()
                vim.cmd([[
                        hi! link NulllsInfoBorder FloatBorder
                    ]])
            end,
        })
    end,
    config = function()
        local lsp = require("aryon.lsp")
        local style = require("aryon.config").code_style

        local null_ls = require("null-ls")

        local sources = {
            -- tools without local executable
            null_ls.builtins.completion.spell,
            -- null_ls.builtins.code_actions.gitsigns,
        }
        -- for more sources, refer https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md

        local cached_executables = {}

        local function _executable(exec)
            if cached_executables[exec] then
                return true
            end
            if vim.fn.executable(exec) == 1 then
                cached_executables[exec] = true
                return true
            end
            return false
        end

        local function _has_executable(exec)
            if type(exec) == "table" then
                local _r = false
                for _, e in ipairs(exec) do
                    _r = _r or _executable(e)
                end
                return _r
            end
            return _executable(exec)
        end

        ---@param tb table: source tables
        ---@param interf string: name of interface, one of diagnostics, code_actions, hover, formatting...
        ---@param name string: name of resource
        ---@param exec string | table: executable name or path
        ---@param opts table: null-ls resource options, will be passed to `null_ls.builtin.interf.name.with()`
        local function _append_source(tb, interf, name, exec, opts)
            if not exec then
                exec = name
            end
            if _has_executable(exec) then
                if opts ~= nil then
                    table.insert(tb, null_ls.builtins[interf][name].with(opts))
                else
                    table.insert(tb, null_ls.builtins[interf][name])
                end
            end
        end

        -- General
        _append_source(sources, "diagnostics", "semgrep")
        _append_source(sources, "diagnostics", "codespell")
        -- _append_source(sources, "formatting", "codespell")
        _append_source(sources, "formatting", "prettier", { "./node_modules/.bin/prettier", "prettier" }, {
            prefer_local = "node_modules/.bin" })
        -- _append_source(sources, "formatting", "prettierd")
        -- _append_source(sources, "formatting", "prettier_d_slim")
        -- _append_source(sources, "code_actions", "refactoring")
        _append_source(sources, "hover", "dictionary", "curl")

        -- Golang
        _append_source(sources, "formatting", "gofumpt")
        local _args = { "-rm-unused", "-format", "$FILENAME" }
        if style.go.org_prefix and style.go.org_prefix ~= "" then
            _args = vim.list_extend({ "-company-prefixes", style.go.org_prefix }, _args)
        end
        _append_source(sources, "formatting", "goimports_reviser", "goimports-reviser", { args = _args })
        _append_source(sources, "formatting", "golines", "golines", {
            extra_args = { "-m", tostring(style.go.MAX_LENGTH), "-w" } })

        -- SQL
        _append_source(sources, "diagnostics", "sqlfluff", "sqlfluff", {
            extra_args = { "--dialect", style.sql.dialect },
        })
        -- _append_source(sources, "formatting", "sqlfluff", "sqlfluff", {
        --     extra_args = { "--dialect", style.sql.dialect },
        -- })
        -- _append_source(sources, "formatting", "sqlfmt")
        -- _append_source(sources, "formatting", "sql_formatter", "sql-formatter")

        -- Lua -> use lua_ls

        -- Python -> Use ruff

        -- Terraform
        -- _append_source(sources, "formatting", "terraform_fmt", "terraform")

        -- sh, zsh
        _append_source(sources, "diagnostics", "zsh")
        -- _append_source(sources, "formatting", "beautysh")
        _append_source(sources, "formatting", "shellharden")
        _append_source(sources, "formatting", "shfmt")
        -- _append_source(sources, "code_actions", "shellcheck")
        -- _append_source(sources, "diagnostics", "shellcheck")

        -- Protobuf
        -- _append_source(sources, "diagnostics", "protoc_gen_lint", "protoc")
        _append_source(sources, "formatting", "buf")
        _append_source(sources, "formatting", "protolint")

        -- Bazel
        _append_source(sources, "formatting", "buildifier")
        _append_source(sources, "diagnostics", "buildifier")

        -- Makefile
        _append_source(sources, "diagnostics", "checkmake")

        null_ls.setup({
            border = require("aryon.config").ui.float.border,
            on_attach = lsp.on_attach,
            sources = sources,
            diagnostics_format = "#{s}:#{c}: #{m}",
        })
    end,
}
