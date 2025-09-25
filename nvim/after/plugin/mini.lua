local ok, trailspace = pcall(require, "mini.trailspace")
if ok then
    trailspace.setup()
end

-- splitjoin
local ok, splitjoin = pcall(require, "mini.splitjoin")
if ok then
    splitjoin.setup({
        mappings = {
            toggle = "<leader>j",
        }
    })
end

-- pairs
local ok, pairs = pcall(require, "mini.pairs")
if ok then
    pairs.setup({
        modes = { insert = true, command = false, terminal = false },
        mappings = {
            ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][\n), ]" },
            ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][\n, ]" },
            ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][\n}, ]" },
            -- ["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\] " },

            [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
            ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
            ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
            -- [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\] " },

            -- or use pattern `[^'%S\\a-zA-Z0-9][^a-zA-Z0-9]`
            ['"'] = { action = "closeopen", pair = '""', neigh_pattern = " [\n ]", register = { cr = false } },
            ["'"] = { action = "closeopen", pair = "''", neigh_pattern = " [\n ]", register = { cr = false } },
            ["`"] = { action = "closeopen", pair = "``", neigh_pattern = " [\n ]", register = { cr = false } },
        },
    })
end

-- hipattern
local ok, hipatterns = pcall(require, "mini.hipatterns")
if ok then
    hipatterns.setup({
        highlighters = {
            -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            fixme     = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
            hack      = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
            todo      = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
            note      = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

            -- Highlight hex color strings (`#rrggbb`) using that color
            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })
end
