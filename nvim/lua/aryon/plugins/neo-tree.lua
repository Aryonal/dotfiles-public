local k = require("aryon.config").keymaps

return {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = true,
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- {
        --     "s1n7ax/nvim-window-picker",
        --     version = "2.*",
        -- },
        -- {
        --     "antosha417/nvim-lsp-file-operations",
        --     dependencies = { "nvim-lua/plenary.nvim" },
        --     config = function() end,
        -- },
    },
    keys = {
        {
            k.tree.focus,
            "<cmd>Neotree reveal focus<cr>",
            desc = "[NeoTree] Focus",
        },
    },
    cmd = {
        "Neotree",
    },
    config = function()
        local icons = require("share.icons")

        vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

        local function getTelescopeOpts(state, path)
            return {
                cwd = path,
                search_dirs = { path },
                ---@diagnostic disable-next-line: unused-local
                attach_mappings = function(prompt_bufnr, map)
                    local actions = require("telescope.actions")
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local action_state = require("telescope.actions.state")
                        local selection = action_state.get_selected_entry()
                        local filename = selection.filename
                        if filename == nil then
                            filename = selection[1]
                        end
                        -- any way to open the file without triggering auto-close event of neo-tree?
                        require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
                    end)
                    return true
                end,
            }
        end

        require("neo-tree").setup({
            popup_border_style = require("aryon.config").ui.float.border, -- use default nui style
            hide_root_node = false,
            event_handlers = {
                {
                    event = "neo_tree_window_after_open",
                    handler = function(args)
                        if args.position == "left" or args.position == "right" then
                            vim.cmd("wincmd =")
                        end
                    end,
                },
                {
                    event = "neo_tree_window_after_close",
                    handler = function(args)
                        if args.position == "left" or args.position == "right" then
                            vim.cmd("wincmd =")
                        end
                    end,
                },
            },
            default_component_configs = {
                container = {
                    enable_character_fade = true,
                    right_padding = 1,
                },
                icon = {
                    folder_closed = icons.arrow_right, --"",
                    folder_open = icons.arrow_open,    --"",
                    folder_empty = icons.arrow_void,
                    -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
                    -- then these will never be used.
                    default = icons.file_default, -- "*",
                    highlight = "NeoTreeFileIcon",
                },
                modified = {
                    symbol = icons.added, -- "[+]",
                    highlight = "NeoTreeModified",
                },
                name = {
                    trailing_slash = true,
                    use_git_status_colors = true,
                    highlight = "NeoTreeFileName",
                },
                git_status = {
                    symbols = {
                        -- Change type
                        added = "",                      -- or "✚", but this is redundant info if you use git_status_colors on the name
                        modified = "",                   -- or "", but this is redundant info if you use git_status_colors on the name
                        deleted = icons.git_deleted,     -- or "✖", -- this can only be used in the git_status source
                        renamed = icons.git_renamed,     -- or "", -- this can only be used in the git_status source
                        -- Status type
                        untracked = icons.git_untracked, -- "", -- icons.git_untracked,
                        ignored = icons.git_ignored,     -- or "",
                        unstaged = icons.git_unstaged,   -- or "",
                        staged = icons.git_staged,       -- or "",
                        conflict = icons.git_conflict,   -- or "",
                    },
                },
            },
            commands = {
                jump_previous = function(_)
                    vim.cmd([[
                        wincmd p
                    ]])
                end,
            },
            window = {
                position = "float",
                auto_expand_width = true, -- adaptive width
                width = 10,
                popup = {
                    -- position = { col = "0", row = "2" },
                    -- position = {
                    --     row = "2",
                    --     col = "0%",
                    -- },
                    size = function(state)
                        local root_name = vim.fn.fnamemodify(state.path, ":~")
                        local root_len = string.len(root_name) + 4
                        local w = vim.o.columns
                        local h = vim.o.lines
                        return {
                            width = math.min(math.ceil(w * 0.9), math.max(root_len, 80)),
                            height = h - 6,
                        }
                    end,
                },
                mapping_options = {
                    noremap = true,
                    nowait = true,
                },
                mappings = {
                    -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
                    -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                    -- show_path one of "none", "relative", "absolute"
                    [k.file.add] = { "add", config = { show_path = "relative" } },
                    [k.file.add_dir] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
                    [k.file.delete] = "delete",
                    [k.file.rename] = "rename",
                    [k.vim.float.close[2]] = "close_window",
                    [k.vim.terminal.toggle] = "close_window", -- "close_window",
                    [k.file.refresh_list[1]] = "refresh",
                    [k.file.refresh_list[2]] = "refresh",
                    [k.file.open_in_split] = "open_split",   -- "open_split" or "split_with_window_picker",
                    [k.file.open_in_vsplit] = "open_vsplit", -- "open_vsplit" or "vsplit_with_window_picker",
                    [k.file.open_in_tab] = "open_tabnew",
                    [k.tree.focus] = "jump_previous",
                    ["<tab>"] = { "toggle_node" },
                    ["<space>"] = { "toggle_node" },
                    ["<2-LeftMouse>"] = "open", -- "open" or "open_with_window_picker",
                    -- ["<cr>"] = "open_drop",
                    ["<cr>"] = "open",          -- "open" or "open_with_window_picker",
                    -- ["<esc>"] = "revert_preview",
                    ["<esc>"] = "close_window",
                    ["<BS>"] = "close_node",
                    --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
                    ["C"] = "", -- default "close_node"
                    -- ["P"] = { "toggle_preview", config = { use_float = true } },
                    ["P"] = "",
                    ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
                    -- ["c"] = {
                    --  "copy",
                    --  config = {
                    --    show_path = "none" -- "none", "relative", "absolute"
                    --  }
                    --}
                    ["e"] = "rename",
                    ["l"] = "focus_preview",
                    ["p"] = "paste_from_clipboard",
                    ["S"] = "",     -- default "split_with_window_picker",
                    ["s"] = "",     -- default "vsplit_with_window_picker",
                    ["t"] = "",     -- default "open_tabnew"
                    ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
                    ["w"] = "",     -- "open_with_window_picker",
                    ["x"] = "cut_to_clipboard",
                    ["y"] = "copy_to_clipboard",
                    -- ["z"] = "close_all_nodes",
                    --["Z"] = "expand_all_nodes",
                    ["z"] = "",
                    ["?"] = "show_help",
                    ["<"] = "prev_source",
                    [">"] = "next_source",
                    -- toggle source
                    -- ["f"] = function()
                    --     vim.api.nvim_exec("Neotree focus filesystem reveal", true)
                    -- end,
                    -- ["b"] = function()
                    --     vim.api.nvim_exec("Neotree focus buffers reveal", true)
                    -- end,
                    -- ["g"] = function()
                    --     vim.api.nvim_exec("Neotree focus git_status reveal", true)
                    -- end,
                },
            },
            nesting_rules = {},
            filesystem = {
                filtered_items = {
                    visible = true, -- when true, they will just be displayed differently than normal items
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_hidden = false, -- only works on Windows for hidden files/directories
                    hide_by_name = {
                        --"node_modules"
                    },
                    hide_by_pattern = { -- uses glob style patterns
                        --"*.meta",
                        --"*/src/*/tsconfig.json",
                    },
                    always_show = { -- remains visible even if other settings would normally hide it
                        --".gitignored",
                    },
                    never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                        --".DS_Store",
                        --"thumbs.db"
                    },
                    never_show_by_pattern = { -- uses glob style patterns
                        --".null-ls_*",
                    },
                },
                follow_current_file = { -- This will find and focus the file in the active buffer every
                    enabled = true,
                },
                use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
                hijack_netrw_behavior = "disabled",
                window = {
                    -- position = "float",
                    mappings = {
                        [k.tree.cd_parent] = "navigate_up",
                        [k.tree.cd] = "set_root",
                        ["H"] = "toggle_hidden",
                        ["D"] = "",
                        ["f"] = "",
                        ["/"] = false,
                        [k.tree.git_previous] = "prev_git_modified",
                        [k.tree.git_next] = "next_git_modified",
                        [k.tree.search_node] = "telescope_find",
                        [k.tree.grep_node] = "telescope_grep",
                        ["<C-o>"] = "jump_previous",
                    },
                },
                commands = {
                    telescope_find = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        require("telescope.builtin").find_files(getTelescopeOpts(state, path))
                    end,
                    telescope_grep = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        require("telescope").extensions.live_grep_args.live_grep_args(getTelescopeOpts(state, path))
                        -- TODO: fallback to builtin
                        -- require("telescope.builtin").live_grep(getTelescopeOpts(state, path))
                    end,
                },
            },
            buffers = {
                follow_current_file = { -- This will find and focus the file in the active buffer every
                    enabled = true,
                },
                -- time the current file is changed while the tree is open.
                group_empty_dirs = true, -- when true, empty folders will be grouped together
                show_unloaded = true,
                window = {
                    mappings = {
                        ["bd"] = "buffer_delete",
                        -- ["<bs>"] = "navigate_up",
                        [k.tree.cd] = "set_root",
                        -- ["<esc>"] = "close_window",
                    },
                },
            },
            git_status = {
                follow_current_file = {
                    enabled = true,
                }, -- This will find and focus the file in the active buffer every
                window = {
                    -- position = "float",
                    mappings = {
                        ["A"] = "git_add_all",
                        ["gu"] = "", -- git_unstage_file",
                        ["ga"] = "", --"git_add_file",
                        ["gr"] = "", --"git_revert_file",
                        ["gc"] = "", --"git_commit",
                        ["gp"] = "", --"git_push",
                        ["gg"] = "", --"git_commit_and_push",
                        -- ["<esc>"] = "close_window",
                    },
                },
            },
            source_selector = {
                winbar = false,
                statusline = false,
            },
            renderers = {
                directory = {
                    {
                        "container",
                        content = {
                            { "indent", zindex = 10 },
                        },
                    },
                    { "icon" },
                    { "current_filter" },
                    {
                        "container",
                        content = {
                            { "name",       zindex = 10 },
                            { "git_status", zindex = 10, align = "left", hide_when_expanded = true },
                            { "clipboard",  zindex = 10 },
                            {
                                "diagnostics",
                                zindex = 20,
                                align = "right",
                                -- errors_only = true,
                                hide_when_expanded = true,
                            },
                        },
                    },
                },
                file = {
                    {
                        "container",
                        content = {
                            { "indent", zindex = 10, align = "left" },
                        },
                    },
                    { "icon" },
                    {
                        "container",
                        content = {
                            { "name",        zindex = 10 },
                            { "git_status",  zindex = 10, align = "left" },
                            { "clipboard",   zindex = 10 },
                            { "bufnr",       zindex = 10 },
                            { "modified",    zindex = 20, align = "right" },
                            { "diagnostics", zindex = 20, align = "right" },
                        },
                    },
                },
            },
        })

        local custom_aug = vim.api.nvim_create_augroup("aryon/plugin/neo-tree.lua", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            pattern = { "neo-tree git_status*", "neo-tree buffers*", "neo-tree filesystem*" },
            group = custom_aug,
            desc = "Neo-tree centralizes cursor",
            callback = function()
                vim.cmd([[
                    setlocal scrolloff=99
                ]])
            end,
        })

        -- require("lsp-file-operations").setup()
    end,
}
