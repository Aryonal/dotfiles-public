local M = {}

---@param hl string the name of the highlight group
---@return vim.api.keyset.get_hl_info
function M.get_source_hl(hl)
    local h = vim.api.nvim_get_hl(0, { name = hl, link = true })
    while h.link do
        h = vim.api.nvim_get_hl(0, { name = h.link, link = true })
    end

    return h
end

return M
