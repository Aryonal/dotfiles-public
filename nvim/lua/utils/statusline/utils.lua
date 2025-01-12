local M = {}

function M.wrap_hl(component, left, right)
    if not left and not right then
        return component
    end
    if not left then
        return string.format("%s%%#%s#", component, right)
    end
    if not right then
        return string.format("%%#%s#%s", left, component)
    end
    return string.format("%%#%s#%s%%#%s#", left, component, right)
end

--- ```lua
--- ctx = {
---     buf = 0,
---     win_id = 0,
--- }
--- ```

function M.ctx_from_win_id(win_id)
    if not vim.api.nvim_win_is_valid(win_id) then
        win_id = 0
    end
    local ctx = {
        win_id = win_id,
        buf = nil,
    }
    if win_id then
        -- print("win_id: " .. win_id)
        ctx.buf = vim.api.nvim_win_get_buf(win_id)
    end
    return ctx
end

function M.ctx_get_buf(ctx)
    if ctx and ctx.buf then
        return ctx.buf
    end
    if ctx.win_id then
        return vim.api.nvim_win_get_buf(ctx.win_id)
    end
end

return M
