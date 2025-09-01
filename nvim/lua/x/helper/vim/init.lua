-- print("[debug] Loading utils.vim")
local M = {}

-- Create autocmd. Usage: `create_autocmd(opts)`
--
-- `opts`:
-- ```lua
-- {
--      events = {},
--      buffer = 0,
--      group_name = "",
--      desc = "",
--      pattern = nil,
--      callback = function () {}
-- }
-- ```
function M.create_autocmd(opts)
    local custom_aug = vim.api.nvim_create_augroup(opts.group_name, { clear = true })
    vim.api.nvim_create_autocmd(opts.events, {
        group = custom_aug,
        buffer = opts.buffer,
        desc = opts.desc,
        pattern = opts.pattern,
        callback = opts.callback,
    })
end

M.default_cmd_opts = {}

-- Set command. Usage: `set_abbr(name, cmd)`
--
-- Example:
-- ```
-- set_abbr("Hello", "Hello World")
-- ```
function M.set_abbr(name, cmd)
    vim.cmd(string.format("cnoreabbrev %s %s", name, cmd))
end

-- Batch set abbreviations. Usage: `batch_set_abbr(abbrs)`
--
-- Example:
-- ```
-- batch_set_abbr({
--    { name = "Hello", cmd = "Hello World" },
--    { name = "Hello2", cmd = "Hello World2" },
-- })
-- ```
function M.batch_set_abbr(abbrs)
    for _, a in ipairs(abbrs) do
        M.set_abbr(a.name, a.cmd)
    end
end

---@class Command
---@field cmd string: command name
---@field desc string: command description
---@field abbr? string: command abbreviation
---@field key? string: key mapping for the command
---@field exec function: function to execute when the command is called
---@field opts? table: options for the command, see `h: nvim_create_user_command`

-- Set command. Usage: `set_cmd(cmd)`
-- See: `h: nvim_create_user_command`
---@param cmd Command: command structure
function M.set_cmd(cmd)
    local opts = cmd.opts or M.default_cmd_opts
    opts.desc = cmd.desc or opts.desc or ""

    vim.api.nvim_create_user_command(cmd.cmd, cmd.exec, opts)

    if cmd.abbr ~= nil then
        M.set_abbr(cmd.abbr, cmd.cmd)
    end

    if cmd.key ~= nil then
        vim.keymap.set("n", cmd.key, function()
            cmd.exec()
        end, { desc = cmd.desc or cmd.cmd, noremap = true, silent = true })
    end
end

-- Replacing keymap.set. Usage: `set_keymap(bind)`
--
-- Structure of `bind`:
-- ```lua
-- {
--   [1] = "<Left>", -- or {"<Left>", "<C-h>"}
--   [2] = "<C-w>h",
--   desc = "Window navigates left",
--   mode = "n",
--   opts = {
--     buffer = nil,
--     silent = true,
--     noremap = true,
--     nowait = false,
--   }
-- }
--
-- Default mode is 'n' if not specified.
-- ````
M.set_keymap = function(bind)
    if bind[1] == nil then
        vim.notify("key not specified")
        return
    end
    local opts = {
        silent = false,
        noremap = true,
        nowait = true,
        desc = bind.desc or bind[2],
    }
    bind.opts = bind.opts or opts
    if bind.opts.silent ~= nil then
        opts.silent = bind.opts.silent
    end
    if bind.opts.noremap ~= nil then
        opts.noremap = bind.opts.noremap
    end
    if type(bind[1]) == "table" then
        for _, k in ipairs(bind[1]) do
            vim.keymap.set(bind.mode or "n", k, bind[2], opts)
        end
        return
    end
    vim.keymap.set(bind.mode or "n", bind[1], bind[2], opts)
end

-- Batch set keymaps. Usage: `batch_set(binds)`
--
-- The `binds` is a list of `bind`. Structure of `bind`:
-- ```lua
-- {
--   [1] = "<Left>",
--   [2] = "<C-w>h",
--   desc = "Window navigates left",
--   mode = "n",
--   opts = {
--     buffer = nil,
--     silent = true,
--     noremap = true,
--     nowait = false,
--   }
-- }
-- ````
M.batch_set_keymap = function(binds)
    if binds == nil then
        return
    end
    for _, b in ipairs(binds) do
        M.set_keymap(b)
    end
end

-- Set keymap in a buffer. Usage: `set_buffer(bind, bufnr)`
--
-- Structure of `bind`:
-- ```lua
-- {
--   [1] = "<Left>",
--   [2] = "<C-w>h",
--   desc = "Window navigates left",
--   mode = "n",
--   opts = {
--     buffer = nil,
--     silent = true,
--     noremap = true,
--     nowait = false,
--   }
-- }
-- ````
M.set_buffer_keymap = function(bind, bufnr)
    if bind[1] == nil then
        vim.notify("key not specified")
        return
    end
    local opts = {
        silent = false,
        noremap = true,
        nowait = true,
        buffer = bufnr,
        desc = bind.desc or bind[2],
    }
    bind.opts = bind.opts or opts
    if bind.opts.silent ~= nil then
        opts.silent = bind.opts.silent
    end
    if bind.opts.noremap ~= nil then
        opts.noremap = bind.opts.noremap
    end
    if type(bind[1]) == "table" then
        for _, k in ipairs(bind[1]) do
            vim.keymap.set(bind.mode or "n", k, bind[2], opts)
        end
        return
    end
    vim.keymap.set(bind.mode or "n", bind[1], bind[2], opts)
end

function M.disable_netrw()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
end

function M.setup_netrw()
    vim.g.netrw_banner = 0
    vim.g.netrw_liststyle = 3
end

return M
