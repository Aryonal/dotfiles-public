return {
    "echasnovski/mini.splitjoin",
    version = false,
    keys = {
        {
            "<leader>j",
            function()
                require("mini.splitjoin").toggle()
            end,
            desc = "[SplitJoin] Toggle",
        },
    },
    config = function()
        require("mini.splitjoin").setup()

        local set_cmd = require("utils.command").set_cmd
        local set_abbr = require("utils.command").set_abbr

        set_cmd({
            cmd = "SplitJoinToggle",
            desc = "[SplitJoin] Toggle",
            exec = function()
                require("mini.splitjoin").toggle()
            end,
        })
        set_abbr("sj", "SplitJoinToggle")
    end,
}
