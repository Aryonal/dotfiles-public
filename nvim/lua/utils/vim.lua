local M = {}

-- Create autocmd. Usage: `create_autocmd(opts)`
--
-- `opts`:
-- ```lua
-- {
--      events = {},
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
M.set_keymap = function(bind)
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
M.set_buffer_keymap = function(bind, bufnr)
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


-- Setup the float window border of hover window
--
-- Example:
-- ```lua
-- setup_lsp_float_borders("single")
-- ```
--
-- `default_border` is a string of default border style of lspconfig float window. Example: `default_border = "single"`
function M.setup_lsp_float_borders(default_border)
    -- border for lsp floating windows
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or default_border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end
end

-- Setup the LSP diagnostics icons.
--
-- `error_sign`, `warn_sign`, `hint_sign`, `info_sign` are strings of the icons. Example: `error_sign = ""`
function M.setup_lsp_diagnostics_icons(error_sign, warn_sign, hint_sign, info_sign)
    -- setup diagnostics icons
    local _signs = { Error = error_sign, Warn = warn_sign, Hint = hint_sign, Info = info_sign }
    for type, icon in pairs(_signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
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
function M.setup_lsp_diagnostics_text(diagnostics_prefix, virtual_text_spaces)
    -- print("prefix: "..diagnostics_prefix.."\nspaces: "..tostring(virtual_text_spaces))
    diagnostics_prefix = diagnostics_prefix or "■"
    virtual_text_spaces = virtual_text_spaces or 2
    -- print("prefix: "..diagnostics_prefix.."\nspaces: "..tostring(virtual_text_spaces))

    vim.diagnostic.config({
        signs = true,
        float = {
            source = true, -- Or "always"
            -- format = function(diagnostic)
            --     return string.format("%s:%s: %s", diagnostic.source, diagnostic.code, diagnostic.message)
            -- end,
        },
        underline = true,
        -- virtual_text = false,
        virtual_text = {
            source = "if_many",            -- Or "always"
            spacing = virtual_text_spaces, -- TODO: not working
            prefix = diagnostics_prefix,
            -- format = function(diagnostic)
            --     return string.format("%s:%s: %s", diagnostic.source, diagnostic.code, diagnostic.message)
            -- end,
        },
        severity_sort = true,
    })
end

function M.disable_netrw()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
end

return M
