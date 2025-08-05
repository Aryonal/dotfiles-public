local ft = require("aryon.config.ft")
local statusline = require("customs.statusline.components")
local icons = require("assets.icons")

return {
    {
        "nvim-lualine/lualine.nvim",
        enabled = true,
        -- event = require("utils.lazy").events_presets.LazyFile,
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local function window(padding)
                padding = padding or 0
                return vim.api.nvim_win_get_number(0) .. string.rep(" ", padding)
            end
            local function diff_source()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                    return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed
                    }
                end
            end
            local filename = {
                "filename",
                path = 1, -- 0: Just the filename 1: Relative path 2: Absolute path 3: Absolute path, with tilde as the home directory 4: Filename and parent dir, with tilde as the home directory
                symbols = {
                    modified = "[+]", -- Text to show when the file is modified.
                    readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                    unnamed = "[無名]", -- Text to show for unnamed buffers.
                    newfile = "[New]", -- Text to show for newly created file before first write
                }
            }
            local workspace_diagnostics = {
                "diagnostics",
                sources = { "nvim_workspace_diagnostic" },
                separator = { left = "", right = "" }
            }
            local function file_encoding()
                return statusline.file_encoding(0)
            end
            local function file_format()
                return statusline.file_format(0)
            end
            local function indentation()
                return statusline.indentation({})
            end
            local function g_git_branch()
                if vim.g.statusline_git_branch == "" then
                    return ""
                end
                return icons.git_branch .. " " .. vim.g.statusline_git_branch
            end
            local function b_git_branch()
                if vim.b.gitsigns_head == "" then
                    return ""
                end
                return icons.git_branch .. " " .. vim.b.gitsigns_head
            end
            local lsp_status = {
                "lsp_status",
                icon = "", -- f013
                symbols = {
                    icons_enabled = true,
                    -- Standard unicode symbols to cycle through for LSP progress:
                    spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                    -- Standard unicode symbol for when LSP is done:
                    done = "✓",
                    -- Delimiter inserted between LSP names:
                    separator = " ",
                },
                -- List of LSP names to ignore (e.g., `null-ls`):
                ignore_lsp = {
                    "copilot",
                },
            }
            require("lualine").setup({
                options = {
                    icons_enabled = false,
                    disabled_filetypes = ft.statusbar_exclude,
                    separator = { left = "", right = "" }, -- 
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                    globalstatus = false,
                },
                sections = {
                    lualine_a = { function() return window() end },
                    lualine_b = {},
                    lualine_c = {
                        filename,
                        { "filetype", icons_enabled = true, icon_only = true, icon = { align = "right" }, padding = 0, },
                        { "diff",     source = diff_source },
                        "diagnostics"
                    },
                    lualine_x = {
                        file_encoding,
                        file_format,
                        indentation,
                        lsp_status,
                    },
                    lualine_y = {
                        "progress"
                    },
                    lualine_z = { "location" }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { function() return window(0) end, filename },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {
                    lualine_a = { statusline.cwd, g_git_branch, statusline.git_g_status },
                    lualine_b = { workspace_diagnostics, {
                        "tabs",
                        mode = 2, -- 0: Shows tab_nr, 1: Shows tab_name, 2: Shows tab_nr + tab_name
                        separator = nil,
                        max_length = vim.o.columns,
                        section_separators = { left = "", right = "" },
                        component_separators = { left = "", right = "" },
                        -- symbols = {
                        --     -- modified = "[+]", -- Text to show when the file is modified.
                        --     -- not supported below
                        --     -- readonly = "[-]",
                        --     -- unnamed = "[無名]",
                        --     -- newfile = "[New]",
                        -- }
                    } },
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {}
                },
                -- winbar = {
                --     lualine_a = { function() return window() end },
                --     lualine_b = {},
                --     lualine_c = {
                --         "filename",
                --         { "diff", source = diff_source },
                --         "diagnostics",
                --     },
                --     lualine_x = {},
                --     lualine_y = {},
                --     lualine_z = {}
                -- },
                -- inactive_winbar = {
                --     lualine_a = {},
                --     lualine_b = {},
                --     lualine_c = { function() return window() end, "filename" },
                --     lualine_x = {},
                --     lualine_y = {},
                --     lualine_z = {}
                -- },
                -- extensions = {
                --     "avante",
                -- },
            })
        end
    },
}
