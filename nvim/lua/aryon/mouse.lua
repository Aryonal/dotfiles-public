vim.cmd([[
    aunmenu PopUp
    anoremenu PopUp.Back <C-o>
    anoremenu PopUp.Forward <C-i>
    anoremenu PopUp.New\ Tab <cmd>tabnew %<CR>
    amenu PopUp.-1- <NOP>
    anoremenu PopUp.Hover <cmd>lua vim.lsp.buf.hover()<CR>
    anoremenu PopUp.Go\ To\ Definition <cmd>lua vim.lsp.buf.definition()<CR>
    anoremenu PopUp.Go\ To\ References <cmd>lua vim.lsp.buf.references()<CR>
    anoremenu PopUp.Go\ To\ Type\ Definition <cmd>lua vim.lsp.buf.type_definition()<CR>
    anoremenu PopUp.Go\ To\ Implementations <cmd>lua vim.lsp.buf.implementations()<CR>
    anoremenu PopUp.Trace\ Back <C-t>
    amenu PopUp.-2- <NOP>
    anoremenu PopUp.<plug>Neotree <cmd>Neotree<CR>
    amenu PopUp.-3- <NOP>
    anoremenu PopUp.Open gx
    anoremenu PopUp.Inspect <cmd>Inspect<CR>
    anoremenu PopUp.Quit <cmd>q<CR>
]])
