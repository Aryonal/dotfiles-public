return {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
    main = "ibl",
    event = require("utils.lazy").events.SetB,
    config = function()
        require("ibl").setup({})
    end,
}
