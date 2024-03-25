-- ```
-- {
--      name = "",
--      cmd = "",
--      desc = "",
-- }

local abbrs = {
    {
        name = "ff",
        cmd = "lua vim.lsp.buf.format({ async = false })",
        desc = "Lsp format",
    },
}

local function create_abbr(name, cmd)
    vim.cmd(string.format("cnoreabbrev %s %s", name, cmd))
end

for _, a in ipairs(abbrs) do
    create_abbr(a.name, a.cmd)
end
