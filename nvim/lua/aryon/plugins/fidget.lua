return {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    config = function()
        require("fidget").setup({
            progress = {
                display = {
                    done_icon = "✓",
                }
            }
        })
    end,
}
