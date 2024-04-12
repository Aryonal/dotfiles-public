return {
    "iamcco/markdown-preview.nvim",
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown" },
    cmd = {
        "MarkdownPreviewToggle",
    },
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
        vim.g.mkdp_theme = "dark"
    end,
    config = function()
        local create_abbr_batch = require("utils.vim").batch_set_abbr
        local abbrs = {
            {
                name = "mp",
                cmd = "MarkdownPreviewToggle",
                desc = "[MarkdownPreview] Toggle",
            },
        }
        create_abbr_batch(abbrs)
    end,
}
