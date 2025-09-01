local M = {}

---@class FloatOpts
---@field enabled boolean? Whether to enable the floating terminal (default: true)
---@field width number? Width of the floating terminal window (absolute pixels if >= 1, percentage if < 1)
---@field height number? Height of the floating terminal window (absolute pixels if >= 1, percentage if < 1)
---@field border string? | table? Border style for the floating terminal window
---@field toggle_key string? Key to toggle the terminal window
---@field position string? Position of the floating terminal window ("center", "bottom", "top", "left", "right", "bottom-left", "bottom-right", "top-left", "top-right")


local default_border = { "─", "─", "─", "", "", "", "", "" }


---@type FloatOpts
local defaults = {
    enabled = true,
    width = 0.8,                 -- 80% of editor width (values < 1 are percentages, >= 1 are absolute pixels)
    height = 0.5,                -- 50% of editor height (values < 1 are percentages, >= 1 are absolute pixels)
    border = default_border,
    toggle_key = [[<C-\><C-\>]], -- Default key to toggle the terminal
    position = "bottom",         -- New option: "center", "bottom", "top", "left", "right", "bottom-left", "bottom-right", "top-left", "top-right"
}

local function create_auto_cmds(buf, win)
    -- Augroup
    local augroup = vim.api.nvim_create_augroup("FloatingTerminal", { clear = true })
    -- Autocmd to hide the window when losing focus
    vim.api.nvim_create_autocmd("WinLeave", {
        buffer = buf,
        group = augroup,
        once = true,
        callback = function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_hide(win)
            end
        end,
    })

    return augroup
end

local function calculate_position(width, height, position)
    local total_width = vim.o.columns
    local total_height = vim.o.lines
    local col, row

    if position == "center" then
        col = math.floor((total_width - width) / 2)
        row = math.floor((total_height - height) / 2)
    elseif position == "bottom" then
        col = math.floor((total_width - width) / 2)
        row = total_height - height - 3 -- Account for command line and statusline
    elseif position == "top" then
        col = math.floor((total_width - width) / 2)
        row = 1 -- Account for tabline/statusline
    elseif position == "left" then
        col = 0
        row = math.floor((total_height - height) / 2)
    elseif position == "right" then
        col = total_width - width
        row = math.floor((total_height - height) / 2)
    elseif position == "bottom-left" then
        col = 0
        row = total_height - height - 2
    elseif position == "bottom-right" then
        col = total_width - width
        row = total_height - height - 2
    elseif position == "top-left" then
        col = 0
        row = 1
    elseif position == "top-right" then
        col = total_width - width
        row = 1
    else
        -- Default to center if invalid position
        col = math.floor((total_width - width) / 2)
        row = math.floor((total_height - height) / 2)
    end

    -- Ensure we don't go out of bounds
    col = math.max(0, math.min(col, total_width - width))
    row = math.max(0, math.min(row, total_height - height))

    return col, row
end

local function calculate_dimensions(opts)
    local width, height

    if opts.position == "bottom" or opts.position == "top" then
        -- Full width for top/bottom positions
        width = math.floor(vim.o.columns) - 0 -- padding
        height = opts.height
        if height < 1 then
            height = math.floor(vim.o.lines * height)
        end
        height = height - 4 -- Account for statusline/cmdline
    elseif opts.position == "left" or opts.position == "right" then
        -- Full height for left/right positions
        height = math.floor(vim.o.lines - 2) -- Account for statusline/cmdline
        width = opts.width
        if width < 1 then
            width = math.floor(vim.o.columns * width)
        end
    else
        -- Center and corner positions use relative sizing
        width = opts.width
        height = opts.height
        if width < 1 then
            width = math.floor(vim.o.columns * width)
        end
        if height < 1 then
            height = math.floor(vim.o.lines * height)
        end
    end

    return width, height
end

local function create_floating_window(buf, opts)
    -- Calculate dynamic width and height based on position
    local width, height = calculate_dimensions(opts)

    -- Calculate the position based on the position option
    local col, row = calculate_position(width, height, opts.position)

    -- Create a buffer
    if vim.api.nvim_buf_is_valid(buf) then
        buf = buf
    else
        buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
    end

    -- Define window configuration
    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal", -- No borders or extra UI elements
        border = opts.border,
    }

    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, true, win_config)

    return { buf = buf, win = win }
end

---Setup float term
---@param opts FloatOpts? Optional configuration for the floating terminal
function M.setup_float_term(opts)
    opts = vim.tbl_deep_extend("force", defaults, opts or {})

    if not opts.enabled then
        return
    end

    local state = {
        floating = {
            buf = -1,
            win = -1,
        },
        aug = -1
    }

    local toggle_terminal = function()
        if not vim.api.nvim_win_is_valid(state.floating.win) then
            state.floating = create_floating_window(state.floating.buf, opts)
            if vim.bo[state.floating.buf].buftype ~= "terminal" then
                vim.cmd.terminal()
                state.floating.buf = vim.api.nvim_get_current_buf()
            end
            state.aug = create_auto_cmds(state.floating.buf, state.floating.win)
            vim.cmd("startinsert")
        else
            vim.api.nvim_win_close(state.floating.win, false)
        end
    end

    -- Example usage:
    -- Create a floating window with default dimensions
    vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})

    vim.keymap.set({ "t", "n" }, opts.toggle_key, "<cmd>Floaterminal<CR>", {
        noremap = true,
        silent = true,
        desc = "Toggle floating terminal",
    })
end

return M
