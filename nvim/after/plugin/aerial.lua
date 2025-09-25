local ok, aerial = pcall(require, "aerial")
if not ok then
    return
end

aerial.setup({
    -- Priority list of preferred backends for aerial.
    -- This can be a filetype map (see :help aerial-filetype-map)
    backends = { "lsp", "treesitter", "markdown", "man" },
    icons = require("assets.icons").lsp_kind,
    filter_kind = {
        -- "Array",
        -- "Boolean",
        "Class",
        -- "Constant",
        "Constructor",
        "Enum",
        -- "EnumMember",
        -- "Event",
        "Field",
        -- "File",
        "Function",
        "Interface",
        -- "Key",
        "Method",
        -- "Module",
        -- "Namespace",
        -- "Null",
        -- "Number",
        -- "Object",
        -- "Operator",
        -- "Package",
        "Property",
        -- "String",
        "Struct",
        -- "TypeParameter",
        -- "Variable",
    },
    -- -- Call this function when aerial attaches to a buffer.
    -- -- Useful for setting keymaps. Takes a single `bufnr` argument.
    on_attach = function(bufnr)
        local map = function(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.silent = opts.silent ~= false
            opts.buffer = bufnr
            vim.keymap.set(mode, lhs, rhs, opts)
        end
        map("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "[Aerial] Toggle" })
        -- map("n", "[a", "<cmd>AerialPrev<CR>", { desc = "[Aerial] Previous" })
        -- map("n", "]a", "<cmd>AerialNext<CR>", { desc = "[Aerial] Next" })
    end,
})
