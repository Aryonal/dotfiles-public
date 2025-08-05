local go_cfg = require("aryon.config").code_style.go

return {
    {
        "aryonal/go.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        ft = {
            "go",
        },
        build = function()
            local dir = vim.fn.expand(go_cfg.go_tests_template_root)
            if not vim.uv.fs_stat(dir) then
                vim.notify(vim.fn.system({
                    "git",
                    "clone",
                    "https://github.com/cweill/gotests.git",
                    "--branch=develop",
                    "--depth=1",
                    dir,
                }))
            end
        end,
        config = function()
            local templ = go_cfg.go_tests_template_root .. "/templates/testify/"
            require("go").setup({
                run = {
                    test_flag = { "-count=1", "-race", "-cover" },
                },
                gotests = {
                    named = true,
                    template_dir = templ,
                }
            })
        end
    }
}
