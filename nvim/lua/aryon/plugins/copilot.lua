return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        lazy = true,
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = false,
                    auto_trigger = false,
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
                    markdown = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ["."] = false,
                },
            })
        end,
    },
}
