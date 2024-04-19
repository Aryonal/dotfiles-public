local go_cfg = require("aryon.config").code_style.go

return {
    {
        "aryonal/sessions.nvim",
        init = function()
            local cfg = require("aryon.config")

            require("sessions").setup({
                auto_save_on_leave = cfg.vim.auto_save_session_local,
                auto_load_on_enter = cfg.vim.auto_load_session_local,
                override_non_empty = false,
            })
        end,
        cmd = {
            "SaveLocalSession",
            "LoadLocalSession",
        },
        config = function()
            -- local set = require("utils.vim").set_keymap

            -- set({
            --     "<C-w>o",
            --     "<cmd>SaveLocalSession<CR><C-w>o",
            --     desc = "Full screen buffer",
            -- })
            -- set({
            --     "<C-w>u",
            --     "<cmd>LoadLocalSession<CR>",
            --     desc = "Revert full screen",
            -- })
        end
    },
    {
        "aryonal/gou.nvim",
        -- dir = "~/src/aryonal/gou.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        ft = {
            "go",
        },
        build = function()
            local dir = vim.fn.expand(go_cfg.go_tests_template_root)
            if not vim.loop.fs_stat(dir) then
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
            require("gou").setup({
                run = {
                    test_flag = { "-count=1", "-race" },
                },
                gotests = {
                    named = true,
                    template_dir = go_cfg.go_tests_template_root .. "/templates/testify/",
                }
            })
        end
    }
}
