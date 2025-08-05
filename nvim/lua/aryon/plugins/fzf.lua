local c = require("aryon.config").keymaps

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
local fd_opts = [[--color=never --type=f --hidden --follow ]] ..
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
            {
                ";t",
                "<cmd>FzfLua tags<CR>",
                desc = "[FzfLua] Tags",
            },
            {
                ";T",
                "<cmd>FzfLua btags<CR>",
                desc = "[FzfLua] Current buffer tags",
            },
            {
                ";g",
                "<cmd>FzfLua git_status<CR>",
                desc = "[FzfLua] Git status",
            },
            {
                ";G",
                "<cmd>FzfLua git_hunks<CR>",
                desc = "[FzfLua] Git hunks",
            },
            {
                ";b",
                "<cmd>FzfLua buffers<CR>",
                desc = "[FzfLua] Buffers",
            },
            {
                ";F",
                "<cmd>FzfLua global<CR>",
                desc = "[FzfLua] Find global",
            },
            {
                ";s",
                "<cmd>FzfLua grep_cword<CR>",
                mode = "v",
                desc = "[FzfLua] Grep string",
            },
            {
                ";s",
                "<cmd>FzfLua grep_cword<CR>",
                desc = "[FzfLua] Grep string",
            },
            {
                ";r",
                "<cmd>FzfLua live_grep<CR>",
                desc = "[FzfLua] Live grep",
            },
            {
                ";R",
                "<cmd>FzfLua lgrep_curbuf<CR>",
                desc = "[FzfLua] Current buffer live grep",
            },
            {
                ";q",
                "<cmd>FzfLua quickfix<CR>",
                desc = "[FzfLua] Quickfix",
            },
            {
                ";d",
                "<cmd>FzfLua diagnostics_workspace<CR>",
                desc = "[FzfLua] Diagnostics",
            },
            {
                ";D",
                "<cmd>FzfLua diagnostics_document<CR>",
                desc = "[FzfLua] Diagnostics (buffer)",
            },
            {
                ";m",
                "<cmd>FzfLua marks<CR>",
                desc = "[FzfLua] Marks",
            },
            {
                ";?",
                "<cmd>FzfLua help_tags<CR>",
                desc = "[FzfLua] Help tags",
            },
            {
                ";;",
                "<cmd>FzfLua resume<CR>",
                desc = "[FzfLua] Resume",
            },
            {
                ";:",
                "<cmd>FzfLua commands<CR>",
                desc = "[FzfLua] Commands",
            },
            -- LSP
            {
                c.lsp.goto_definition,
                "<cmd>FzfLua lsp_definitions<CR>",
                desc = "[LSP] Definition",
            },
            {
                c.lsp.show_diagnostics_float_buffer,
                "<cmd>FzfLua diagnostics_document<CR>",
                desc = "[LSP] Diagnostics (buffer)",
            },
            {
                c.lsp.goto_references,
                "<cmd>FzfLua lsp_references<CR>",
                desc = "[LSP] References",
                nowait = true,
            },
            {
                c.lsp.goto_references_default,
                "<cmd>FzfLua lsp_references<CR>",
                desc = "[LSP] References",
                nowait = true,
            },
            {
                c.lsp.goto_implementations_default,
                "<cmd>FzfLua lsp_implementations<CR>",
                desc = "[LSP] Implementations",
            },
            {
                c.lsp.goto_type_defenitions_default,
                "<cmd>FzfLua lsp_typedefs<CR>",
                desc = "[LSP] Type definitions",
            },
        },
        cmd = {
            "FzfLua",
        },
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
                    default = "builtin",
                    layout = "horizontal",
                    title_pos = "right",
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

            fzf.setup({
                { "default-title" },
                winopts = ivy_winopts,
                keymap = {
                    builtin = {
                        ["<C-n>"] = "down",
                        ["<C-p>"] = "up",
                        ["<C-e>"] = "preview-half-page-down",
                        ["<C-y>"] = "preview-half-page-up",
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
                        ["ctrl-e"] = "preview-half-page-down",
                        ["ctrl-y"] = "preview-half-page-up",
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
                    rg_opts = rg_opts,
                    fd_opts = fd_opts,
                },
                grep = {},
                files = {},
                git = {
                    status = {
                        cmd = "git status --porcelain=v1 -u",
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
                },
            })

            -- Setup ui-select replacement with custom theme
            fzf.register_ui_select()

            local set_abbr_batch = require("utils.vim").batch_set_abbr
            local abbrs = {
                {
                    name = "ff",
                    cmd = "FzfLua",
                    desc = "FzfLua",
                },
            }
            set_abbr_batch(abbrs)
        end,
    },
    {
        "elanmed/fzf-lua-frecency.nvim",
        dependencies = {
            "ibhagwan/fzf-lua",
        },
        keys = { {
            ";f",
            "<cmd>FzfLua frecency cwd_only=true<CR>",
            desc = "[FzfLua] Frecency",
        } },
        config = function()
            require("fzf-lua-frecency").setup()
        end,
    },
}
