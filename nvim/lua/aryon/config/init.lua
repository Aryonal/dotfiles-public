-- print("[debug] Loading aryon.config")
-- somehow works like vim.g
-- TODO: use vim.g to pass the config, and create a Config class for definition
local cfg = {
    code_style = {
        MAX_LENGTH = 120, -- magic number
        go = {
            MAX_LENGTH = 120,
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
            border = "none", -- :help nvim_open_win()
            lsp_hover_border = "rounded",
            highlights = "NormalFloat:NormalFloat,Normal:Normal,FloatBorder:FloatBorder",
        },
        statusline = {
            global = false,
            excluded_ft = require("aryon.config.ft").statusbar_exclude,
        },
        tabline = {
            hide_if_only_one_tab = false,
            excluded_ft = require("aryon.config.ft").winbar_exclude,
        },
        winbar = {
            excluded_ft = require("aryon.config.ft").winbar_exclude,
        },
        blink = {
            custom_ui = {
                enabled = true,
                border = "rounded",
                winhighlight = "NormalFloat:NormalFloat,Normal:Normal,FloatBorder:FloatBorder",
            }
        }
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
            goto_references = "gR",
            goto_references_default = "grr",
            goto_implementations_default = "gri",
            goto_type_defenitions_default = "grt",
            show_diagnostics_inline = "<leader>e",
            show_diagnostics_float_buffer = "<leader>q",
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
}

local ok, _ = pcall(require, "aryon.patch.secret.config")
if ok then
    cfg = require("aryon.patch.secret.config")(cfg)
end

return cfg
