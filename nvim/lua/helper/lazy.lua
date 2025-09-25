local M = {}

function M.once_on_events(id, events, fn)
    local aug = vim.api.nvim_create_augroup("lua/helper/lazy_" .. id, { clear = true })
    vim.api.nvim_create_autocmd(events, {
        group = aug,
        callback = function()
            vim.api.nvim_del_augroup_by_id(aug)
            -- print("[" .. id .. "]" .. " loaded")
            fn()
        end,
    })
end

M.PostFile = { "BufReadPost", "BufWritePost", "BufNewFile" } -- LazyFile
M.PreFile = { "BufReadPre", "BufWritePre", "BufNewFile" }
M.PreInsert = { "InsertEnter", "CmdlineEnter" }

return M
