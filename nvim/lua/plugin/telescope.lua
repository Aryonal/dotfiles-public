local c = require("config").keymaps

local previewer_maker_default_opts = {
    -- disable_large_file = true,
    -- large_file_threshold = 1000000,
    disable_binary = false,
}

local previewer_factory_default_opts = previewer_maker_default_opts

local function previewer_maker_factory(previewers, factory_opts)
    factory_opts = factory_opts or previewer_maker_default_opts

    return function(filepath, bufnr, opts)
        opts = opts or {}

        filepath = vim.fn.expand(filepath)
        vim.uv.fs_stat(filepath, function(_, stat)
            if not stat then
                return
            end
            if factory_opts.disable_large_file and stat.size > factory_opts.large_file_threshold then
                return
            else
                previewers.buffer_previewer_maker(filepath, bufnr, opts)
            end
        end)
    end
end

vim.g.has_telescope = false

return {
    {
        "nvim-telescope/telescope.nvim",
        enabled = vim.g.has_telescope,
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-live-grep-args.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim",    build = "make" },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-telescope/telescope-frecency.nvim" },
            { "radyz/telescope-gitsigns",                    dependencies = { "lewis6991/gitsigns.nvim" } },
            { "tsakirist/telescope-lazy.nvim" },
        },
        event = "VeryLazy", -- for hijack vim.ui.select
        keys = {
            { ";t",                                "<cmd>Telescope tags<CR>",                      desc = "[Telescope] Tags", },
            { "<C-g><C-t>",                        "<cmd>Telescope tags<CR>",                      desc = "[Telescope] Tags", },
            { ";T",                                "<cmd>Telescope current_buffer_tags<CR>",       desc = "[Telescope] Current buffer tags", },
            { "<C-g>T",                            "<cmd>Telescope current_buffer_tags<CR>",       desc = "[Telescope] Current buffer tags", },
            { ";g",                                "<cmd>Telescope git_status<CR>",                desc = "[Telescope] Git status", },
            { "<C-g><C-g>",                        "<cmd>Telescope git_status<CR>",                desc = "[Telescope] Git status",               mode = { "i", "n" } },
            { ";G",                                "<cmd>Telescope git_signs<CR>",                 desc = "[Telescope] Git hunks", },
            { "<C-g>G",                            "<cmd>Telescope git_signs<CR>",                 desc = "[Telescope] Git hunks",                mode = { "i", "n" } },
            { ";b",                                "<cmd>Telescope buffers<CR>",                   desc = "[Telescope] Buffers", },
            { ";f",                                "<cmd>Telescope find_files<CR>",                desc = "[Telescope] Find files", },
            { "<C-g><C-f>",                        "<cmd>Telescope find_files<CR>",                desc = "[Telescope] Find files",               mode = { "i", "n" } },
            { "<C-g>F",                            "<cmd>Telescope frecency workspace=CWD<CR>",    desc = "[Telescope] Frecency",                 mode = { "i", "n" } },
            { ";s",                                "<cmd>Telescope grep_string<CR>",               desc = "[Telescope] Grep string",              mode = { "n", "v" }, },
            { "<C-g><C-s>",                        "<cmd>Telescope grep_string<CR>",               desc = "[Telescope] Grep string",              mode = { "n", "v" }, },
            { ";r",                                "<cmd>Telescope live_grep_args<CR>",            desc = "[Telescope] Live grep", },
            { "<C-g><C-r>",                        "<cmd>Telescope live_grep_args<CR>",            desc = "[Telescope] Live grep",                mode = { "i", "n" } },
            { ";/",                                "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "[Telescope] Current buffer live grep", },
            { ";R",                                "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "[Telescope] Current buffer live grep", },
            { "<C-g>R",                            "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "[Telescope] Current buffer live grep", mode = { "i", "n" } },
            { ";q",                                "<cmd>Telescope quickfix<CR>",                  desc = "[Telescope] Quickfix", },
            { "<C-g><C-q>",                        "<cmd>Telescope quickfix<CR>",                  desc = "[Telescope] Quickfix", },
            { ";d",                                "<cmd>Telescope diagnostics<CR>",               desc = "[Telescope] Diagnostics", },
            { "<C-g><C-d>",                        "<cmd>Telescope diagnostics<CR>",               desc = "[Telescope] Diagnostics", },
            { ";D",                                "<cmd>Telescope diagnostics bufnr=0<CR>",       desc = "[Telescope] Diagnostics (buffer)", },
            { "<C-g>D",                            "<cmd>Telescope diagnostics bufnr=0<CR>",       desc = "[Telescope] Diagnostics (buffer)", },
            { ";m",                                "<cmd>Telescope marks<CR>",                     desc = "[Telescope] Marks", },
            { "<C-g><C-m>",                        "<cmd>Telescope marks<CR>",                     desc = "[Telescope] Marks", },
            { ";a",                                "<cmd>Telescope aerial<CR>",                    desc = "[Telescope] Aerial", },
            { "<C-g><C-a>",                        "<cmd>Telescope aerial<CR>",                    desc = "[Telescope] Aerial", },
            { ";?",                                "<cmd>Telescope help_tags<CR>",                 desc = "[Telescope] Help tags", },
            { "<C-g>?",                            "<cmd>Telescope help_tags<CR>",                 desc = "[Telescope] Help tags", },
            { ";;",                                "<cmd>Telescope resume<CR>",                    desc = "[Telescope] Resume", },
            { "<C-g>;",                            "<cmd>Telescope resume<CR>",                    desc = "[Telescope] Resume", },
            { ";:",                                "<cmd>Telescope commands<CR>",                  desc = "[Telescope] Commands", },
            { "<C-g>:",                            "<cmd>Telescope commands<CR>",                  desc = "[Telescope] Commands", },
            -- LSP
            { c.lsp.goto_definition,               "<cmd>Telescope lsp_definitions<CR>",           desc = "[LSP] Definition", },
            { c.lsp.show_diagnostics_in_buffer,    "<cmd>Telescope diagnostics bufnr=0<CR>",       desc = "[LSP] Diagnostics (buffer)", },
            { c.lsp.goto_references_default,       "<cmd>Telescope lsp_references<CR>",            desc = "[LSP] References" },
            { c.lsp.goto_implementations_default,  "<cmd>Telescope lsp_implementations<CR>",       desc = "[LSP] Implementations", },
            { c.lsp.goto_type_defenitions_default, "<cmd>Telescope lsp_type_definitions<CR>",      desc = "[LSP] Type definitions", },
        },
        cmd = {
            "Telescope",
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local previewers = require("telescope.previewers")
            local icons = require("assets.icons")

            local lga_actions = require("telescope-live-grep-args.actions")

            local maker_opts = previewer_factory_default_opts
            local maker = previewer_maker_factory(previewers, maker_opts)

            local telescope_cfg = require("config").plugins.telescope

            telescope.setup({
                defaults = {

                    --- ivy start
                    initial_mode = "insert",
                    sorting_strategy = "ascending",
                    layout_strategy = "bottom_pane",
                    layout_config = {
                        height = 0.5,
                    },
                    border = true,
                    borderchars = {
                        prompt = telescope_cfg.prompt_border and
                            { "─", " ", " ", " ", "─", "─", " ", " " } or
                            { " ", " ", " ", " ", " ", " ", " ", " " },
                        results = { " " },
                        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                    },
                    --- ivy end

                    buffer_previewer_maker = maker,
                    mappings = {
                        n = {
                            ["<C-e>"] = actions.preview_scrolling_down,
                            ["<C-y>"] = actions.preview_scrolling_up,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-b>"] = actions.preview_scrolling_up,
                            ["<C-n>"] = actions.move_selection_next,
                            ["<C-p>"] = actions.move_selection_previous,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<CR>"] = actions.select_default + actions.center,
                            [c.file.open_in_split] = actions.select_horizontal,
                            [c.file.open_in_tab] = actions.select_tab,
                            [c.file.open_in_vsplit] = actions.select_vertical,
                            [c.vim.float.close[1]] = actions.close,
                            [c.vim.float.close[2]] = actions.close,
                            [c.vim.float.close[3]] = actions.close,
                        },
                        i = {
                            -- REF: https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#mapping-c-u-to-clear-prompt
                            -- ["<C-n>"] = false, -- default previous entry
                            -- ["<C-p>"] = false, -- default next entry
                            -- ["<C-w>"] = false, -- default delete a word
                            ["<C-f>"] = actions.preview_scrolling_down, -- default preview_scroll_left
                            ["<C-b>"] = actions.preview_scrolling_up,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<C-u>"] = false,
                            ["<CR>"] = actions.select_default + actions.center,
                            [c.file.open_in_split] = actions.select_horizontal,
                            [c.file.open_in_tab] = actions.select_tab,
                            [c.file.open_in_vsplit] = actions.select_vertical,
                            [c.vim.float.close[3]] = actions.close,
                        },
                    },
                    vimgrep_arguments = { -- be used for `live_grep` and `grep_string`, respects gitignore
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--max-columns=4096",
                        "--smart-case",
                        "--hidden",
                        "--glob=!.git/",
                        "--glob=!submodules/",
                        "--glob=!node_modules/",
                        "--glob=!vendor/",
                        -- "-u", -- unrestrict, show git ignores
                    },
                    wrap_results = true,
                },
                pickers = {
                    buffers = { show_all_buffers = true },
                    find_files = {
                        initial_mode = "insert",
                        find_command = { -- find_files respects gitignore
                            "fd",
                            "--hidden",
                            "--exclude=.git/",
                            -- "--type=f",
                            "--follow",
                            "--exclude=.git",
                            "--exclude=node_modules",
                            "--exclude=vendor",
                            "--exclude=submodules",
                            "--exclude=.cache",
                            "--exclude=__pycache__",
                            "--exclude=.idea",
                            "--exclude=.vscode",
                            "--exclude=.DS_Store",
                        },
                    },
                    git_status = {
                        git_icons = {
                            added = icons.git_add,
                            changed = icons.git_unstaged,
                            copied = ">",
                            deleted = icons.git_deleted,
                            renamed = icons.git_renamed,
                            unmerged = icons.git_unmerged,
                            untracked = icons.git_untracked,
                        },
                    },
                    grep_string = {
                        show_line = false, -- doesn't work
                        initial_mode = "insert",
                        wrap_results = false,
                    },
                    lsp_implementations = {
                        show_line = false,   -- show only filename and loc
                        jump_type = "never", -- never jump
                    },
                    lsp_definitions = {
                        show_line = false,
                        jump_type = "never",
                    },
                    lsp_type_definitions = {
                        show_line = false,
                        jump_type = "never",
                    },
                    lsp_references = {
                        show_line = false,
                        jump_type = "never",
                        include_current_line = false,
                    },
                    diagnostics = {
                        show_line = false,
                    },
                    resume = {
                        initial_mode = "normal",
                    },
                },
                extensions = {
                    live_grep_args = {
                        show_line = false,
                        initial_mode = "insert",
                        auto_quoting = true, -- enable/disable auto-quoting
                        mappings = {         -- extend mappings
                            i = {
                                -- ["<C-k>"] = lga_actions.quote_prompt(),
                                ["<Tab>"] = lga_actions.quote_prompt({ postfix = " -g " }),
                            },
                        },
                    },
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                    },
                    lazy = {
                        -- Whether or not to show the icon in the first column
                        show_icon = true,
                        -- Mappings for the actions
                        mappings = {
                            open_in_browser = "<C-o>",
                            open_in_file_browser = "<M-b>",
                            open_in_find_files = "<C-f>",
                            open_in_live_grep = "<C-g>",
                            open_plugins_picker = "<C-b>", -- Works only after having called first another action
                            open_lazy_root_find_files = "<C-r>f",
                            open_lazy_root_live_grep = "<C-r>g",
                        },
                        -- Other telescope configuration options
                    },
                    ["ui-select"] = {
                        -- require("telescope.themes").get_ivy {
                        --     initial_mode = "insert",
                        -- }
                    },
                },
            })

            -- telescope.load_extension("file_browser")
            telescope.load_extension("lazy")
            telescope.load_extension("aerial")
            telescope.load_extension("fzf")
            telescope.load_extension("live_grep_args")
            telescope.load_extension("git_signs")
            telescope.load_extension("ui-select")
            telescope.load_extension("frecency")

            local set_abbr_batch = require("x.helper.vim").batch_set_abbr
            local abbrs = {
                {
                    name = "ff",
                    cmd = "Telescope",
                    desc = "Telescope",
                },
            }
            set_abbr_batch(abbrs)
        end,
    },
}
