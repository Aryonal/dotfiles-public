return {
    "nvim-lualine/lualine.nvim",
    enabled = false,
    dependencies = {
        -- "nvim-tree/nvim-web-devicons",
    },
    -- lazy = false,
    config = function()
        local ft = require("aryon.config.ft")
        local icons = require("share.icons")
        -- local path_util = require("utils.path")

        -- local aerial_ok, _ = pcall(require, "aerial")
        local aerial_ok = false

        local gitsigns_ok, _ = pcall(require, "gitsigns")

        --- @param trunc_width number truncates component when screen width is less then trunc_width
        --- @param trunc_len number truncates component to trunc_len number of chars
        --- @param hide_width number hides component when window width is smaller then hide_width
        --- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
        --- return function that can format the component accordingly
        ---@diagnostic disable-next-line: unused-function, unused-local
        local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
            return function(str)
                local win_width = vim.fn.winwidth(0)
                if hide_width and win_width < hide_width then
                    return ""
                elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
                    return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
                end
                return str
            end
        end

        ---@diagnostic disable-next-line: unused-local, unused-function
        local function aerial()
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

        ---@diagnostic disable-next-line: unused-function, unused-local
        local function diff()
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

---@diagnostic disable-next-line: unused-local, unused-function
        local function workspace_diagnostics()
            return {
                "diagnostics",
                icons_enabled = true,
                sources = { "nvim_workspace_diagnostic" },
                colored = false,
                symbols = {
                    error = icons.error .. ":",
                    warn = icons.warn .. ":",
                    info = icons.info .. ":",
                    hint = icons.hint .. ":",
                },
            }
        end
        ---@diagnostic disable-next-line: unused-local, unused-function
        local function diagnostics()
            return {
                "diagnostics",
                icons_enabled = true,
                symbols = {
                    error = icons.error .. ":",
                    warn = icons.warn .. ":",
                    info = icons.info .. ":",
                    hint = icons.hint .. ":",
                },
            }
        end

---@diagnostic disable-next-line: unused-local, unused-function
        local function tab()
            return {
                "tabs",
                tab_max_length = 32,
                max_length = vim.o.columns,
                mode = 2, -- 0: Shows tab_nr 1: Shows tab_name 2: Shows tab_nr + tab_name
                path = 4, -- 1: relative 2: absolute 3: shortened absolute 4: file name
            }
        end

        ---@diagnostic disable-next-line: unused-local, unused-function
        local function filename()
            return {
                "filename",
                file_status = true, -- displays file status (readonly status, modified status)
                newfile_status = false,
                icons_enabled = true,
                path = 1, -- 0: just the filename
                -- 1: relative path
                -- 2: absolute path
                -- 3: absolute path, with tilde as the home directory

                shorting_target = 68, -- shortens path to leave 32 spaces in the window
                symbols = {
                    unnamed = icons.noname,
                    readonly = icons.readonly,
                },
            }
        end

        require("lualine").setup({
            options = {
                icons_enabled = false,
                theme = "auto", -- "auto",
                component_separators = { left = "", right = "" },
                -- section_separators = "",
                disabled_filetypes = {
                    statusline = ft.statusbar_exclude,
                    winbar = ft.winbar_exclude,
                },
                padding = { left = 1, right = 1 },
                globalstatus = true,
            },
            sections = {},
            inactive_sections = {},
            tabline = {
                lualine_a = {
                    -- function() return path_util.get_cwd_short(32) end,
                    -- -- tab(),
                    -- workspace_diagnostics(),
                },
                lualine_b = {
                    -- tab(),
                },
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    -- aerial()
                },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            inactive_winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
        })

        -- vim.o.showtabline = 1
    end,
}
