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
        vim.loop.fs_stat(filepath, function(_, stat)
            if not stat then
                return
            end
            if stat.size > factory_opts.large_file_threshold then
                return
            else
                previewers.buffer_previewer_maker(filepath, bufnr, opts)
            end
        end)
    end
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        -- { "nvim-telescope/telescope-file-browser.nvim" },
        { "tsakirist/telescope-lazy.nvim" },
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            version = "^1.0.0",
        },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
        {
            ";t",
            ":Telescope<CR>",
            desc = "[Telescope] Telescope",
        },
        {
            ";g",
            ":Telescope git_status<CR>",
            -- ":Neotree reveal focus git_status<CR>",
            desc = "[Telescope] Git status",
        },
        {
            ";b",
            ":Telescope buffers<CR>",
            -- ":Neotree reveal focus buffers<CR>",
            desc = "[Telescope] Buffers",
        },
        {
            ";f",
            ":Telescope find_files<CR>",
            desc = "[Telescope] Find files",
        },
        {
            ";d",
            ":Telescope file_browser<CR>",
            desc = "[Telescope] File browser",
        },
        {
            ";s",
            "<cmd>Telescope grep_string<CR>",
            mode = "v",
            desc = "[Telescope] Grep string",
        },
        {
            ";s",
            ":Telescope grep_string<CR>",
            desc = "[Telescope] Grep string",
        },
        {
            ";r",
            -- ":Telescope live_grep<CR>", -- use telescope-rg instead
            ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
            desc = "[Telescope] Live grep",
        },
        {
            ";?",
            ":Telescope help_tags<CR>",
            desc = "[Telescope] Help tags",
        },
        {
            ";;",
            ":Telescope resume<CR>",
            desc = "[Telescope] Resume",
        },
        {
            ";:",
            ":Telescope commands<CR>",
            desc = "[Telescope] Commands",
        },
        -- LSP
        {
            c.lsp.goto_definition,
            ":Telescope lsp_definitions<CR>",
            desc = "[LSP] Definition",
        },
        {
            c.lsp.show_diagnostics_float_buffer,
            ":Telescope diagnostics bufnr=0<CR>",
            desc = "[LSP] Diagnostics (buffer)",
        },
        {
            c.lsp.goto_references,
            ":Telescope lsp_references<CR>",
            desc = "[LSP] References",
        },
        {
            c.lsp.goto_implementations,
            ":Telescope lsp_implementations<CR>",
            desc = "[LSP] Implementations",
        },
        {
            c.lsp.goto_type_defenitions,
            ":Telescope lsp_type_definitions<CR>",
            desc = "[LSP] Type definitions",
        },
    },
    cmd = {
        "Telescope",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local previewers = require("telescope.previewers")
        local trouble_ok, trouble = pcall(require, "trouble.providers.telescope")
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
                        ["q"] = actions.close,
                        ["<C-\\>"] = actions.close,
                        -- ["<C-q>"] = trouble.open_with_trouble,
                        ["<C-q>"] = trouble_ok and trouble.open_with_trouble or
                        actions.send_to_qflist + actions.open_qflist,
                        ["<CR>"] = actions.select_default + actions.center,
                        ["<C-e>"] = actions.preview_scrolling_down,
                        ["<C-y>"] = actions.preview_scrolling_up,
                    },
                    i = {
                        -- REF: https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#mapping-c-u-to-clear-prompt
                        ["<C-u>"] = false,
                        -- ["<C-w>"] = false, -- default delete a word
                        -- ["<C-n>"] = false, -- default previous entry
                        -- ["<C-p>"] = false, -- default next entry
                        ["<C-\\>"] = actions.close,
                        -- ["<C-q>"] = trouble.open_with_trouble,
                        ["<C-q>"] = trouble_ok and trouble.open_with_trouble or
                        actions.send_to_qflist + actions.open_qflist,
                        ["<CR>"] = actions.select_default + actions.center,
                        -- ["<C-e>"] = actions.preview_scrolling_down,
                        -- ["<C-y>"] = actions.preview_scrolling_up,
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
                builtin = {
                    initial_mode = "insert",
                },
                find_files = {
                    initial_mode = "insert",
                    find_command = { -- find_files respects gitignore
                        "rg",
                        "--files",
                        "--smart-case",
                        "--hidden",      -- add hidden file grep
                        "--glob=!.git/", -- REF: https://github.com/BurntSushi/ripgrep/discussions/1578#discussioncomment-1723394
                        "--glob=!submodules/",
                        "--glob=!node_modules/",
                        "--glob=!vendor/",
                    },
                },
                commands = {
                    initial_mode = "insert",
                },
                git_status = {
                    git_icons = {
                        added = icons.git_add,           -- "+",
                        changed = icons.git_unstaged,    -- "~",
                        copied = ">",
                        deleted = icons.git_deleted,     -- "-",
                        renamed = icons.git_renamed,     -- "➡",
                        unmerged = icons.git_unmerged,   -- "‡",
                        untracked = icons.git_untracked, -- "?",
                    },
                },
                live_grep = {
                    initial_mode = "insert",
                },
                grep_string = {
                    initial_mode = "normal",
                },
                help_tags = {
                    initial_mode = "insert",
                },
                lsp_implementations = {
                    -- theme = "dropdown",
                    show_line = false,   -- show only filename and loc
                    jump_type = "never", -- never jump
                },
                lsp_definitions = {
                    -- theme = "dropdown",
                    show_line = false,
                    jump_type = "never",
                },
                lsp_references = {
                    -- theme = "dropdown",
                    show_line = false,
                    jump_type = "never",
                    include_current_line = false,
                },
                diagnostics = {
                    -- theme = "dropdown",
                    show_line = false,
                },
                resume = {
                    initial_mode = "normal",
                },
            },
            extensions = {
                live_grep_args = {
                    initial_mode = "insert",
                    auto_quoting = true, -- enable/disable auto-quoting
                    mappings = {         -- extend mappings
                        i = {
                            -- ["<C-k>"] = lga_actions.quote_prompt(),
                            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                        },
                    },
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
            },
        })

        -- telescope.load_extension("file_browser")
        telescope.load_extension("lazy")
        telescope.load_extension("fzf")
        telescope.load_extension("live_grep_args")

        local set_abbr_batch = require("utils.command").batch_set_abbr
        local abbrs = {
            {
                name = "tel",
                cmd = "Telescope",
                desc = "Telescope",
            },
        }
        set_abbr_batch(abbrs)
    end,
}
