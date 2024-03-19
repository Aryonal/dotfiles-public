return {
    "terrortylor/nvim-comment", -- TODO: try Comment.nvim
    config = function()
        local keymaps = {
            toggle = "<C-c>",
            toggle_chunk = "<leader>ic",
            toggle_visual = "<leader>gc",
        }

        require("nvim_comment").setup({
            -- -- Linters prefer comment and line to have a space in between markers
            -- marker_padding = true,
            -- should comment out empty or whitespace only lines
            comment_empty = false,
            -- -- trim empty comment whitespace
            -- comment_empty_trim_whitespace = true,
            -- -- Should key mappings be created
            -- create_mappings = true,
            -- Normal mode mapping left hand side
            line_mapping = keymaps.toggle,
            -- Visual/Operator mapping left hand side
            operator_mapping = keymaps.toggle, -- comment/uncomment visual lines
            -- operator_mapping = "gc",
            -- text object mapping, comment chunk,,
            comment_chunk_text_object = keymaps.toggle_chunk,
            -- comment_chunk_text_object = "ic",
            -- Hook function to call before commenting takes place
            hook = nil,
        })

        local map = require("utils.keymap").set

        map({
            key = keymaps.toggle,
            cmd = "<cmd>CommentToggle<cr>",
            desc = "[Comment] Toggle",
        })
        map({
            key = keymaps.toggle,
            cmd = ":'<,'>CommentToggle<cr>",
            mode = "v",
            desc = "[Comment] Toggle",
        })
    end,
}
