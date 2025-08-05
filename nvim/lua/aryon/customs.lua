---Custom plugins

require("customs.fold").setup()

require("customs.gf").setup()

local git_watcher = require("customs.git").new(function(status)
    if vim.g.statusline_git_status == nil then
        vim.g.statusline_git_status = 0
    end
    if vim.g.statusline_git_branch == nil then
        vim.g.statusline_git_branch = ""
    end

    status.n_changed = status.n_changed or 0
    status.branch = status.branch or ""
    if vim.g.statusline_git_status ~= status.n_changed or vim.g.statusline_git_branch ~= status.branch then
        vim.g.statusline_git_status = status.n_changed
        vim.g.statusline_git_branch = status.branch
    end
end, {
    enable_git_head = true,
    enable_git_status = false,
})

git_watcher:start()

require("customs.sessions").setup({
    auto_save_on_leave = require("aryon.config").vim.auto_save_session_local,
    auto_load_on_enter = require("aryon.config").vim.auto_load_session_local,
    override_non_empty = false, -- deprecated
})

require("customs.term").setup({
    float = {
        -- border = vim.g.aryon_config.ui.float.border,
        toggle_key = require("aryon.config").keymaps.vim.terminal.toggle_float,
    }
})
