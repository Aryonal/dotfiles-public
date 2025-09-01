local M = {}

local default_opts = {
    auto_save_on_leave = true,
    auto_load_on_enter = false,
    override_non_empty = false,  -- deprecated
    force_load_on_enter = false, -- force load on enter, overrides original buffer, if this option is true, ignore override_non_empty and auto_load_on_enter
    session_folder = vim.fn.stdpath("state") .. "/sessions",
    sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,terminal",
}

function M.setup(opts)
    local util = require("x.plugin.sessions.utils")

    opts = opts or {}
    opts = util.merge_tbl(default_opts, opts)

    ---set up autocmds
    local group = vim.api.nvim_create_augroup("aryonal/sessions.nvim", { clear = true })
    require("x.plugin.sessions.cmd").autosave_on_leave(opts, group)
    require("x.plugin.sessions.cmd").autoload_on_enter(opts, group)

    ---set up commands
    require("x.plugin.sessions.cmd").create_cmd_save(opts)
    require("x.plugin.sessions.cmd").create_cmd_load(opts)

    vim.o.sessionoptions = opts.sessionoptions
end

return M
