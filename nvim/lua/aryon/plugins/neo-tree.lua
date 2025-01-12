local k = require("aryon.config").keymaps

return {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = true,
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    keys = {
        { k.tree.focus,  "<cmd>Neotree reveal focus<cr>",  desc = "[NeoTree] Focus" },
        { k.tree.toggle, "<cmd>Neotree reveal toggle<cr>", desc = "[NeoTree] Toggle" },
    },
    cmd = {
        "Neotree",
    },
    init = function()
        vim.api.nvim_create_autocmd("BufEnter", {
            -- make a group to be able to delete it later
            group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
            callback = function(args)
                local is_directory = vim.fn.isdirectory(args.file) == 1
                if is_directory then
                    vim.cmd.cd(args.file)
                    vim.cmd("Neotree current")
                    -- neo-tree is loaded now, delete the init autocmd
                    vim.api.nvim_clear_autocmds { group = "NeoTreeInit" }
                end
            end
        })
    end,
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
                        ---@diagnostic disable-next-line: missing-parameter
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
                -- {
                --     event = "neo_tree_window_after_open",
                --     handler = function(args)
                --         vim.cmd("wincmd =")
                --     end,
                -- },
                -- {
                --     event = "neo_tree_window_after_close",
                --     handler = function(args)
                --         vim.cmd("wincmd =")
                --     end,
                -- },
            },
            default_component_configs = {
                container = {
                    enable_character_fade = true,
                    right_padding = 1,
                },
                icon = {
                    folder_closed = icons.arrow_right,
                    folder_open = icons.arrow_open,
                    folder_empty = icons.arrow_void,
                    -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
                    -- then these will never be used.
                    default = "", -- icons.file_default,
                    highlight = "NeoTreeFileIcon",
                },
                modified = {
                    symbol = icons.added,
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
                        added = "",
                        modified = "",
                        deleted = icons.git_deleted,
                        renamed = icons.git_renamed,
                        untracked = icons.git_untracked,
                        ignored = icons.git_ignored,
                        unstaged = icons.git_unstaged,
                        staged = icons.git_staged,
                        conflict = icons.git_conflict,
                    },
                },
            },
            -- commands = {
            --     jump_previous = function(_)
            --         vim.cmd([[
            --             wincmd p
            --         ]])
            --     end,
            -- },
            window = {
                position = "current",     -- float, current, left...
                auto_expand_width = true, -- adaptive width
                width = 40,
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
                    ["<"] = "prev_source",
                    ["<2-LeftMouse>"] = "open", -- "open" or "open_with_window_picker",
                    ["<BS>"] = "close_node",
                    ["<cr>"] = "open",          -- "open" or "open_with_window_picker",
                    [">"] = "next_source",
                    ["c"] = "copy",             -- takes text input for destination, also accepts the optional config.show_path option like "add":
                    ["e"] = "rename",
                    ["l"] = "focus_preview",
                    ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
                    ["p"] = "paste_from_clipboard",
                    ["x"] = "cut_to_clipboard",
                    ["y"] = "copy_to_clipboard",
                    [k.ed.fold] = { "toggle_node" },
                    [k.file.add] = { "add", config = { show_path = "relative" } },
                    [k.file.add_dir] = "add_directory",      -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
                    [k.file.delete] = "delete",
                    [k.file.open_in_split] = "open_split",   -- "open_split" or "split_with_window_picker",
                    [k.file.open_in_tab] = "open_tabnew",
                    [k.file.open_in_vsplit] = "open_vsplit", -- "open_vsplit" or "vsplit_with_window_picker",
                    [k.file.refresh_list[1]] = "refresh",
                    [k.file.refresh_list[2]] = "refresh",
                    [k.file.rename] = "rename",
                    [k.vim.float.close[1]] = "close_window",
                    [k.vim.float.close[2]] = "close_window",
                    [k.vim.float.close[3]] = "close_window",
                    -- disables
                    ["<esc>"] = false,
                    ["?"] = false, -- in buffer search
                    ["C"] = "",    -- default "close_node"
                    ["P"] = "",
                    ["S"] = "",    -- default "split_with_window_picker",
                    ["s"] = "",    -- default "vsplit_with_window_picker",
                    ["t"] = "",    -- default "open_tabnew"
                    ["w"] = "",    -- "open_with_window_picker",
                    ["z"] = "",
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
                use_libuv_file_watcher = true,      -- This will use the OS level file watchers to detect changes
                hijack_netrw_behavior = "disabled", -- disabled, open_current, open_default
                window = {
                    -- position = "float",
                    mappings = {
                        ["H"] = "toggle_hidden",
                        [k.tree.cd] = "set_root",
                        [k.tree.cd_parent] = "navigate_up",
                        [k.tree.git_next] = "next_git_modified",
                        [k.tree.git_previous] = "prev_git_modified",
                        [k.tree.grep_node] = "telescope_grep",
                        [k.tree.search_node] = "telescope_find",
                        -- disabled
                        ["/"] = false,
                        ["<C-o>"] = false,
                        ["D"] = "",
                        ["f"] = "",
                    },
                },
                commands = {
                    -- FIXME: jump to neo-tree file after pressing enter in telescope
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
                        [k.tree.cd] = "set_root",
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
            -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
            file_size = {
                enabled = true,
                required_width = 64, -- min width of window required to show this column
            },
            type = {
                enabled = false,
                required_width = 110, -- min width of window required to show this column
            },
            last_modified = {
                enabled = true,
                required_width = 100, -- min width of window required to show this column
            },
            created = {
                enabled = false,
                required_width = 120, -- min width of window required to show this column
            },
            symlink_target = {
                enabled = true,
                required_width = 10, -- min width of window required to show this column
            },
            -- renderers = {
            --     directory = {
            --         {
            --             "container",
            --             content = {
            --                 -- optimize order
            --                 { "file_size",     zindex = 10, align = "left" },
            --                 -- { "type",          zindex = 10, align = "left" },
            --                 { "last_modified", zindex = 10, align = "left" },
            --                 { "created",       zindex = 10, align = "left" },
            --                 { "indent",        zindex = 10 },
            --             },
            --         },
            --         { "icon" },
            --         { "current_filter" },
            --         {
            --             "container",
            --             content = {
            --                 { "name",      zindex = 10 },
            --                 {
            --                     "symlink_target",
            --                     zindex = 10,
            --                     highlight = "NeoTreeSymbolicLinkTarget",
            --                 },
            --                 {
            --                     "git_status",
            --                     zindex = 10,
            --                     align = "left",
            --                     -- hide_when_expanded = true,
            --                 },
            --                 { "clipboard", zindex = 10 },
            --                 {
            --                     "diagnostics",
            --                     zindex = 20,
            --                     align = "right",
            --                     -- errors_only = true,
            --                     -- hide_when_expanded = true,
            --                 },
            --             },
            --         },
            --     },
            --     file = {
            --         {
            --             "container",
            --             content = {
            --                 -- optimize order
            --                 { "file_size",     zindex = 10, align = "left" },
            --                 -- { "type",          zindex = 10, align = "left" },
            --                 { "last_modified", zindex = 10, align = "left" },
            --                 { "created",       zindex = 10, align = "left" },
            --                 { "indent",        zindex = 10, align = "left" },
            --             },
            --         },
            --         { "icon" },
            --         {
            --             "container",
            --             content = {
            --                 { "name",        zindex = 10 },
            --                 {
            --                     "symlink_target",
            --                     zindex = 10,
            --                     highlight = "NeoTreeSymbolicLinkTarget",
            --                 },
            --                 { "git_status",  zindex = 10, align = "left" },
            --                 { "clipboard",   zindex = 10 },
            --                 { "bufnr",       zindex = 10 },
            --                 { "modified",    zindex = 20, align = "right" },
            --                 { "diagnostics", zindex = 20, align = "right" },
            --             },
            --         },
            --     },
            -- },
        })

        local custom_aug = vim.api.nvim_create_augroup("aryon/plugin/neo-tree.lua", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            pattern = { "neo-tree git_status*", "neo-tree buffers*", "neo-tree filesystem*" },
            group = custom_aug,
            desc = "Neo-tree centralizes cursor",
            callback = function(args)
                vim.keymap.set("n", "<C-e>", "5<C-e>", { silent = true, buffer = args.buffer })
                vim.keymap.set("n", "<C-y>", "5<C-y>", { silent = true, buffer = args.buffer })
                vim.cmd([[
                    setlocal scrolloff=99
                ]])
            end,
        })

        -- require("lsp-file-operations").setup()
    end,
}
