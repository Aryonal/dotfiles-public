local function toggle_telescope(harpoon_files, tel_conf)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers")
        .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
                results = file_paths,
            }),
            previewer = tel_conf.file_previewer({}),
            sorter = tel_conf.generic_sorter({}),
        })
        :find()
end

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    keys = {
        {
            ";h",
            function()
                toggle_telescope(require("harpoon"):list(), require("telescope.config").values)
            end,
            desc = "[Harpoon] Toggle Harpoon",
        },
        {
            "ma",
            function()
                require("harpoon"):list():append()
            end,
            desc = "[Harpoon] Append",
        },
    },
    config = function()
        ---@diagnostic disable-next-line: missing-parameter
        require("harpoon"):setup()
    end,
}
