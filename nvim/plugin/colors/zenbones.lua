local ok, _ = pcall(require, "zenbones")
if not ok then
    return
end

vim.o.termguicolors = true
vim.o.background = "dark" --  or dark
vim.o.winborder = "none"

-- one of:
-- - neobones
-- - vimbones
-- - rosebones
-- - forestbones
-- - nordbones
-- - tokyobones
-- - seoulbones
-- - duckbones
-- - zenburned
-- - kanagawabones
-- - randombones
vim.cmd("colorscheme zenbones")
