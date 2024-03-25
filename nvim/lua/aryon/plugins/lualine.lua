return {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    -- lazy = false,
    config = function()
        local ft = require("share.ft")
        local icons = require("share.icons")
        local path_util = require("utils.path")

        -- local aerial_ok, _ = pcall(require, "aerial")
        local aerial_ok = false

        local gitsigns_ok, _ = pcall(require, "gitsigns")

        local function winnr()
            return vim.api.nvim_win_get_number(0) .. ":"
        end

        local function indentation()
            local spacetab = "Tab"
            local indents = vim.bo.tabstop
            if vim.bo.expandtab then
                spacetab = "Space"
                indents = vim.bo.softtabstop
            end
            local shifts = vim.bo.shiftwidth

            return spacetab .. ":" .. indents .. ":" .. shifts
        end

        local function get_aerial_component()
            if aerial_ok then
                return {
                    "aerial",
                    sep = " > ",
                    icons_enabled = false,
                    colored = true,
                    dense = true,
                    dense_sep = " > ",
                }
            end
            return {}
        end

        local function get_git_branch_component()
            -- gitsigns is only enabled when entring a buffer
            -- if gitsigns_ok then
            --     return { "b:gitsigns_head", icon = icons.git_branch, icons_enabled = true } -- branch using gitsigns
            -- end
            return { "branch", icon = icons.git_branch, icons_enabled = true }
        end

        local function get_diff_component()
            if gitsigns_ok then
                return {
                    "diff",
                    source = function()
                        local gitsigns = vim.b.gitsigns_status_dict
                        if gitsigns then
                            return {
                                added = gitsigns.added,
                                modified = gitsigns.changed,
                                removed = gitsigns.removed,
                            }
                        end
                    end,
                    colored = true,
                }
            end
            return { "diff", colored = true }
        end

        local function get_window_static_info_components()
            return {
                indentation,
                "encoding",
                {
                    "fileformat",
                    icons_enabled = true,
                    symbols = {
                        unix = "LF",
                        dos = "CRLF",
                        mac = "CR",
                    },
                },
                "filetype",
                "progress",
                "location",
            }
        end

        local function get_window_dynamic_info_components()
            return {
                get_diff_component(),
                {
                    "diagnostics",
                    icons_enabled = true,
                    symbols = {
                        error = icons.error .. ":",
                        warn = icons.warn .. ":",
                        info = icons.info .. ":",
                        hint = icons.hint .. ":",
                    },
                },
            }
        end

        local function get_file_navigation_components()
            return {
                winnr,
                {
                    "filename",
                    file_status = true, -- displays file status (readonly status, modified status)
                    newfile_status = false,
                    icons_enabled = true,
                    path = 1, -- 0: just the filename
                    -- 1: relative path
                    -- 2: absolute path
                    -- 3: absolute path, with tilde as the home directory

                    shorting_target = 32, -- shortens path to leave 40 spaces in the window
                    -- for other components. (terrible name, any suggestions?)
                    -- symbols = {
                    --     modified = "[+]", -- Text to show when the file is modified.
                    --     readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                    --     unnamed = "[No Name]", -- Text to show for unnamed buffers.
                    --     newfile = "[New]", -- Text to show for newly created file before first write
                    -- },
                },
            }
        end

        require("lualine").setup({
            options = {
                icons_enabled = false,
                theme = "auto",
                component_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = ft.lualine_statusbar_exclude,
                    winbar = ft.lualine_winbar_exclude,
                },
                padding = { left = 1, right = 1 },
                globalstatus = true,
            },
            sections = {
                lualine_a = { get_git_branch_component() },
                lualine_b = {},
                lualine_c = get_window_dynamic_info_components(),
                lualine_x = get_window_static_info_components(),
                lualine_y = {},
                lualine_z = {},
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {
                lualine_a = {
                    function()
                        return path_util.get_cwd_short(40)
                    end,
                },
                lualine_b = {
                    {
                        "tabs",
                        max_length = vim.o.columns, -- Maximum width of tabs component.
                        mode = 2,                   -- 0: Shows tab_nr
                        -- 1: Shows tab_name
                        -- 2: Shows tab_nr + tab_name
                        path = 1, -- 1: relative
                        -- 2: absolute
                        -- 3: shortened absolute
                        -- 4: file name
                    },
                },
                lualine_c = {},
                lualine_x = {},
                lualine_y = {
                    -- {
                    --     "windows",
                    --     mode = 2,
                    --     max_length = vim.o.columns / 3,
                    --     disabled_filetypes = ft.lualine_exclude,
                    -- },
                },
                lualine_z = {},
            },
            winbar = {
                lualine_a = {},
                lualine_b = get_file_navigation_components(),
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            inactive_winbar = {
                lualine_a = {},
                lualine_b = get_file_navigation_components(),
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            -- extensions = { "aerial" },
        })
    end,
}
