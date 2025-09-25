local ok, ts = pcall(require, "nvim-treesitter")
if ok then
    local ensureInstalled = {
        "all",
    }
    local alreadyInstalled = require("nvim-treesitter.config").get_installed()
    local parsersToInstall = vim.iter(ensureInstalled)
        :filter(function(parser) return not vim.tbl_contains(alreadyInstalled, parser) end)
        :totable()
    ts.install(parsersToInstall)

    -- auto-start highlights & indentation
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TSHighlightIndent", { clear = true }),
        desc = "Enable treesitter highlighting",
        callback = function(ctx)
            -- highlights
            local hasStarted = pcall(vim.treesitter.start) -- errors for filetypes with no parser

            -- indent
            local noIndent = {}
            if hasStarted and not vim.list_contains(noIndent, ctx.match) then
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end,
    })
end
