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
    },
}
