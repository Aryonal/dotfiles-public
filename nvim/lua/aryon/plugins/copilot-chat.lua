return {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = false,
    branch = "canary",
    dependencies = {
        { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
        { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    cmd = {
        "CopilotChat",
        "CopilotChatOpen",
        "CopilotChatExplain",
        "CopilotChatTests",
    },
    config = function()
        require("CopilotChat").setup()

        -- setup abbr
        require("utils.vim").set_abbr("cco", "CopilotChatOpen")
        require("utils.vim").set_abbr("cce", "CopilotChatExplain")
        require("utils.vim").set_abbr("cct", "CopilotChatTests")
    end,
}
