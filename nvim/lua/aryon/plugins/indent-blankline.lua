return {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    main = "ibl",
    event = require("utils.lazy").events.SetB,
    config = function()
        require("ibl").setup({})
    end,
}
