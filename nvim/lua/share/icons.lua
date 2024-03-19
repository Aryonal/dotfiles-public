return {
    error = "E", -- ,
    warn = "W", -- ,
    hint = "H", --  󰛩  󰌵 󱩏 ﯧ 
    info = "I", -- 
    debug = "D", -- 
    code_action = "C", -- 
    -- for git
    git_unstaged = "M", -- M ✎   ±  ●
    git_staged = "✓",
    git_add = "A", -- +
    git_unmerged = "", -- ‡
    git_renamed = "→", --  ⮕ ➜ 
    git_untracked = "U", -- U  ? + ★
    git_deleted = "-", -- 󰚃 󰆴    -
    git_ignored = "◌", --  
    git_conflict = "!",
    git_branch = "", --   
    diff_add = "+",
    diff_change = "~",
    diff_delete = "-",
    -- for tree
    folder_default = "",
    folder_open = "",
    folder_empty = "",
    folder_empty_open = "",
    symlink_default = "",
    symlink_folder = "",
    symlink_folder_open = "",
    file_default = "",
    arrow_right = "",
    arrow_open = "",
    arrow_void = " ",
    added = "[+]",
    -- lsp
    diagnostics_prefix = "■", -- Could be '' '■' '●' '▎' 'x' '@'
    -- REF: https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#basic-customisations
    lsp_kind = {
        -- lspkind codicons
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
    },
    -- borders
    rounded_border = {
        top_left = "╭",
        top = "─",
        top_right = "╮",
        right = "│",
        bottom_right = "╯",
        bottom = "─",
        bottom_left = "╰",
        left = "│",
    },
    double_border = {
        top_left = "╔",
        top = "═",
        top_right = "╗",
        right = "║",
        bottom_right = "╝",
        bottom = "═",
        bottom_left = "╚",
        left = "║",
    },
    bold_border = {
        top_left = "┏",
        top = "━",
        top_right = "┓",
        right = "┃",
        bottom_right = "┛",
        bottom = "━",
        bottom_left = "┗",
        left = "┃",
    },
    border_with_highlights = function(border)
        return {
            { border.top_left, "FloatBorder" },
            { border.top, "FloatBorder" },
            { border.top_right, "FloatBorder" },
            { border.right, "FloatBorder" },
            { border.bottom_right, "FloatBorder" },
            { border.bottom, "FloatBorder" },
            { border.bottom_left, "FloatBorder" },
            { border.left, "FloatBorder" },
        }
    end,
}
