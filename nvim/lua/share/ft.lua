local M = {}

local base_exclude = {
    "DiffviewFiles",
    "DressingInput",
    "NvimTree",
    "TelescopePrompt",
    "aerial",
    "dirvish",
    "fugitive",
    "lazy",
    "lspinfo",
    "mason",
    "neo-tree-popup",
    "nerdtree",
    "no-neck-pain",
    "null-ls-info",
    "toggleterm",
}

local extend = {
    "neo-tree",
    "",
}

local function to_table(ls)
    local tbl = {}
    for _, f in ipairs(ls) do
        tbl[f] = true
    end
    return tbl
end

M.base_exclude = base_exclude

M.lsp_on_attach_exclude = vim.list_extend(extend, base_exclude)

M.lsp_on_attach_exclude_map = to_table(M.lsp_on_attach_exclude)

M.illuminate_exclude = vim.list_extend(extend, base_exclude)

M.lualine_winbar_exclude = vim.list_extend({}, base_exclude)

M.lualine_statusbar_exclude = vim.list_extend({}, base_exclude)

M.comment_toggle_exclude = vim.list_extend(extend, base_exclude)

return M
