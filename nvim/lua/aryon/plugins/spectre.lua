return {
    "windwp/nvim-spectre",
    cmd = {
        "Spectre",
    },
    enabled = false,
    config = function()
        require("spectre").setup({
            default = {
                find = {
                    --pick one of item in find_engine
                    cmd = "rg",
                    options = { "ignore-case", "hidden" },
                },
            },
        })
    end,
}
