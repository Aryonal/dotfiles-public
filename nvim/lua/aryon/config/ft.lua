local M = {}

local base = {
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

local extended = vim.list_extend({
    "neo-tree",
    "help",
    "",
}, base)

local function to_table(ls)
    local tbl = {}
    for _, f in ipairs(ls) do
        tbl[f] = true
    end
    return tbl
end

M.base_exclude = base

M.extended_exclude = extended

M.lsp_on_attach_exclude = extended

M.lsp_on_attach_exclude_map = to_table(M.lsp_on_attach_exclude)

M.illuminate_exclude = extended

M.lualine_winbar_exclude = base

M.lualine_statusbar_exclude = base

M.comment_toggle_exclude = extended

return M
