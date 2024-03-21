return {
    "saadparwaiz1/cmp_luasnip",
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            dependencies = {
                "rafamadriz/friendly-snippets",
            },
            version = "*",
            -- install jsregexp (optional!).
            build = "make install_jsregexp",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        "hrsh7th/nvim-cmp", -- load after nvim-cmp
    },
    event = { "InsertEnter", "CmdlineEnter" },
}
