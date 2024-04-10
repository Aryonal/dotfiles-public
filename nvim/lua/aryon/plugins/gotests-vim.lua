return {
    "buoto/gotests-vim",
    enabled = false,
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
