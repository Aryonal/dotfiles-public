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
            local set = require("utils.keymap").set

            set({
                key = "<C-w>o",
                cmd = "<cmd>SaveLocalSession<CR><C-w>o",
                desc = "Full screen buffer",
            })
            set({
                key = "<C-w>u",
                cmd = "<cmd>LoadLocalSession<CR>",
                desc = "Restore full screen",
            })
        end
    },
}
