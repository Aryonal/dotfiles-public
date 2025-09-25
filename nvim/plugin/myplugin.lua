require("plugin.fold").setup()
require("plugin.qol").setup()
require("plugin.sessions").setup({
    auto_save_on_leave = true,
    auto_load_on_enter = false,
    override_non_empty = false,  -- deprecated
})
require("plugin.status").setup() -- TODO: remove setup
require("plugin.gf").setup()

require("plugin.git").new(function(status)
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

    vim.schedule(function()
        vim.cmd("redrawstatus")
        vim.cmd("redrawtabline")
    end)
end, {
    enable_git_head = true,
    enable_git_status = false,
}):start()

require("plugin.term").setup()
