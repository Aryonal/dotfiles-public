local ft = {}

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
    "neo-tree",
    "neo-tree-popup",
    "nerdtree",
    "no-neck-pain",
    "null-ls-info",
    "toggleterm",
    "AvanteSelectedFiles",
    "AvanteInput",
    "Avante",
    "AvanteTodos",
}

local extended = vim.list_extend({
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

ft.base_exclude = base
ft.extended_exclude = extended
ft.lsp_on_attach_exclude = extended
ft.lsp_on_attach_exclude_map = to_table(ft.lsp_on_attach_exclude)
ft.illuminate_exclude = extended
ft.winbar_exclude = base
ft.statusbar_exclude = base
ft.comment_toggle_exclude = extended

return ft
