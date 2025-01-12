-- Toggle float window

---@class FloatConfig
---@field title? string: default to be buffer name
---@field position? string: one of "center", "top", "left", "bottom", "right"
---@field size_percentage? number: percentage of window size to the editor, h/w ratio is same as editor
---@field width? number: window width, overwrites `size`, works if `position` is either "center", "left", "right"
---@field height? number: window height, overwrites `size`, works if `position` is either "center", "top", "bottom"
---@field border? string: one of "rounded", "single", "double", "shadow"

---@class Config
---@field float? FloatConfig
---@field keymaps? table<string, string>

---@type Config
local default_opts = {
    keymaps = {
        toggle = "",
        exit = "",
    },
    float = {
        position = "center",
        size_percentage = 80,
        border = "rounded",
    },
}

---@type vim.api.keyset.win_config
local default_win_opts = {
    title = "Please set the title",
    title_pos = "center",
    relative = "editor",
    width = 60,
    height = 20,
    col = 10,
    row = 10,
    anchor = "NW",
    style = nil,
}


---@class WinState
---@field number boolean: vim.wo.number
---@field cursorline boolean: vim.wo.cursorLine

---@class State
---@field buf? number
---@field win? number
---@field wo? WinState


---@class Module
---@field state? State
---@field opts? Config
---@field new? fun()
---@field setup? fun(opts: Config)

---@type Module
local M = {
    state = {
        buf = nil,
        win = nil,
    },
    opts = default_opts,
}

---Get win_opts from state and options
---@return vim.api.keyset.win_config
local function get_float_win_config()
    local width = default_win_opts.width
    local height = default_win_opts.height
    local col = default_win_opts.col
    local row = default_win_opts.row

    local w = M.opts.float.width
    local h = M.opts.float.height
    local size_p = M.opts.float.size_percentage

    if M.opts.float.position == "center" then
        width = w and w or (size_p and math.floor(vim.o.columns * size_p / 100))
        height = h and h or (size_p and math.floor(vim.o.lines * size_p / 100))

        col = math.floor((vim.o.columns - width) / 2)
        row = math.floor((vim.o.lines - height) / 2)
    elseif M.opts.float.position == "top" then
        width = vim.o.columns
        height = h and h or (size_p and math.floor(vim.o.lines * size_p / 100))

        col = 0
        row = 0
    elseif M.opts.float.position == "left" then
        width = w and w or (size_p and math.floor(vim.o.columns * size_p / 100))
        height = vim.o.lines

        col = 0
        row = 0
    elseif M.opts.float.position == "bottom" then
        width = vim.o.columns
        height = h and h or (size_p and math.floor(vim.o.lines * size_p / 100))

        col = 0
        row = vim.o.lines - height
    elseif M.opts.float.position == "right" then
        width = w and w or (size_p and math.floor(vim.o.columns * size_p / 100))
        height = vim.o.lines

        col = vim.o.columns - width
        row = 0
    else
        error("Invalid position")
    end


    local title = M.state.buf and vim.api.nvim_buf_get_name(M.state.buf) or ""

    return vim.tbl_deep_extend("force", default_win_opts, {
        title = M.opts.float.title or title,
        width = width,
        height = height,
        row = row,
        col = col,
        border = M.opts.float.border,
    })
end

---@param win number
local function save_state(win)
    print("save state: win: " .. win .. ", buf: " .. M.state.buf .. " new buf: " .. vim.api.nvim_win_get_buf(win))
    M.state.buf = vim.api.nvim_win_get_buf(win)
end

local function restore_state()
    -- do nothing
end

---@param augroup integer
local function set_auto_resize(augroup)
    vim.api.nvim_create_autocmd({ "VimResized" }, {
        group = augroup,
        callback = function()
            local win = M.state.win
            if not win then
                return
            end

            local win_configs = get_float_win_config()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_set_config(win, win_configs)
            end
        end,
    })
end

local function set_auto_close_on_leave(augroup)
    vim.api.nvim_create_autocmd({ "WinEnter" }, {
        group = augroup,
        callback = function()
            print("win enter")
            local win = M.state.win
            if not win then
                return
            end

            if vim.api.nvim_win_is_valid(win) then
                save_state(win)
                vim.api.nvim_win_close(win, true)
            end
        end,
        nested = true,
    })
end

local function set_auto_sync_win_buf(augroup)
    vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
        group = augroup,
        callback = function(args)
            local win = M.state.win
            if not win then
                return
            end

            if vim.api.nvim_win_is_valid(win) then
                M.state.buf = args.buf
                local win_configs = get_float_win_config()
                vim.api.nvim_win_set_config(win, win_configs)
            end
        end,
    })
end

local function new()
    if not M.state.buf or not vim.api.nvim_buf_is_valid(M.state.buf) then
        M.state.buf = vim.api.nvim_get_current_buf()
    end

    local win_configs = get_float_win_config()

    local win = vim.api.nvim_open_win(M.state.buf, true, win_configs or {})
    M.state.win = win

    restore_state()

    local augroup = vim.api.nvim_create_augroup("utils/vim/float.lua:" .. M.state.buf, { clear = true })

    set_auto_resize(augroup)
    set_auto_close_on_leave(augroup)
    -- set_auto_sync_win_buf(augroup)

    -- clean augroup when win closed
    vim.api.nvim_create_autocmd("WinClosed", {
        group = augroup,
        callback = function()
            if M.state.win then
                M.state.win = nil
                vim.api.nvim_clear_autocmds({
                    group = augroup,
                })
            end
        end,
    })


    -- TODO: window keymap
    -- TODO: sync win with buf
end

---@param opts? Config
function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, M.opts, opts or {})

    vim.api.nvim_create_user_command("Float", function()
        new()
    end, {
        desc = "Open a floating window",
    })
end

return M
