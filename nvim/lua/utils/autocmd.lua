local M = {}

-- Create autocmd. Usage: `create_autocmd(opts)`
--
-- `opts`:
-- ```lua
-- {
--      events = {},
--      group_name = "",
--      desc = "",
--      pattern = nil,
--      callback = function () {}
-- }
-- ```
function M.create_autocmd(opts)
    local custom_aug = vim.api.nvim_create_augroup(opts.group_name, { clear = true })
    vim.api.nvim_create_autocmd(opts.events, {
        group = custom_aug,
        desc = opts.desc,
        pattern = opts.pattern,
        callback = opts.callback,
    })
end

return M
