local config = require("aryon.config").vim

local function vim_enter_directory_setup(args)
    -- vim.notify("VimEnter")
    -- buffer is a directory
    local is_directory = vim.fn.isdirectory(args.file) == 1
    -- buffer is a real file on the disk
    local real_file = vim.fn.filereadable(args.file) == 1
    -- buffer is a [No Name]
    local no_name = args.file == "" and vim.bo[args.buf].buftype == ""

    if is_directory then
        -- create a new, empty buffer
        -- vim.cmd.new()
        -- wipe the directory buffer
        vim.cmd.bw(args.buf)
        -- change to the directory
        vim.cmd.cd(args.file)
    end

    if real_file then
        -- change to directory of file
        vim.cmd.cd(vim.fs.dirname(args.file))
        return
    end

    -- if no_name then
    --     vim.cmd([[
    --         intro
    --     ]])
    -- end

    -- open the tree

    -- local nvim_tree_ok, nvim_tree_api = pcall(require, "nvim-tree.api")
    -- if nvim_tree_ok then
    --     nvim_tree_api.tree.open()
    -- end

    -- if real_file then
    --     nvim_tree_api.tree.toggle({ focus = false, find_file = true, })
    --     return
    -- end
end

local custom_aug = vim.api.nvim_create_augroup("aryon/autocmd.lua", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = custom_aug,
    desc = "Update cwd based on argument",
    callback = vim_enter_directory_setup,
})

if config.auto_load_session_local then
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
        group = custom_aug,
        desc = "Load session on enter",
        callback = function()
            local session_folder = vim.fn.stdpath("state") .. "/sessions"
            local cw = vim.fn.getcwd()
            cw = require("utils.path").strip_path(cw)
            local session_file = session_folder .. "/" .. require("utils.path").path_as_filename(cw) .. ".vim"
            vim.cmd(string.format("source %s", session_file))
        end,
    })
end

if config.auto_save_session_local then
    vim.api.nvim_create_autocmd({ "VimLeave" }, {
        group = custom_aug,
        desc = "Save session on leave",
        callback = function()
            local session_folder = vim.fn.stdpath("state") .. "/sessions"

            vim.fn.mkdir(session_folder, "p")
            if vim.fn.isdirectory(session_folder) ~= 1 then
                vim.notify("Failed to create session folder: " .. session_folder)
                return
            end

            local cw = vim.fn.getcwd()
            cw = require("utils.path").strip_path(cw)
            local session_file = session_folder .. "/" .. require("utils.path").path_as_filename(cw) .. ".vim"

            vim.cmd(string.format("mksession! %s", session_file))
        end,
    })
end

-- highlight yanked text for 200ms using the "Visual" highlight group
-- REF: https://github.com/craftzdog/dotfiles-public/blob/cf96bcffa1120d0116e9dcf34e8540b0f254ad41/.config/nvim/lua/craftzdog/highlights.lua#L8
if false then
    vim.api.nvim_create_autocmd({ "TextYankPost" }, {
        group = custom_aug,
        desc = "Highlight text after yank",
        callback = function()
            vim.highlight.on_yank({ higroup = "Visual", timeout = 500 })
        end,
    })
end

-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--     desc = "[Test] show intro",
--     callback = function(args)
--         vim.notify("BufEnter")
--     end,
-- })

-- vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave"}, {
--     group = custom_aug,
--     desc = "Refresh CodeLens",
--     callback = function ()
--         vim.lsp.codelens.refresh()
--     end
-- })
