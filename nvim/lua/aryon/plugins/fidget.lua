return {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
        require("fidget").setup({
            window = {
                relative = "win", -- where to anchor, either "win" or "editor"
            },
        })
    end,
}
