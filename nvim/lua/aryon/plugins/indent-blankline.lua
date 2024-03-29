return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
        vim.opt.list = true
        vim.opt.listchars:append("space:⋅")
        vim.opt.listchars:append("eol:↴")

        require("ibl").setup({})
    end,
}
