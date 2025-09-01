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

-- work as a shared for components coordination
-- default values below, can be override by each component
-- the point of this file is to conveniently switch, and share settings across plugins
local cfg = {
    style = {
        MAX_LENGTH = 100,
        go = {
            MAX_LENGTH = 100,
            go_tests_template_root = "~/.local/share/gotests",
            org_prefix = "", -- "github.com/company/"
        },
        sql = {
            dialect = "mysql",
        }
    },
    colors = {
        background = "dark",
    },
    lsp = {
        semantic_tokens = false,
        inlay_hints = false,
    },
    vim = {
        default_delay_ms = 300,
        auto_load_session_local = false,
        auto_save_session_local = true,
    },
    ui = {
        virtual_text_space = 1,
        float = {
            border = "none",
            lsp_float_border = "none",
            highlights = "NormalFloat:NormalFloat,Normal:Normal,FloatBorder:FloatBorder",
        },
    },
    ---only to avoid conflicts
    keymaps = {
        leader = ",",
        -- editor
        ed = {
            fold = "<Space>",
        },
        -- editor/IDE features
        vim = {
            float = {
                close = { "<Esc>", "q", "<C-c>" },
            },
            terminal = {
                toggle_float = [[<C-\><C-\>]],
            },
        },
        lsp = {
            hover = "K",
            goto_definition = "gd",
            goto_references_default = "grr",
            goto_implementations_default = "gri",
            goto_type_defenitions_default = "grt",
            show_document_symbols_default = "gO",
            show_diagnostics_inline = "<leader>e",
            show_diagnostics_in_buffer = "<leader>q",
            format = "<leader>f",
        },
        motion = {
            buffer = {
                diag_next = "]d",
                diag_prev = "[d",
                git_hunk_next = "]h",
                git_hunk_prev = "[h",
                aerial_next = "]a",
                aerial_prev = "[a",
                -- treesitter
                function_next = "]f",
                function_prev = "[f",
                -- vim default
                diff_next = "]c",
                diff_prev = "[c",
                pattern_next = "*",
                fold_end = "]z",
                fold_beg = "[z",
            },
            quickfix = {
                next = "]q",
                prev = "[q",
                first = "[Q",
                last = "]Q",
            }
        },
        -- tree browser
        tree = {
            cd = "<C-]>",
            cd_parent = "-",
            close_fold = "<BS>",
            focus = "<leader><leader>",
            git_next = "]g",
            git_previous = "[g",
            grep_node = "<C-g>",
            item_enter = "<CR>",
            item_preview = "<Tab>",
            search_node = "<C-f>",
            toggle = [[<C-p>]],
        },
        -- file browser
        file = {
            add = "a",
            add_dir = "A",
            delete = "d",
            open_in_split = "<C-s>",
            open_in_tab = "<C-t>",
            open_in_vsplit = "<C-v>",
            refresh_list = { "R", "<C-r>" },
            rename = "r",
        },
    },
    plugins = {
        ---@type customs.status.StatusOptions
        status = {
            icons = {
                git_branch = require("assets.icons").git_branch,
                noname = require("assets.icons").noname,
            },
            statusline_exclude = {
                filetypes = ft.statusbar_exclude,
            },
        },
        blink = {
            custom_ui = {
                enabled = false,
                border = "rounded",
                winhighlight = "NormalFloat:NormalFloat,Normal:Normal,FloatBorder:FloatBorder",
            }
        },
        telescope = {
            prompt_border = true,
        }
    },
}

cfg.ft = ft

return cfg
