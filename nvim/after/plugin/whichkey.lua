local ok, whichkey = pcall(require, "which-key")
if not ok then
    return
end

vim.keymap.set("n", "<leader>?", function()
    require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

whichkey.setup({
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = " ",  -- symbol used between a key and it's label
        group = "+",      -- symbol prepended to a group
    },
    win = {
        border = vim.o.winborder or "rounded",
    },
})
