local M = {}

---@class TermOpts
---@field float FloatOpts? Configuration for floating terminal
---@field job JobOpts? Configuration for job terminal

---@type TermOpts
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

---@param opts TermOpts?
function M.setup(opts)
    opts = vim.tbl_deep_extend("force", defaults, opts or {})
    require("x.plugin.term.float").setup_float_term(opts and opts.float or nil)
    require("x.plugin.term.job").setup_term_job(opts and opts.job or nil)
end

return M
