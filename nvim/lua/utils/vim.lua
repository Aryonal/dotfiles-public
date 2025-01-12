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

-- Set command. Usage: `set_cmd(cmd)`
--
-- Structure of `cmd`
-- ```
-- {
--    cmd = "CommandName",
--    desc = "",
--    abbr = "",
--    exec = function () { print("hello") },
--    opts = {},
-- }
-- ```
--
-- See: `h: nvim_create_user_command`
function M.set_cmd(cmd)
    local opts = cmd.opts or M.default_cmd_opts
    opts.desc = cmd.desc or opts.desc or ""

    vim.api.nvim_create_user_command(cmd.cmd, cmd.exec, opts)

    if cmd.abbr ~= nil then
        M.set_abbr(cmd.abbr, cmd.cmd)
    end

    ---TODO: add keymap setting
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


-- Setup the float window border of hover window
--
-- Example:
-- ```lua
-- setup_lsp_float_borders("single")
-- ```
--
---@param default_border string: window border style, e.g. "none", "single", "double", "rounded", "solid"
function M.setup_lsp_float_borders(default_border)
    default_border = default_border or "rounded"
    -- border for lsp floating windows
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
        opts = opts or {}
        ---@diagnostic disable-next-line: inject-field
        opts.border = opts.border or default_border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end
end

-- Setup the LSP diagnostics icons.
--
-- `error_sign`, `warn_sign`, `hint_sign`, `info_sign` are strings of the icons. Example: `error_sign = ""`
function M.setup_lsp_diagnostics_icons(error_sign, warn_sign, hint_sign, info_sign)
    if vim.fn.has("nvim-0.10.0") == 1 then
        -- no need for nvim >= 0.10.0
        return
    end

    -- setup diagnostics icons
    local _signs = { Error = error_sign, Warn = warn_sign, Hint = hint_sign, Info = info_sign }
    for type, icon in pairs(_signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
    vim.diagnostic.config({
    })
end

-- Setup the LSP diagnostics virtual text.
--
-- Example:
-- ```lua
-- require("appearance").setup_lsp_diagnostics_text("■", 2)
-- ```
--
-- `diagnostics_prefix` is a string of the prefix of the virtual text. Example: `diagnostics_prefix = "■"`
-- `virtual_text_spaces` is a number of the spaces between the prefix and the message. Example: `virtual_text_spaces = 2`
---@param enabled boolean: enable virtual text
---@param diagnostics_prefix? string|function: prefix of the virtual text
---@param virtual_text_spaces? number: spaces between the prefix and the message
---@param diag_signs table: table of the diagnostic signs
function M.setup_lsp_diagnostics(enabled, diagnostics_prefix, virtual_text_spaces, diag_signs)
    if diagnostics_prefix == "dynamic" then
        if vim.fn.has("nvim-0.10.0") == 0 then
            diagnostics_prefix = nil
        end
        diagnostics_prefix = function(diagnostic)
            return diag_signs[diagnostic.severity] .. ":"
        end
    end
    diagnostics_prefix = diagnostics_prefix or "■"
    virtual_text_spaces = virtual_text_spaces or 2

    vim.diagnostic.config({
        float = {
            source = true, -- Or "always"
            -- format = function(diagnostic)
            --     return string.format("%s:%s: %s", diagnostic.source, diagnostic.code, diagnostic.message)
            -- end,
        },
        underline = true,
        -- virtual_text = false,
        virtual_text = enabled and {
            source = "if_many",            -- Or "always"
            spacing = virtual_text_spaces, -- TODO: not working
            prefix = diagnostics_prefix,
            -- format = function(diagnostic)
            --     return string.format("%s:%s: %s", diagnostic.source, diagnostic.code, diagnostic.message)
            -- end,
        },
        severity_sort = true,
        signs = {
            text = diag_signs,
        },
    })
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
