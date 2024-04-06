return {
    "aryonal/auto-sessions.nvim",
    init = function()
        local cfg = require("aryon.config")

        require("auto-sessions").setup({
            auto_save = cfg.vim.auto_save_session_local,
            auto_load = cfg.vim.auto_load_session_local,
        })
    end,
    cmd = {
        "SaveLocalSession",
        "LoadLocalSession",
    },
}
