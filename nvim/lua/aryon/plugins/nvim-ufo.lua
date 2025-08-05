---@diagnostic disable: unused-local
return {
    "kevinhwang91/nvim-ufo",
    enabled = false,
    version = "*",
    dependencies = {
        "kevinhwang91/promise-async",
        "williamboman/mason-lspconfig.nvim", -- it should be setup after lsp is set
        "nvim-treesitter/nvim-treesitter",
    },
    event = require("utils.lazy").events_presets.LazyFile,
    config = function()
        vim.o.foldcolumn = "0" -- '0' to disable foldcolumn
        vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        vim.o.fillchars = [[fold: ,foldopen:,foldsep: ,foldclose:>]]
        -- vim.o.fillchars = [[fold: ,foldopen:,foldsep: ,foldclose:]]

        ---@diagnostic disable-next-line: missing-fields
        require("ufo").setup({
            fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = ("... %d lines "):format(endLnum - lnum + 1)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end

                -- -- fill the rest of line with "-"
                -- if curWidth < targetWidth then
                --     suffix = suffix .. ("-"):rep(targetWidth - curWidth)
                -- end
                table.insert(newVirtText, { suffix, "UfoFoldedEllipsis" }) -- or "MoreMsg"
                return newVirtText
            end,
        })

        -- TODO: use global keymapping settings
        vim.keymap.set("n", require("aryon.config").keymaps.lsp.hover, function()
            local winid = require("ufo").peekFoldedLinesUnderCursor()
            if not winid then
                vim.lsp.buf.hover()
            end
        end, {
            desc = "[Ufo] Hover",
        })
    end,
}
