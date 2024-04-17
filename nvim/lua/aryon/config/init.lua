local cfg = {
    code_style = {
        MAX_LENGTH = 120, -- magic number
        go = {
            MAX_LENGTH = 120,
            go_tests_template_dir = "~/.local/share/gotests",
        },
        sql = {
            dialect = "mysql",
        }
    },
    colors = {
        background = "dark",
    },
    lsp = {
        ensured_servers = {},
        semantic_tokens = false,
        inlay_hints = false, -- FIX: enabled in > v0.10.0
    },
    vim = {
        default_delay_ms = 300,
        auto_load_session_local = true,
        auto_save_session_local = true,
    },
    ui = {
        virtual_text_space = 1,
        float = {
            border = "rounded", -- :help nvim_open_win()
            highlights = "NormalFloat:NormalFloat,Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        },
    },
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
            goto_references = "gr",
            goto_implementations = "gi",
            goto_type_defenitions = "gD",
            show_diagnostics_inline = "<leader>e",
            show_diagnostics_float_buffer = "<leader>q",
        },
        motion = {
            buffer = {
                diagnostics_next = "]d",
                diagnostics_previous = "[d",
                git_hunk_next = "]h",
                git_hunk_previous = "[h",
                aerial_next = "]a",
                aerial_previous = "[a",
                -- textobjext
                function_next = "]f",
                function_previous = "[f",
                -- vim default
                pattern_next = "*",
                fold_end = "]z",
                fold_beg = "[z",
            },
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
            toggle = "<leader><leader>",
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
