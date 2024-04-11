return {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    main = "ibl",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
        require("ibl").setup({})
    end,
}
