return {
    {
        "pwntester/octo.nvim",
        enabled = false,
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- "nvim-telescope/telescope.nvim",
            -- "ibhagwan/fzf-lua",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local picker
            if vim.g.has_fzf_lua then
                picker = "fzf-lua"
            elseif vim.g.has_telescope then
                picker = "telescope"
            end

            require("octo").setup({
                picker = picker,
            })
        end
    }
}
