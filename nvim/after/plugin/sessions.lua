require("x.plugin.sessions").setup({
    auto_save_on_leave = require("config").vim.auto_save_session_local,
    auto_load_on_enter = require("config").vim.auto_load_session_local,
    override_non_empty = false, -- deprecated
})
