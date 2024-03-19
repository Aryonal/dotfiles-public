return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    keys = { ";h" },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        local set = require("utils.keymap").set

        set({
            mode = "n",
            key = "ma",
            cmd = function()
                harpoon:list():append()
            end,
            desc = "[Harpoon] Append",
        })

        -- basic telescope configuration
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
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
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                })
                :find()
        end
        set({
            mode = "n",
            key = ";h",
            cmd = function()
                toggle_telescope(harpoon:list())
            end,
            desc = "[Telescope] Toggle Harpoon",
        })
    end,
}
