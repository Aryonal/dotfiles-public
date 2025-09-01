local git_watcher = require("x.plugin.git").new(function(status)
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
