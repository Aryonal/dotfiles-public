return {
    "gbprod/nord.nvim",
    enabled = true,
    lazy = false,
    config = function()
        require("nord").setup({
            on_highlights = function(highlights, colors)
                highlights.NulllsInfoBorder = { link = "FloatBorder" }
                highlights.LspInfoBorder = { link = "FloatBorder" }
                highlights.GitSignsCurrentLineBlame = { link = "Comment" }
            end,
        })
        vim.cmd.colorscheme("nord")
    end,
}
