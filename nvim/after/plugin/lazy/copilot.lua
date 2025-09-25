local _setup_once = require("helper.lua").once(function()
    -- packadd copilot.lua
    if MiniDeps then
        MiniDeps.add({ source = "zbirenbaum/copilot.lua" })
    end

    local ok, copilot = pcall(require, "copilot")
    if not ok then
        return
    end

    copilot.setup({
        suggestion = {
            enabled = true,
            auto_trigger = true,
            keymap = {
                accept = "<Tab>",
                accept_word = false,
                accept_line = false,
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-c>",
            },
        },
        panel = { enabled = false },
        filetypes = {
            yaml = false,
            markdown = true,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false,
        },
    })
end)

require("helper.lazy").once_on_events(
    "after/plugin/copilot.lua",
    { "InsertEnter" },
    _setup_once
)
