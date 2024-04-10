local M = {}

M.default_opts = {}

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
    local opts = cmd.opts or M.default_opts
    opts.desc = cmd.desc or opts.desc or ""

    vim.api.nvim_create_user_command(cmd.cmd, cmd.exec, opts)

    if cmd.abbr ~= nil then
        M.set_abbr(cmd.abbr, cmd.cmd)
    end

    ---TODO: add keymap setting
end

return M
