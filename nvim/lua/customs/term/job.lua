-- Simple plugin to interact with terminal using channel
-- User commands:
-- - TermJobReg: register current terminal as the target for sending jobs
-- - TermJobLast: rerun last command in the registered terminal
-- - TermJob: send a command to the registered terminal, using builtin input

---@class Keymaps
---@field enabled boolean?
---@field register string?
---@field last string?
---@field run_cmd string?

---@class JobOpts
---@field enabled boolean?
---@field auto_register boolean?
---@field keymaps Keymaps?

---@type JobOpts
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
        vim.notify("Current buffer is not a terminal", vim.log.levels.ERROR)
        return
    end
    reg_term_channel = channel
    vim.notify("Registered terminal buffer: " .. buf)
end

local function run_last()
    if not reg_term_channel then
        vim.notify("No terminal buffer registered. Use :TermJobReg first", vim.log.levels.ERROR)
        return
    end
    local cmd = last_job_cmd or ""
    if cmd == "" then
        -- use fallback
        vim.cmd("call chansend(" .. reg_term_channel .. ', "\x1b\x5b\x41\\<cr>")')
        return
    end
    vim.api.nvim_chan_send(reg_term_channel, cmd .. "\n")
end

local function run_command(opts)
    if not reg_term_channel then
        vim.notify("No terminal buffer registered. Use :TermJobReg first.", vim.log.levels.ERROR)
        return
    end
    local cmd = opts and opts.args or ""
    if cmd == "" then
        -- use vim.ui.input to get command from user
        vim.ui.input({ prompt = "Command: " }, function(input)
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
    -- Store the last command for rerun
    last_job_cmd = cmd
    vim.api.nvim_chan_send(reg_term_channel, cmd .. "\n")
end

---@param opts JobOpts?
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

---@param opts JobOpts?
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
                vim.notify("Automatically registered terminal buffer: " .. buf)
            end
        end,
        desc = "Auto-register terminal buffer for job commands",
    })
end

---@param opts JobOpts?
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

---@param opts JobOpts?
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
