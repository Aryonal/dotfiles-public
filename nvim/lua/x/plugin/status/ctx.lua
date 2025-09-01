local M = {}

---@class customs.status.StatusContext
---@field win_id number
---@field buf number
---@field filename string
---@field filetype string
---@field buftype string
---@field modified boolean
---@field readonly boolean
---@field is_current boolean
---@field win_width number
---@field win_height number
---@field mode string

-- Get complete context for statusline rendering
---@return customs.status.StatusContext?
function M.get_context()
    local win_id = vim.g.statusline_winid
    if not win_id then
        return nil
    end

    local buf = vim.api.nvim_win_get_buf(win_id)
    if not vim.api.nvim_buf_is_valid(buf) then
        return nil
    end

    -- Cache expensive calls
    local current_win = vim.api.nvim_get_current_win()

    return {
        win_id = win_id,
        buf = buf,
        is_current = win_id == current_win,

        -- Window info (relatively cheap)
        win_width = vim.api.nvim_win_get_width(win_id),
        win_height = vim.api.nvim_win_get_height(win_id),

        -- Mode info (global state)
        mode = vim.fn.mode(),

        -- Buffer info (filename can be expensive for network paths)
        filename = vim.api.nvim_buf_get_name(buf),
        filetype = vim.api.nvim_get_option_value("filetype", { buf = buf }),
        buftype = vim.api.nvim_get_option_value("buftype", { buf = buf }),
        modified = vim.api.nvim_get_option_value("modified", { buf = buf }),
        readonly = vim.api.nvim_get_option_value("readonly", { buf = buf }),
    }
end

return M
