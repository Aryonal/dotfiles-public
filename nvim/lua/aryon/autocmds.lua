---@diagnostic disable: unused-function, unused-local
local config = require("aryon.config").vim

local custom_aug = vim.api.nvim_create_augroup("aryon/autocmd.lua", { clear = true })

if false then
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
        group = custom_aug,
        desc = "Update cwd based on argument",
        callback = function(args)
            -- buffer is a directory
            local is_directory = vim.fn.isdirectory(args.file) == 1
            -- buffer is a real file on the disk
            local is_real_file = vim.fn.filereadable(args.file) == 1
            -- buffer is a [No Name]
            -- local no_name = args.file == "" and vim.bo[args.buf].buftype == ""

            if is_directory then
                -- create a new, empty buffer
                vim.cmd.new()

                -- wipe the directory buffer
                vim.cmd.bw(args.buf)

                -- change to the directory
                vim.cmd.cd(args.file)

                local ok, _ = pcall(require, "neo-tree")
                if ok then
                    vim.cmd("Neotree current")
                end
            end

            if is_real_file then
                -- change to directory of file
                -- vim.cmd.cd(vim.fs.dirname(args.file))
                return
            end

            -- if no_name then
            --     vim.cmd.bw(args.buf)
            -- end
        end,
    })
end

vim.api.nvim_create_autocmd({ "TermOpen" }, {
    group = custom_aug,
    desc = "Disable line numbers in terminal buffers",
    callback = function(ev)
        vim.wo.number = false
        vim.wo.wrap = true
        vim.wo.statuscolumn = ""

        -- FIXME: some issue with telescope planets, but not big deal
        vim.cmd [[
            startinsert
        ]]
    end
})

vim.api.nvim_create_autocmd({ "TermClose" }, {
    group = custom_aug,
    desc = "Close window on terminal close",
    callback = function(ev)
        local cr = vim.api.nvim_replace_termcodes("<cr>", true, false, true)
        vim.api.nvim_feedkeys(cr, "t", false)
    end
})

-- highlight yanked text for 200ms using the "Visual" highlight group
-- REF: https://github.com/craftzdog/dotfiles-public/blob/cf96bcffa1120d0116e9dcf34e8540b0f254ad41/.config/nvim/lua/craftzdog/highlights.lua#L8
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    group = custom_aug,
    desc = "Highlight text after yank",
    callback = function()
        vim.highlight.on_yank()
    end,
})
