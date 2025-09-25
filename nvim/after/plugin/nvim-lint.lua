local ok, lint = pcall(require, "lint")
if not ok then
    return
end

local M = {}
function M.debounce(ms, fn)
    local timer = vim.uv.new_timer()
    return function(...)
        local argv = { ... }
        timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
        end)
    end
end

function M.lint(lint)
    -- Use nvim-lint's logic first:
    -- * checks if linters exist for the full filetype first
    -- * otherwise will split filetype by "." and add all those linters
    -- * this differs from conform.nvim which only uses the first filetype that has a formatter
    local names = lint._resolve_linter_by_ft(vim.bo.filetype)

    -- Create a copy of the names table to avoid modifying the original.
    names = vim.list_extend({}, names)

    -- Add fallback linters.
    if #names == 0 then
        vim.list_extend(names, lint.linters_by_ft["_"] or {})
    end

    -- Add global linters.
    vim.list_extend(names, lint.linters_by_ft["*"] or {})

    -- Filter out linters that don't exist or don't match the condition.
    local ctx = { filename = vim.api.nvim_buf_get_name(0) }
    ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
    names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if not linter then
            print("Linter not found: " .. name)
        end
        return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
    end, names)

    -- Run linters.
    if #names > 0 then
        lint.try_lint(names)
    end
end

local linters_by_ft = {
    ["*"] = { "codespell" },
    python = { "flake8" },     -- "mypy" is too laggy
    vim = { "vint" },
    sh = { "shellcheck" },
    markdown = { "markdownlint" },
    yaml = { "yamllint" },
    json = { "jsonlint" },
    go = { "golangcilint" },
    typescript = { "eslint" },
    javascript = { "eslint" },
    html = { "htmlhint" },
    java = { "checkstyle" },
    kotlin = { "ktlint" },
    tsx = { "eslint" },
    jsx = { "eslint" },
    zsh = { "shellcheck" },
    sql = { "sqlint" },
    dockerfile = { "hadolint" },
    toml = { "tomllint" },
    xml = { "xmllint" },
}

local function filter_executable(linters)
    -- TODO: filter executables on start
    local available_linters = {}
    local missing_linters = {}
    for ft, ls in pairs(linters) do
        available_linters[ft] = {}
        missing_linters[ft] = {}

        -- Check each linter for the current filetype
        for _, linter in ipairs(ls) do
            if vim.fn.executable(linter) == 1 then
                table.insert(available_linters[ft], linter)
            else
                table.insert(missing_linters[ft], linter)
            end
        end
    end
    return available_linters
end

lint.linters_by_ft = filter_executable(linters_by_ft)

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
    group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    callback = M.debounce(100, function()
        M.lint(lint)
    end),
})
