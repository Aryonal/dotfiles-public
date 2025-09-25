local ok, scrollview = pcall(require, "scrollview")
if not ok then
    return
end

scrollview.setup({
    excluded_filetypes = require("excluded-ft").base_exclude,
    current_only = true,
    signs_on_startup = { "cursor", "diagnostics", "search" },
    diagnostics_severities = { vim.diagnostic.severity.ERROR }
})
