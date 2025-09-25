local ok, flash = pcall(require, "flash")
if not ok then
    return
end

local keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
    { "S", mode = { "n" },           function() require("flash").treesitter() end, desc = "Flash Treesitter" }, -- conflict with surround in visual
    -- { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    -- { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    -- { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
}

for _, key in ipairs(keys) do
    vim.keymap.set(key.mode or "n", key[1], key[2], { desc = key.desc })
end

flash.setup({
    modes = {
        char = {
            enabled = true,                -- f F t T ; ,
            keys = { "f", "F", "t", "T" }, -- no ; ,
        }
    }
})
