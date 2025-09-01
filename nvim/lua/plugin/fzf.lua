local c = require("config").keymaps

-- Issue:
-- - input lag --> actually it's because FzfLua global
-- - Cannot preview dir
vim.g.has_fzf_lua = true

local rg_opts = [[--column --line-number --no-heading ]] ..
    [[--color=always --smart-case ]] ..
    [[--with-filename ]] ..
    [[--max-columns=4096 ]] ..
    [[--hidden ]] ..
    [[--glob=!.git/ ]] ..
    [[--glob=!submodules/ ]] ..
    [[--glob=!node_modules/ ]] ..
    [[--glob=!vendor/]]
-- respect gitignore
local fd_opts = [[--color=never ]] ..
    -- [[--type=f ]]..
    [[--hidden --follow ]] ..
    [[--exclude=.git ]] ..
    [[--exclude=node_modules ]] ..
    [[--exclude=vendor ]] ..
    [[--exclude=submodules ]] ..
    [[--exclude=.cache ]] ..
    [[--exclude=__pycache__ ]] ..
    [[--exclude=.idea ]] ..
    [[--exclude=.vscode ]] ..
    [[--exclude=.DS_Store ]]

return {
    {
        "ibhagwan/fzf-lua",
        enabled = vim.g.has_fzf_lua,
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- optional, for icons
        },
        keys = {
            -- use Shift + key for alternative query
            { ";:",                                "<cmd>FzfLua commands<CR>",              desc = "[FzfLua] Commands" },
            { "<C-g>:",                            "<cmd>FzfLua commands<CR>",              desc = "[FzfLua] Commands" },
            { ";;",                                "<cmd>FzfLua resume<CR>",                desc = "[FzfLua] Resume" },
            { "<C-g>;",                            "<cmd>FzfLua resume<CR>",                desc = "[FzfLua] Resume" },
            { ";?",                                "<cmd>FzfLua help_tags<CR>",             desc = "[FzfLua] Help tags" },
            { "<C-g>?",                            "<cmd>FzfLua help_tags<CR>",             desc = "[FzfLua] Help tags" },
            { ";d",                                "<cmd>FzfLua diagnostics_workspace<CR>", desc = "[FzfLua] Diagnostics" },
            { "<C-g><C-d>",                        "<cmd>FzfLua diagnostics_workspace<CR>", desc = "[FzfLua] Diagnostics" },
            { ";D",                                "<cmd>FzfLua diagnostics_document<CR>",  desc = "[FzfLua] Diagnostics (buffer)" },
            { "<C-g>D",                            "<cmd>FzfLua diagnostics_document<CR>",  desc = "[FzfLua] Diagnostics (buffer)" },
            { ";g",                                "<cmd>FzfLua git_status<CR>",            desc = "[FzfLua] Git status" },
            { "<C-g><C-g>",                        "<cmd>FzfLua git_status<CR>",            desc = "[FzfLua] Git status" },
            { ";G",                                "<cmd>FzfLua git_hunks<CR>",             desc = "[FzfLua] Git hunks" },
            { "<C-g>G",                            "<cmd>FzfLua git_hunks<CR>",             desc = "[FzfLua] Git hunks" },
            { ";r",                                "<cmd>FzfLua live_grep<CR>",             desc = "[FzfLua] Live grep" },
            { "<C-g><C-r>",                        "<cmd>FzfLua live_grep<CR>",             desc = "[FzfLua] Live grep" },
            { ";R",                                "<cmd>FzfLua lgrep_curbuf<CR>",          desc = "[FzfLua] Current buffer live grep" },
            { "<C-g>R",                            "<cmd>FzfLua lgrep_curbuf<CR>",          desc = "[FzfLua] Current buffer live grep" },
            { ";/",                                "<cmd>FzfLua lgrep_curbuf<CR>",          desc = "[FzfLua] Current buffer live grep" },
            { "<C-g>/",                            "<cmd>FzfLua lgrep_curbuf<CR>",          desc = "[FzfLua] Current buffer live grep" },
            { ";t",                                "<cmd>FzfLua tags<CR>",                  desc = "[FzfLua] Tags" },
            { "<C-g><C-t>",                        "<cmd>FzfLua tags<CR>",                  desc = "[FzfLua] Tags" },
            { ";T",                                "<cmd>FzfLua btags<CR>",                 desc = "[FzfLua] Current buffer tags" },
            { "<C-g>T",                            "<cmd>FzfLua btags<CR>",                 desc = "[FzfLua] Current buffer tags" },
            { ";b",                                "<cmd>FzfLua buffers<CR>",               desc = "[FzfLua] Buffers" },
            { "<C-g><C-b>",                        "<cmd>FzfLua buffers<CR>",               desc = "[FzfLua] Buffers" },
            { ";f",                                "<cmd>FzfLua files<CR>",                 desc = "[FzfLua] Find files" },
            { "<C-g><C-f>",                        "<cmd>FzfLua files<CR>",                 desc = "[FzfLua] Find files" },
            { ";m",                                "<cmd>FzfLua marks<CR>",                 desc = "[FzfLua] Marks" },
            { "<C-g><C-m>",                        "<cmd>FzfLua marks<CR>",                 desc = "[FzfLua] Marks" },
            { ";q",                                "<cmd>FzfLua quickfix<CR>",              desc = "[FzfLua] Quickfix" },
            { "<C-g><C-q>",                        "<cmd>FzfLua quickfix<CR>",              desc = "[FzfLua] Quickfix" },
            { ";s",                                "<cmd>FzfLua grep_cword<CR>",            desc = "[FzfLua] Grep string" },
            { "<C-g><C-s>",                        "<cmd>FzfLua grep_cword<CR>",            desc = "[FzfLua] Grep string" },
            { ";s",                                "<cmd>FzfLua grep_cword<CR>",            desc = "[FzfLua] Grep string",             mode = "v" },
            { "<C-g><C-s>",                        "<cmd>FzfLua grep_cword<CR>",            desc = "[FzfLua] Grep string",             mode = "v" },
            -- LSP
            { c.lsp.goto_definition,               "<cmd>FzfLua lsp_definitions<CR>",       desc = "[LSP] Definition" },
            { c.lsp.show_document_symbols_default, "<cmd>FzfLua lsp_document_symbols<CR>",  desc = "[LSP] Document symbols" },
            { c.lsp.show_diagnostics_in_buffer,    "<cmd>FzfLua diagnostics_document<CR>",  desc = "[LSP] Diagnostics (buffer)" },
            { c.lsp.goto_references_default,       "<cmd>FzfLua lsp_references<CR>",        desc = "[LSP] References", },
            { c.lsp.goto_implementations_default,  "<cmd>FzfLua lsp_implementations<CR>",   desc = "[LSP] Implementations" },
            { c.lsp.goto_type_defenitions_default, "<cmd>FzfLua lsp_typedefs<CR>",          desc = "[LSP] Type definitions" },
        },
        cmd = { "FzfLua" },
        config = function()
            local fzf = require("fzf-lua")
            local actions = require("fzf-lua.actions")

            -- REF: https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/profiles/ivy.lua
            local ivy_winopts = {
                row = 1,
                col = 0,
                width = 1,
                height = 0.5,
                title_pos = "left",
                border = { "", "─", "", "", "", "", "", "" },
                preview = {
                    default = "builtin", -- use fzf preview sh
                    layout = "horizontal",
                    title_pos = "right",
                    treesitter = false,
                    delay = 100,
                    border = function(_, m)
                        if m.type == "fzf" then
                            return "single"
                        else
                            assert(m.type == "nvim" and m.name == "prev" and type(m.layout) == "string")
                            local b = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
                            if m.layout == "down" then
                                b[1] = "├" --top right
                                b[3] = "┤" -- top left
                            elseif m.layout == "up" then
                                b[7] = "├" -- bottom left
                                b[6] = "" -- remove bottom
                                b[5] = "┤" -- bottom right
                            elseif m.layout == "left" then
                                b[3] = "┬" -- top right
                                b[5] = "┴" -- bottom right
                                b[6] = "" -- remove bottom
                            else -- right
                                b[1] = "┬" -- top left
                                b[7] = "┴" -- bottom left
                                b[6] = "" -- remove bottom
                            end
                            return b
                        end
                    end,
                }
            }


            local builtin = require("fzf-lua.previewer.builtin")
            -- Inherit from the "buffer_or_file" previewer
            local MyPreviewer = builtin.buffer_or_file:extend()

            function MyPreviewer:new(o, opts, fzf_win)
                MyPreviewer.super.new(self, o, opts, fzf_win)
                setmetatable(self, MyPreviewer)
                return self
            end

            function MyPreviewer:parse_entry(entry_str)
                return entry_str
            end

            fzf.setup({
                { "default-title" },
                winopts = ivy_winopts,
                keymap = {
                    builtin = {
                        ["<C-n>"] = "down",
                        ["<C-p>"] = "up",
                        ["<C-f>"] = "preview-half-page-down",
                        ["<C-b>"] = "preview-half-page-up",
                        ["<C-q>"] = "select-all+accept",
                        [c.file.open_in_split] = "ctrl-x",
                        [c.file.open_in_tab] = "ctrl-t",
                        [c.file.open_in_vsplit] = "ctrl-v",
                        [c.vim.float.close[1]] = "abort",
                        [c.vim.float.close[2]] = "abort",
                        [c.vim.float.close[3]] = "abort",
                    },
                    fzf = {
                        ["ctrl-q"] = "select-all+accept",
                        ["ctrl-f"] = "preview-half-page-down",
                        ["ctrl-b"] = "preview-half-page-up",
                        ["ctrl-/"] = "toggle-preview",
                    },
                },
                actions = {
                    -- Below are the default actions, setting any value in these tables will override
                    -- the defaults, to inherit from the defaults change [1] from `false` to `true`
                    files = {
                        true, -- uncomment to inherit all the below in your custom config
                        -- Pickers inheriting these actions:
                        --   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
                        --   tags, btags, args, buffers, tabs, lines, blines
                        -- `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
                        -- replace `enter` with `file_edit` to open all files/bufs whether single or multiple
                        -- replace `enter` with `file_switch_or_edit` to attempt a switch in current tab first
                        ["enter"] = actions.file_edit_or_qf,
                    },
                },
                hls = {
                    border = "FloatBorder",
                    preview_border = "FloatBorder",
                },
                -- Custom pickers
                defaults = {
                    -- formatter = "path.filename_first",
                    -- formatter = "path.dirname_first",

                    -- for perf
                    file_icons = false,
                    -- color_icons = false,

                    rg_opts = rg_opts,
                    fd_opts = fd_opts,
                },
                files = {
                    -- custom previewer to preview directories
                    previewer = "",
                    fzf_opts = {
                        ["--preview"] =
                        "bat --theme=ansi --style=numbers,changes --color=always {} 2>/dev/null || LC_COLLATE=C ls -alhF {}",
                    },
                },
                grep = {},
                git = {
                    status = {
                        -- cmd = "git status -su", -- "git status --porcelain=v1 -u",
                        winopts = {
                            preview = {
                                hidden = "nohidden",
                            },
                        },
                    },
                },
                lsp = {
                    jump1 = false,              -- do not jump for single result
                    includeDeclaration = false, -- include current declaration in LSP context
                    code_actions = { previewer = "codeaction_native" },
                },
                -- perf
                manpages = { previewer = "man_native" },
                helptags = { previewer = "help_native" },
                tags = { previewer = "bat" },
                btags = { previewer = "bat" },
            })

            -- Setup ui-select replacement with custom theme
            fzf.register_ui_select()

            local set_abbr_batch = require("x.helper.vim").batch_set_abbr
            local abbrs = {
                {
                    name = "ff",
                    cmd = "FzfLua",
                    desc = "FzfLua",
                },
            }
            set_abbr_batch(abbrs)

            -- disable blinking cursor in terminal mode
            vim.opt.guicursor:remove { "t:block-blinkon500-blinkoff500-TermCursor" }
        end,
    },
    {
        "elanmed/fzf-lua-frecency.nvim",
        enabled = vim.g.has_fzf_lua,
        dependencies = {
            "ibhagwan/fzf-lua",
        },
        keys = {
            { ";F",     "<cmd>FzfLua frecency cwd_only=true<CR>", desc = "[FzfLua] Frecency" },
            { "<C-g>F", "<cmd>FzfLua frecency cwd_only=true<CR>", desc = "[FzfLua] Frecency" },
        },
        config = function()
            require("fzf-lua-frecency").setup()
        end,
    },
}
