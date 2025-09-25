-- print("[debug] Loading utils.vim")
local M = {}

M.default_cmd_opts = {}

-- Set command. Usage: `set_abbr(name, cmd)`
--
-- Example:
-- ```
-- set_abbr("Hello", "Hello World")
-- ```
function M.set_abbr(name, cmd)
    vim.cmd([[cnoreabbrev <expr> ]] ..
        name ..
        " getcmdtype() ==# ':' && getcmdline() ==# '" ..
        name ..
        "' ? '" ..
        cmd .. "' : '" ..
        name .. "'"
    )
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

function M.disable_netrw()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
end

function M.setup_netrw()
    vim.g.netrw_banner = 0
    vim.g.netrw_liststyle = 3
end

return M
