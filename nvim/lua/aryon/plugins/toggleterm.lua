local c = require("aryon.config").keymaps
return {
    "akinsho/toggleterm.nvim",
    branch = "main",
    keys = {
        { c.vim.terminal.toggle, desc = "[ToggleTerm] Toggle" },
    },
    config = function()
        -- local win_opts = require("aryon.config.winopts")

        require("toggleterm").setup({
            -- size can be a number or function which is passed the current terminal
            -- size = 20 | function(term)
            --   if term.direction == "horizontal" then
            --     return 15
            --   elseif term.direction == "vertical" then
            --     return vim.o.columns * 0.4
            --   end
            -- end,
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = c.vim.terminal.toggle,
            -- on_open = fun(t: Terminal), -- function to run when the terminal opens
            -- on_close = fun(t: Terminal), -- function to run when the terminal closes
            -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
            -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
            -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
            -- hide_numbers = true, -- hide the number column in toggleterm buffers
            -- shade_filetypes = {},
            -- shade_terminals = true,
            -- shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
            -- start_in_insert = true,
            -- insert_mappings = true, -- whether or not the open mapping applies in insert mode
            -- terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
            persist_size = false,
            direction = "float",
            -- direction = 'vertical'  | 'horizontal' | 'window' | 'float',
            close_on_exit = true, -- close the terminal window when the process exits
            -- shell = vim.o.shell, -- change the default shell
            -- This field is only relevant if direction is set to 'float'
            highlights = {
                NormalFloat = {
                    link = "NormalFloat",
                },
                FloatBorder = {
                    link = "FloatBorder",
                },
            },
            float_opts = {
                --   -- The border key is *almost* the same as 'nvim_open_win'
                --   -- see :h nvim_open_win for details on borders however
                --   -- the 'curved' border is a custom border type
                --   -- not natively supported but implemented in this plugin.
                border = require("aryon.config").ui.float.border,
                --   -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
                width = function()
                    local w = vim.o.columns
                    return math.min(math.max(120, math.ceil(w * 0.8)), math.floor(w * 0.9))
                end,
                height = function()
                    local h = vim.o.lines
                    return math.min(math.max(32, math.ceil(h * 0.5)), math.floor(h * 0.9))
                end,
                winblend = 0,
            },
            winbar = {
                enabled = true,
                name_formatter = function(term) --  term: Terminal
                    return term.name
                end,
            },
        })
    end,
}
