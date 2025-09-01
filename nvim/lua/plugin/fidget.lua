return {
    "j-hui/fidget.nvim",
    enabled = true,
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
