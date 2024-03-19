-- bootstrap
local lazyroot = vim.fn.stdpath("data") .. "/lazy/"
local lazypath = lazyroot .. "lazy.nvim"
local lazylock = vim.fn.stdpath("config") .. "/lazy-lock.json"

-- Install lazy.nvim if not exists.
local function init()
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)
end

local function is_very_lazy(p)
    if p.event then
        return false
    end
    if p.ft then
        return false
    end
    if p.cmd then
        return false
    end
    if p.keys then
        return false
    end
    if p.priority then
        return false
    end
    if p.lazy ~= nil then
        return false
    end
    return true
end

-- set default values
local function to_lazy_format(p)
    p.event = is_very_lazy(p) and "VeryLazy" or p.event
    return p
end

local function get_lazy_plugins(plugins)
    local pl = {}
    for _, p in ipairs(plugins) do
        table.insert(pl, to_lazy_format(p))
    end

    return pl
end

local default_opts = {
    root = lazyroot,
    defaults = {
        lazy = false, -- should plugins be lazy-loaded?
        version = nil,
        -- version = "*", -- enable this to try installing the latest stable versions of plugins
    },
    lockfile = lazylock,
    ui = {
        border = "rounded",
    },
    performance = {
        rtp = {
            reset = false,
        },
    },
}

-- Wrapper of `lazy.setup`.
--
-- Example:
-- ```lua
-- local plugins = {
--  { "folke/tokyonight.nvim" },
--  { "folke/trouble.nvim", cmd = "TroubleToggle" },
-- }
-- local opts = {}
--
-- setup(plugins, opts)
-- ```
local function setup(plugins, opts)
    opts = opts or default_opts
    plugins = get_lazy_plugins(plugins)
    require("lazy").setup(plugins, opts)
end

return {
    default_opts = default_opts,
    setup = setup,
    init = init,
}
