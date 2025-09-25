local M = {}

---@class plugin.term.TermOpts
---@field float plugin.term.FloatOpts? Configuration for floating terminal
---@field job plugin.term.JobOpts? Configuration for job terminal

---@type plugin.term.TermOpts
local defaults = {
    float = {
        enabled = true,
        width = 0.8,                 -- 80% of editor width (values < 1 are percentages, >= 1 are absolute pixels)
        height = 0.5,                -- 50% of editor height (values < 1 are percentages, >= 1 are absolute pixels)
        toggle_key = [[<C-\><C-\>]], -- Default key to toggle the terminal
        position = "bottom",         -- New option: "center", "bottom", "top", "left", "right", "bottom-left", "bottom-right", "top-left", "top-right"
    },
    job = {
        enabled = true,
        auto_register = false, -- Automatically register the current terminal buffer
        keymaps = {
            enabled = true,
            register = [[<C-\><C-r>]],
            last = [[<C-\><C-p>]],
            run_cmd = [[<C-\><C-o>]],
        }
    },
}

---@param opts plugin.term.TermOpts?
function M.setup(opts)
    opts = vim.tbl_deep_extend("force", defaults, opts or {})
    require("plugin.term.float").setup_float_term(opts and opts.float or nil)
    require("plugin.term.job").setup_term_job(opts and opts.job or nil)
end

return M
