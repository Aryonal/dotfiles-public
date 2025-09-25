local bo = vim.bo -- buffer options

bo.tabstop = 4
bo.softtabstop = 4
bo.shiftwidth = 4
bo.expandtab = true

if vim.g.loaded_lazydev then
    return
end
vim.g.loaded_lazydev = true

local ok, lazydev = pcall(require, "lazydev")
if ok then
    lazydev.setup({
        library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    })
end
