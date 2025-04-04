local c = require("aryon.config").keymaps

local previewer_maker_default_opts = {
    disable_large_file = true,
    large_file_threshold = 100000,
    -- disable_binary = false,
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

local function with_theme(opts)
    opts.theme = "ivy"
    return opts
end

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "tsakirist/telescope-lazy.nvim" },
            { "nvim-telescope/telescope-live-grep-args.nvim" },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            {
                "radyz/telescope-gitsigns",
                dependencies = {
                    "lewis6991/gitsigns.nvim",
                }
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
        },
        event = "VeryLazy", -- for hijack vim.ui.select
        keys = {
            {
                ";t",
                "<cmd>Telescope tags<CR>",
                desc = "[Telescope] Tags",
            },
            {
                ";T",
                "<cmd>Telescope current_buffer_tags<CR>",
                desc = "[Telescope] Current buffer tags",
            },
            {
                ";g",
                "<cmd>Telescope git_status<CR>",
                desc = "[Telescope] Git status",
            },
            {
                ";G",
                "<cmd>Telescope git_signs<CR>",
                desc = "[Telescope] Git hunks",
            },
            {
                ";b",
                "<cmd>Telescope buffers<CR>",
                -- ":Neotree reveal focus buffers<CR>",
                desc = "[Telescope] Buffers",
            },
            {
                ";f",
                "<cmd>Telescope find_files<CR>",
                desc = "[Telescope] Find files",
            },
            -- {
            --     ";d",
            --     ":Telescope file_browser<CR>",
            --     desc = "[Telescope] File browser",
            -- },
            {
                ";s",
                "<cmd>Telescope grep_string<CR>",
                mode = "v",
                desc = "[Telescope] Grep string",
            },
            {
                ";s",
                "<cmd>Telescope grep_string<CR>",
                desc = "[Telescope] Grep string",
            },
            {
                ";r",
                -- ":Telescope live_grep<CR>", -- use telescope-rg instead
                "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
                desc = "[Telescope] Live grep",
            },
            {
                ";R",
                "<cmd>Telescope current_buffer_fuzzy_find<CR>",
                desc = "[Telescope] Current buffer live grep",
            },
            {
                ";q",
                "<cmd>Telescope diagnostics<CR>",
                desc = "[Telescope] Diagnostics",
            },
            {
                ";d",
                "<cmd>Telescope diagnostics<CR>",
                desc = "[Telescope] Diagnostics",
            },
            {
                ";m",
                "<cmd>Telescope marks<CR>",
                desc = "[Telescope] Marks",
            },
            {
                ";?",
                "<cmd>Telescope help_tags<CR>",
                desc = "[Telescope] Help tags",
            },
            {
                ";;",
                "<cmd>Telescope resume<CR>",
                desc = "[Telescope] Resume",
            },
            {
                ";:",
                "<cmd>Telescope commands<CR>",
                desc = "[Telescope] Commands",
            },
            -- LSP
            {
                c.lsp.goto_definition,
                "<cmd>Telescope lsp_definitions<CR>",
                desc = "[LSP] Definition",
            },
            {
                c.lsp.show_diagnostics_float_buffer,
                "<cmd>Telescope diagnostics bufnr=0<CR>",
                desc = "[LSP] Diagnostics (buffer)",
            },
            {
                c.lsp.goto_references,
                "<cmd>Telescope lsp_references<CR>",
                desc = "[LSP] References",
            },
            {
                c.lsp.goto_implementations,
                "<cmd>Telescope lsp_implementations<CR>",
                desc = "[LSP] Implementations",
            },
            {
                c.lsp.goto_type_defenitions,
                "<cmd>Telescope lsp_type_definitions<CR>",
                desc = "[LSP] Type definitions",
            },
        },
        cmd = {
            "Telescope",
        },
        init = function()
            vim.cmd([[
            hi! link TelescopeBorder FloatBorder
            hi! link TelescopePromptBorder FloatBorder
            hi! link TelescopeResultsBorder FloatBorder
            hi! link TelescopePreviewBorder FloatBorder

            hi! link TelescopePromptCounter FloatNornal
        ]])
            require("utils.vim").create_autocmd({
                events = { "ColorScheme" },
                group_name = "aryon/telescope.lua",
                desc = "Link Telescope Hihglights",
                callback = function()
                    vim.cmd([[
                    hi! link TelescopeBorder FloatBorder
                    hi! link TelescopePromptBorder FloatBorder
                    hi! link TelescopeResultsBorder FloatBorder
                    hi! link TelescopePreviewBorder FloatBorder

                    hi! link TelescopePromptCounter FloatNornal
                ]])
                end,
            })
        end,
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local previewers = require("telescope.previewers")
            -- local trouble_ok, trouble = pcall(require, "trouble.providers.telescope")
            local icons = require("share.icons")

            local lga_actions = require("telescope-live-grep-args.actions")

            local maker_opts = previewer_factory_default_opts
            local maker = previewer_maker_factory(previewers, maker_opts)

            telescope.setup({
                defaults = {
                    initial_mode = "normal",
                    buffer_previewer_maker = maker,
                    -- border = false,
                    mappings = {
                        n = {
                            ["<C-e>"] = actions.preview_scrolling_down,
                            ["<C-n>"] = actions.move_selection_next,
                            ["<C-p>"] = actions.move_selection_previous,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<C-y>"] = actions.preview_scrolling_up,
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
                            ["<C-f>"] = false, -- default preview_scroll_left
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
                        "--smart-case",
                        "--hidden",      -- add hidden file grep
                        "--glob=!.git/", -- REF: https://github.com/BurntSushi/ripgrep/discussions/1578#discussioncomment-1723394
                        "--glob=!submodules/",
                        "--glob=!node_modules/",
                        "--glob=!vendor/",
                        -- "-u", -- unrestrict, show git ignores
                    },
                    wrap_results = true,
                },
                pickers = {
                    builtin = with_theme {
                        initial_mode = "insert",
                    },
                    buffers = with_theme {
                        initial_mode = "insert",
                        show_all_buffers = true,
                    },
                    find_files = with_theme {
                        initial_mode = "insert",
                        find_command = { -- find_files respects gitignore
                            "fd",
                            "--hidden",
                            "--exclude=.git/",
                            "--type=f",
                        },
                    },
                    commands = with_theme {
                        initial_mode = "insert",
                    },
                    git_status = with_theme {
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
                    live_grep = with_theme {
                        initial_mode = "insert",
                    },
                    grep_string = with_theme {
                        show_line = false, -- doesn't work
                        initial_mode = "insert",
                        wrap_results = false,
                    },
                    help_tags = with_theme {
                        initial_mode = "insert",
                    },
                    lsp_implementations = with_theme {
                        show_line = false,   -- show only filename and loc
                        jump_type = "never", -- never jump
                    },
                    lsp_definitions = with_theme {
                        show_line = false,
                        jump_type = "never",
                    },
                    lsp_references = with_theme {
                        show_line = false,
                        jump_type = "never",
                        include_current_line = false,
                    },
                    diagnostics = with_theme {
                        show_line = false,
                    },
                    resume = with_theme {
                        initial_mode = "normal",
                    },
                    current_buffer_fuzzy_find = with_theme {
                        initial_mode = "insert",
                    },
                    tags = with_theme {},
                    current_buffer_tags = with_theme {},
                },
                extensions = {
                    live_grep_args = with_theme {
                        show_line = false,
                        initial_mode = "insert",
                        auto_quoting = true, -- enable/disable auto-quoting
                        mappings = {         -- extend mappings
                            i = {
                                -- ["<C-k>"] = lga_actions.quote_prompt(),
                                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                            },
                        },
                    },
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                    },
                    lazy = with_theme {
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
                        require("telescope.themes").get_ivy {
                            initial_mode = "insert",
                        }
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

            local set_abbr_batch = require("utils.vim").batch_set_abbr
            local abbrs = {
                {
                    name = "tel",
                    cmd = "Telescope",
                    desc = "Telescope",
                },
            }
            set_abbr_batch(abbrs)
        end,
    },
}
