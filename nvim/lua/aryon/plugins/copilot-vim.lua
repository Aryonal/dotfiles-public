return {
    "github/copilot.vim",
    enabled = false,
    config = function()
        -- vim.cmd([[
        --     imap <silent><script><expr> <C-]> copilot#Accept("\<CR>")
        --     let g:copilot_no_tab_map = v:true
        -- ]])
        require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
        })
    end,
}
