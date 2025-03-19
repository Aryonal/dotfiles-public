local bo = vim.bo -- buffer options

bo.tabstop = 4
bo.softtabstop = 4
bo.shiftwidth = 4
bo.expandtab = true

-- TEMP, REMOVE ME
vim.cmd([[
augroup auto_update_tags
    autocmd!
    autocmd BufWritePost *.kt silent! !ctags -R --languages=kotlin --exclude=.git --exclude=build &
augroup END
]])
