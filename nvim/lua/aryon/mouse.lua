vim.cmd([[
    aunmenu PopUp
    anoremenu PopUp.Back <C-o>
    anoremenu PopUp.Forward <C-i>
    amenu PopUp.-1- <NOP>
    anoremenu PopUp.Go\ To\ Definition <cmd>Telescope lsp_definitions<CR>
    anoremenu PopUp.Go\ To\ Type\ Definition <cmd>Telescope lsp_type_definitions<CR>
    anoremenu PopUp.Go\ To\ References <cmd>Telescope lsp_references<CR>
    anoremenu PopUp.Go\ To\ Implementations <cmd>Telescope lsp_implementations<CR>
    anoremenu PopUp.Trace\ Back <C-t>
    amenu PopUp.-2- <NOP>
    anoremenu PopUp.Open gx
    anoremenu PopUp.Inspect <cmd>Inspect<CR>
]])
