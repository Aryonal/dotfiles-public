return {
    "buoto/gotests-vim",
    ft = { "go" },
    cmd = {
        "GoTests",
        "GoTestsAll",
    },
    -- config = function ()
    --     vim.cmd([[
    --         -- let g:gotests_template_dir = '~/.local/share/gotests/template/'
    --     ]])
    -- end
}
