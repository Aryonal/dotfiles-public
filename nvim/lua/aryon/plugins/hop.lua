local hop = {
    word = "ss",
    pattern = "sp",
    line = "sl",
}

return {
    "phaazon/hop.nvim", -- TODO: try leap.nvim
    branch = "v2", -- optional but strongly recommended
    keys = {
        {
            hop.word,
            "<cmd>HopWord<cr>",
            desc = "[Hop] Hop Word",
        },
        {
            hop.pattern,
            "<cmd>HopPattern<cr>",
            desc = "[Hop] Hop Pattern",
        },
        {
            hop.line,
            "<cmd>HopLine<cr>",
            desc = "[Hop] Hop Line",
        },
    },
    config = function()
        require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    end,
}
