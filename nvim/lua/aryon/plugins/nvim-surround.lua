return {
    "kylechui/nvim-surround",
    config = function()
        local surround = {
            insert = "<c-g>s",
            insert_line = "<c-g>S",
            normal = "ys",
            normal_cur = "yss",
            normal_line = "yS",
            normal_cur_line = "ySS",
            visual = "S",
            visual_line = "gS",
            delete = "ds",
            change = "cs",
        }

        require("nvim-surround").setup({
            keymaps = {
                insert = surround.insert,
                insert_line = surround.insert_line,
                normal = surround.normal,
                normal_cur = surround.normal_cur,
                normal_line = surround.normal_line,
                normal_cur_line = surround.normal_cur_line,
                visual = surround.visual,
                visual_line = surround.visual_line,
                delete = surround.delete,
                change = surround.change,
            },
        })
    end,
}
