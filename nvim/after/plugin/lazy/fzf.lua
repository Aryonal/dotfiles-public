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

local _setup_once = require("helper.lua").once(function()
    if MiniDeps then
        MiniDeps.add({ source = "ibhagwan/fzf-lua", depends = { "nvim-tree/nvim-web-devicons" } })
        MiniDeps.add({ source = "elanmed/fzf-lua-frecency.nvim" })
    end

    local ok, fzf = pcall(require, "fzf-lua")
    if not ok then
        return
    end
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
                -- TODO: use global keys
                ["<C-s>"] = "ctrl-x",
                ["<C-t>"] = "ctrl-t",
                ["<C-v>"] = "ctrl-v",
                ["<C-c>"] = "abort",
                ["<C-_>"] = "toggle-preview", -- <C-/> and <C-->
                ["<C-/>"] = "toggle-preview",
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
            previewer = "", -- TODO: "" is invalid previewer, search for proper setup
            fzf_opts = {
                ["--preview"] =
                "bat --theme=Github --style=numbers,changes --color=always {} 2>/dev/null || LC_COLLATE=C ls -AlhF --color=always {}",
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

    require("helper.vim").set_abbr("ff", "FzfLua")

    -- disable blinking cursor in terminal mode
    vim.opt.guicursor:remove { "t:block-blinkon500-blinkoff500-TermCursor" }

    local ok, frecency = pcall(require, "fzf-lua-frecency")
    if ok then
        frecency.setup()
    end
end)

local prefix = ";" -- "<C-g>"

local keys = {
    -- use Shift + key for alternative query
    -- {lhs, cmd, desc, mode}
    { prefix .. "a", "FzfLua args",                                desc = "[FzfLua] Args" },
    { prefix .. "b", "FzfLua buffers",                             desc = "[FzfLua] Buffers" },
    { prefix .. "d", "FzfLua diagnostics_workspace",               desc = "[FzfLua] Diagnostics" },
    { prefix .. "D", "FzfLua diagnostics_workspace cwd_only=true", desc = "[FzfLua] Diagnostics (cwd)" },
    { prefix .. "f", "FzfLua files",                               desc = "[FzfLua] Find files" },
    { prefix .. "F", "FzfLua frecency cwd_only=true",              desc = "[FzfLua] Frecency" },
    { prefix .. "g", "FzfLua git_status",                          desc = "[FzfLua] Git status" },
    { prefix .. "G", "FzfLua git_hunks",                           desc = "[FzfLua] Git hunks" },
    { prefix .. "m", "FzfLua marks",                               desc = "[FzfLua] Marks" },
    { prefix .. "q", "FzfLua quickfix",                            desc = "[FzfLua] Quickfix" },
    { prefix .. "r", "FzfLua live_grep",                           desc = "[FzfLua] Live grep" },
    { prefix .. "R", "FzfLua lgrep_curbuf",                        desc = "[FzfLua] Current buffer live grep" },
    { prefix .. "s", "FzfLua grep_cword",                          desc = "[FzfLua] Grep string" },
    { prefix .. "s", "FzfLua grep_cword",                          desc = "[FzfLua] Grep string",             mode = "v" },
    { prefix .. "t", "FzfLua tags",                                desc = "[FzfLua] Tags" },
    { prefix .. "T", "FzfLua btags",                               desc = "[FzfLua] Current buffer tags" },
    { prefix .. "?", "FzfLua help_tags",                           desc = "[FzfLua] Help tags" },
    { prefix .. ";", "FzfLua resume",                              desc = "[FzfLua] Resume" },
    -- LSP
    { "gd",          "FzfLua lsp_definitions",                     desc = "[LSP] Definition" },
    { "gO",          "FzfLua lsp_document_symbols",                desc = "[LSP] Document symbols" },
    { "<leader>q",   "FzfLua diagnostics_document",                desc = "[LSP] Diagnostics (buffer)" },
    { "grr",         "FzfLua lsp_references",                      desc = "[LSP] References", },
    { "gri",         "FzfLua lsp_implementations",                 desc = "[LSP] Implementations" },
    { "grt",         "FzfLua lsp_typedefs",                        desc = "[LSP] Type definitions" },
    -- Custom
}

for _, key in ipairs(keys) do
    local _rhs = require("helper.lua").prehook(_setup_once, function()
        vim.cmd(key[2])
    end)
    vim.keymap.set(key.mode or "n", key[1], _rhs, { desc = key["desc"] })
end
