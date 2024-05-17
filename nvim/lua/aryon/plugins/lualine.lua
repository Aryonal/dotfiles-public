---@diagnostic disable: unused-local, unused-function, missing-parameter
return {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    dependencies = {
        -- "nvim-tree/nvim-web-devicons",
    },
    -- lazy = false,
    config = function()
        local ft = require("aryon.config.ft")
        local icons = require("share.icons")
        local path_util = require("utils.path")

        -- local aerial_ok, _ = pcall(require, "aerial")
        local aerial_ok = false

        local gitsigns_ok, _ = pcall(require, "gitsigns")

        --- @param trunc_width number truncates component when screen width is less then trunc_width
        --- @param trunc_len number truncates component to trunc_len number of chars
        --- @param hide_width number hides component when window width is smaller then hide_width
        --- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
        --- return function that can format the component accordingly
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

        local function winnr()
            return function()
                return vim.api.nvim_win_get_number(0)
            end
        end

        local function indentation()
            return function()
                local spacetab = "Tab"
                local indents = vim.bo.tabstop
                if vim.bo.expandtab then
                    spacetab = ""
                    indents = vim.bo.softtabstop
                    if indents < 0 then
                        indents = vim.bo.shiftwidth
                    end
                end
                local shifts = vim.bo.shiftwidth

                return spacetab .. " " .. indents .. ":" .. shifts
            end
        end

        local function encoding()
            return function()
                local enc = vim.opt.fileencoding:get()
                if enc == "utf-8" then
                    return ""
                end
                return enc
            end
        end

        local function format()
            return {
                "fileformat",
                icons_enabled = true,
                symbols = {
                    unix = "", -- default, don't show
                    dos = "CRLF",
                    mac = "CR",
                },
            }
        end

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

        local function branch()
            return {
                "branch",
                icon = icons.git_branch,
                icons_enabled = true,
                fmt = trunc(100, 8, 50)
            }
        end

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

        local function tab()
            return {
                "tabs",
                tab_max_length = 32,
                max_length = vim.o.columns,
                mode = 2, -- 0: Shows tab_nr 1: Shows tab_name 2: Shows tab_nr + tab_name
                path = 1, -- 1: relative 2: absolute 3: shortened absolute 4: file name
            }
        end

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
                theme = "auto",
                component_separators = { left = "", right = "" },
                -- section_separators = "",
                disabled_filetypes = {
                    statusline = ft.lualine_statusbar_exclude,
                    winbar = ft.lualine_winbar_exclude,
                },
                padding = { left = 1, right = 1 },
                globalstatus = false,
            },
            sections = {
                lualine_a = {
                    -- function() return path_util.get_cwd_short(32) end,
                },
                lualine_b = {
                },
                lualine_c = {
                    winnr(),
                    filename(),
                    diff(),
                    diagnostics(),
                },
                lualine_x = {
                    branch(),
                    indentation(),
                    encoding(),
                    format(),
                    -- "filetype",
                    "progress",
                    "location",
                },
                lualine_y = {},
                lualine_z = {},
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    winnr(),
                    filename(),
                },
                lualine_x = {
                    "location",
                },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {
                lualine_a = {
                    -- function() return path_util.get_cwd_short(32) end,
                    tab(),
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
                lualine_b = {
                    -- winnr(),
                    -- filename(),
                },
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
                lualine_c = {
                    -- winnr(),
                    -- filename(),
                },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
        })
    end,
}
