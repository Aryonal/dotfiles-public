return {
    "lewis6991/gitsigns.nvim",
    version = "*", -- To use the latest release
    event = require("utils.lazy").events_presets.LazyFile,
    init = function()
        vim.cmd([[
            hi! link GitSignsCurrentLineBlame Comment
        ]])
        require("utils.vim").create_autocmd({
            events = { "ColorScheme" },
            group_name = "aryon/gitsigns.lua",
            desc = "Link GitSignsCurrentLineBlame to Comment",
            callback = function()
                vim.cmd([[
                    hi! link GitSignsCurrentLineBlame Comment
                ]])
            end,
        })
    end,
    config = function()
        local bmap = require("utils.vim").set_buffer_keymap
        local c = require("aryon.config").keymaps

        local virtual_text_spaces = ""
        for _ = 1, require("aryon.config").ui.virtual_text_space do
            virtual_text_spaces = virtual_text_spaces .. " "
        end

        local cfg = require("aryon.config")

        require("gitsigns").setup({
            signs = {
                add = { text = "+" },
                untracked = { text = "+" },
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = true,      -- Toggle with `:Gitsigns toggle_numhl`
            -- linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            -- word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
            -- watch_gitdir = {
            --   interval = 1000,
            --   follow_files = true
            -- },
            -- attach_to_untracked = true,
            current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                --   virt_text = true,
                virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
                delay = cfg.vim.default_delay_ms,
                --   ignore_whitespace = false,
            },
            current_line_blame_formatter = virtual_text_spaces .. "<author>, <author_time:%Y-%m-%d> - <summary>",
            -- sign_priority = 6,
            -- update_debounce = 100,
            -- status_formatter = nil, -- Use default
            -- max_file_length = 40000,
            preview_config = {
                -- Options passed to nvim_open_win
                border = require("aryon.config").ui.float.border,
                -- style = 'minimal',
                -- relative = 'cursor',
                -- row = 0,
                -- col = 1
            },
            -- yadm = {
            --   enable = false
            -- },
            on_attach = function(bufnr)
                local gs = require("gitsigns")

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                bmap({
                    c.motion.buffer.git_hunk_next,
                    function() gs.nav_hunk("next") end,
                    desc = "[Gitsigns] Next hunk",
                }, bufnr)

                bmap({
                    c.motion.buffer.git_hunk_prev,
                    function() gs.nav_hunk("prev") end,
                    desc = "[Gitsigns] Previous hunk",
                }, bufnr)

                bmap({
                    "]c",
                    function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "]c", bang = true })
                        else
                            gs.nav_hunk("next")
                        end
                    end,
                    desc = "[Gitsigns] Next hunk",
                }, bufnr)

                bmap({
                    "[c",
                    function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "[c", bang = true })
                        else
                            gs.nav_hunk("prev")
                        end
                    end,
                    desc = "[Gitsigns] Previous hunk",
                }, bufnr)

                -- Actions
                bmap({
                    "<leader>hp",
                    gs.preview_hunk,
                    desc = "[Gitsigns] Preview hunk",
                }, bufnr)
                bmap({
                    "<leader>hd",
                    gs.diffthis,
                    desc = "[Gitsigns] Diff this",
                }, bufnr)
                bmap({
                    "<leader>hD",
                    function() gs.diffthis("~") end,
                    desc = "[Gitsigns] Diff this",
                }, bufnr)

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "[Gitsigns] inner hunk" })
            end,
        })

        local create_abbr_batch = require("utils.vim").batch_set_abbr
        local abbrs = {
            {
                name = "gs",
                cmd = "Gitsigns",
                desc = "Gitsigns",
            },
        }
        create_abbr_batch(abbrs)
    end,
}
