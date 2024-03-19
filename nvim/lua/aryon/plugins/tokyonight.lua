return {
    "folke/tokyonight.nvim",
    enabled = false,
    lazy = false,
    version = "*",
    config = function()
        vim.cmd([[
            colorscheme tokyonight-moon
        ]])
    end,
}
