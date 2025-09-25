-- Simple plugin to interact with terminal using channel
-- User commands:
-- - TermJobReg: register current terminal as the target for sending jobs
-- - TermJobLast: rerun last command in the registered terminal
-- - TermJob: send a command to the registered terminal, using builtin input

local log_prefix = "term/job.lua: "

---@param ... string
local function log(...)
    vim.notify(log_prefix .. table.concat(vim.tbl_map(tostring, { ... }), " "))
end

local function error(...)
    vim.notify(log_prefix .. table.concat(vim.tbl_map(tostring, { ... }), " "), vim.log.levels.ERROR)
end

---@class plugin.term.Keymaps
---@field enabled boolean?
---@field register string?
---@field last string?
---@field run_cmd string?

---@class plugin.term.JobOpts
---@field enabled boolean?
---@field auto_register boolean?
---@field keymaps plugin.term.Keymaps?

---@type plugin.term.JobOpts
local defaults = {
    enabled = true,
    auto_register = false, -- Automatically register the current terminal buffer
    keymaps = {
        enabled = true,
        register = [[<C-\><C-r>]],
        last = [[<C-\><C-p>]],
        run_cmd = [[<C-\><C-o>]],
    }
}

local M = {}

local reg_term_channel = nil
local last_job_cmd = ""

local function register()
    local buf = vim.api.nvim_get_current_buf()
    local channel = vim.bo[buf].channel
    if channel == 0 then
        error("current buffer is not a terminal")
        return
    end
    reg_term_channel = channel
    log("registered terminal buffer: " .. buf .. " with channel: " .. channel)
end

local function run_last()
    if not reg_term_channel then
        error("no terminal buffer registered. Use :TermJobReg first")
        return
    end
    if not vim.api.nvim_get_chan_info(reg_term_channel).id then
        error("registered terminal channel is no longer valid")
        return
    end
    vim.cmd("call chansend(" .. reg_term_channel .. ', "\x1b\x5b\x41\\<cr>")') -- TODO: not work in Lua 5.1
end

local function run_command(opts)
    if not reg_term_channel then
        error("no terminal buffer registered. Use :TermJobReg first")
        return
    end
    local cmd = opts and opts.args or ""
    if cmd == "" then
        -- use vim.ui.input to get command from user
        vim.ui.input({ prompt = "Command: ", default = last_job_cmd or "" }, function(input)
            if not input or input == "" then
                return
            else
                cmd = input
            end
        end)
    end
    if cmd == "" then
        return
    end
    if not vim.api.nvim_get_chan_info(reg_term_channel).id then
        error("registered terminal channel is no longer valid")
        return
    end
    vim.api.nvim_chan_send(reg_term_channel, cmd .. "\n")
    -- Store the last command for rerun
    last_job_cmd = cmd
end

---@param opts plugin.term.JobOpts?
local function setup_job_commands(opts)
    vim.api.nvim_create_user_command(
        "TermJobReg",
        register,
        { desc = "Register current terminal buffer for job commands" }
    )

    vim.api.nvim_create_user_command(
        "TermJobLast",
        run_last,
        { desc = "Rerun last command in the registered terminal" }
    )

    vim.api.nvim_create_user_command("TermJob", function(opts)
        run_command(opts)
    end, {
        desc = "Send a command to the registered terminal",
        nargs = "?",
        complete = "shellcmd",
    })
end

---@param opts plugin.term.JobOpts?
local function setup_auto_commands(opts)
    if not opts or not opts.auto_register then
        return
    end

    -- auto register terminal buffer when entering a terminal
    -- FIXME: conflict with fzf-lua
    vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*",
        callback = function()
            local buf = vim.api.nvim_get_current_buf()
            local channel = vim.bo[buf].channel
            if channel ~= 0 then
                reg_term_channel = channel
                log("automatically registered terminal buffer: " .. buf)
            end
        end,
        desc = "Auto-register terminal buffer for job commands",
    })
end

---@param opts plugin.term.JobOpts?
local function setup_keymaps(opts)
    opts = vim.tbl_deep_extend("force", defaults, opts or {})

    vim.keymap.set(
        { "t", "n" },
        opts.keymaps.register,
        register,
        { noremap = true, silent = true, desc = "TermJobReg", }
    )
    vim.keymap.set(
        { "t", "n" },
        opts.keymaps.last,
        run_last,
        { noremap = true, silent = true, desc = "TermJobLast", }
    )
    vim.keymap.set(
        { "t", "n" },
        opts.keymaps.run_cmd,
        run_command,
        { noremap = true, silent = true, desc = "TermJob", }
    )
end

---@param opts plugin.term.JobOpts?
function M.setup_term_job(opts)
    opts = vim.tbl_deep_extend("force", defaults, opts or {})

    if not opts.enabled then
        return
    end

    setup_job_commands(opts)
    setup_auto_commands(opts)
    setup_keymaps(opts)
end

return M
