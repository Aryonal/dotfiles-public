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
            null_ls.builtins.code_actions.gitsigns,
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

        -- @param tb: table, source tables
        -- @param interf: string, name of interface, one of diagnostics, code_actions, hover, formatting...
        -- @param name: string, name of resource
        -- @param exec: string | table, executable name or path
        -- @param opts: table, null-ls resource options, will be passed to `null_ls.builtin.interf.name.with()`
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
            prefer_local = "node_modules/.bin",
        })
        -- _append_source(sources, "formatting", "prettierd")
        -- _append_source(sources, "formatting", "prettier_d_slim")
        -- _append_source(sources, "formatting", "codespell")
        _append_source(sources, "code_actions", "refactoring")
        _append_source(sources, "hover", "dictionary", "curl")

        -- Golang
        -- _append_source(sources, "formatting", "goimports", "goimports", {
        --     extra_args = { "-local", style.go.org_prefix },
        -- })
        _append_source(sources, "formatting", "gofumpt")
        local _args = { "-rm-unused", "-format", "$FILENAME" }
        if style.go.org_prefix then
            _args = vim.list_extend({ "-company-prefixes", style.go.org_prefix }, _args)
        end
        _append_source(sources, "formatting", "goimports_reviser", "goimports-reviser", { args = _args })
        _append_source(sources, "formatting", "golines", "golines", {
            extra_args = { "-m", tostring(style.go.MAX_LENGTH), "-w" },
        })
        -- _append_source(sources, "diagnostics", "golangci_lint", "golangci-lint")
        -- _append_source(sources, "diagnostics", "staticcheck")
        -- _append_source(sources, "diagnostics", "revive") -- it's laggy

        -- JS/TS/JSX/TSX/Vue
        _append_source(sources, "code_actions", "eslint", { "./node_modules/.bin/eslint", "eslint" }, {
            only_local = "node_modules/.bin",
        })
        -- _append_source(sources, "code_actions", "eslint_d")
        -- _append_source(sources, "code_actions", "xo")
        _append_source(sources, "diagnostics", "eslint", { "./node_modules/.bin/eslint", "eslint" }, {
            only_local = "node_modules/.bin",
        })
        -- _append_source(sources, "diagnostics", "eslint_d")
        -- _append_source(sources, "diagnostics", "tsc")
        -- _append_source(sources, "diagnostics", "xo")
        -- _append_source(sources, "formatting", "eslint",{"./node_modules/.bin/eslint", "eslint"}, {
        --     only_local = "node_modules/.bin",
        -- })
        -- _append_source(sources, "formatting", "eslint_d")
        -- _append_source(sources, "formatting", "rome")
        _append_source(sources, "formatting", "rustywind")
        -- _append_source(sources, "formatting", "prettier_standard", "prettier-standard")

        -- SQL
        _append_source(sources, "diagnostics", "sqlfluff", "sqlfluff", {
            extra_args = { "--dialect", style.sql.dialect },
        })
        -- _append_source(sources, "formatting", "sqlfluff", "sqlfluff", {
        --     extra_args = { "--dialect", style.sql.dialect },
        -- })
        -- _append_source(sources, "formatting", "sqlfmt")
        -- _append_source(sources, "formatting", "sql_formatter", "sql-formatter")

        -- Lua
        -- _append_source(sources, "formatting", "stylua") -- use lua_ls builtin

        -- Python
        _append_source(sources, "formatting", "black")
        _append_source(sources, "formatting", "isort")
        _append_source(sources, "diagnostics", "pylint")

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
        -- _append_source(sources, "formatting", "buildifier")
        -- _append_source(sources, "diagnostics", "buildifier")

        -- Makefile
        _append_source(sources, "diagnostics", "checkmake")

        -- go.nvim
        -- local go_nvim_ok, _ = pcall(require, "go")
        -- if go_nvim_ok then
        --     -- run test on save
        --     -- local gotest = require("go.null_ls").gotest()
        --     -- table.insert(sources, gotest)

        --     -- run test in code action
        --     local gotest_codeaction = require("go.null_ls").gotest_action()
        --     table.insert(sources, gotest_codeaction)
        -- end

        null_ls.setup({
            border = require("aryon.config").ui.float.border,
            on_attach = lsp.on_attach,
            sources = sources,
            diagnostics_format = "#{s}:#{c}: #{m}",
        })
    end,
}
