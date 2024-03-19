local M = {}

-- Replacing keymap.set. Usage: `set(bind)`
--
-- Structure of `bind`:
-- ```lua
-- {
--   mode = "n",
--   key = "<Left>", // or {"<Left>", "<C-h>"}
--   cmd = "<C-w>h",
--   desc = "Window navigates left",
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
M.set = function(bind)
    if bind.key == nil then
        vim.notify("key not specified")
        return
    end
    local opts = {
        silent = false,
        noremap = true,
        nowait = true,
        desc = bind.desc or bind.cmd,
    }
    bind.opts = bind.opts or opts
    if bind.opts.silent ~= nil then
        opts.silent = bind.opts.silent
    end
    if bind.opts.noremap ~= nil then
        opts.noremap = bind.opts.noremap
    end
    if type(bind.key) == "table" then
        for _, k in ipairs(bind.key) do
            vim.keymap.set(bind.mode or "n", k, bind.cmd, opts)
        end
        return
    end
    vim.keymap.set(bind.mode or "n", bind.key, bind.cmd, opts)
end

-- Batch set keymaps. Usage: `batch_set(binds)`
--
-- The `binds` is a list of `bind`. Structure of `bind`:
-- ```lua
-- {
--   mode = "n",
--   key = "<Left>",
--   cmd = "<C-w>h",
--   desc = "Window navigates left",
--   opts = {
--     buffer = nil,
--     silent = true,
--     noremap = true,
--     nowait = false,
--   }
-- }
-- ````
M.batch_set = function(binds)
    if binds == nil then
        return
    end
    for _, b in ipairs(binds) do
        M.set(b)
    end
end

-- Set keymap in a buffer. Usage: `set_buffer(bind, bufnr)`
--
-- Structure of `bind`:
-- ```lua
-- {
--   mode = "n",
--   key = "<Left>",
--   cmd = "<C-w>h",
--   desc = "Window navigates left",
--   opts = {
--     buffer = nil,
--     silent = true,
--     noremap = true,
--     nowait = false,
--   }
-- }
-- ````
M.set_buffer = function(bind, bufnr)
    local opts = {
        silent = false,
        noremap = true,
        nowait = true,
        buffer = bufnr,
        desc = bind.desc or bind.cmd,
    }
    bind.opts = bind.opts or opts
    if bind.opts.silent ~= nil then
        opts.silent = bind.opts.silent
    end
    if bind.opts.noremap ~= nil then
        opts.noremap = bind.opts.noremap
    end
    if type(bind.key) == "table" then
        for _, k in ipairs(bind.key) do
            vim.keymap.set(bind.mode or "n", k, bind.cmd, opts)
        end
        return
    end
    vim.keymap.set(bind.mode or "n", bind.key, bind.cmd, opts)
end

return M
