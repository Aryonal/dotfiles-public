local common_opts = {
    ft = "markdown",
}

local plugins = {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        enabled = false,
        dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you use the mini.nvim suite
        opts = {},
    },
}

for i, plugin in ipairs(plugins) do
    plugins[i] = vim.tbl_deep_extend("force", plugin, common_opts)
end

return plugins
