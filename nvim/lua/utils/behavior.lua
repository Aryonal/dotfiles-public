local M = {}

function M.setup_auto_jump_previous_window()
    -- jump to previous window when exiting
    -- REF: https://www.reddit.com/r/neovim/comments/szjysg/switching_back_to_last_accessed_window_on_closing/
    WinCloseJmp = function()
        -- Exclude floating windows
        if "" ~= vim.api.nvim_win_get_config(0).relative then
            return
        end
        -- Record the window we jump from (previous) and to (current)
        if nil == vim.t.winid_rec then
            vim.t.winid_rec = { prev = vim.fn.win_getid(), current = vim.fn.win_getid() }
        else
            vim.t.winid_rec = { prev = vim.t.winid_rec.current, current = vim.fn.win_getid() }
        end

        -- Loop through all windows to check if the previous one has been closed
        for winnr = 1, vim.fn.winnr("$") do
            if vim.fn.win_getid(winnr) == vim.t.winid_rec.prev then
                return -- Return if previous window is not closed
            end
        end

        vim.cmd([[ wincmd p ]])
    end

    -- Setup autocmd jumping to previous window
    vim.cmd([[
        augroup auto_jump_prev_win
            autocmd!
            autocmd VimEnter,WinEnter * lua WinCloseJmp()
        augroup END
    ]])
end

function M.disable_netrw()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
end


return M
