local custom_aug = vim.api.nvim_create_augroup("aryon/autocmds.lua", { clear = true })

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
    end
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    group = custom_aug,
    desc = "Highlight text after yank",
    callback = function()
        vim.highlight.on_yank()
    end,
})
