local o = vim.o -- options

local M = {}

local indent_foldexpr = require("customs.fold.indent").indent_foldexpr
local forward_indent_foldexpr = require("customs.fold.indent").forward_indent_foldexpr

-- TODO: how to better manage this?
local indent_ft = {
    [""] = "",
    ["zsh"] = "",
}

local forward_indent_ft = {
    ["lazy"] = "",
}

function M.foldexpr()
    local buf = vim.api.nvim_get_current_buf()
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })

    if indent_ft[filetype] then
        return indent_foldexpr()
    elseif forward_indent_ft[filetype] then
        return forward_indent_foldexpr()
    end
    return vim.treesitter.foldexpr()
end

function M.foldtext()
    local start_line = vim.v.foldstart
    local end_line = vim.v.foldend
    local line_count = end_line - start_line + 1

    local start_text = vim.fn.getline(start_line)
    local end_text = vim.fn.getline(end_line)
    local indent = start_text:match("^%s*") or ""
    local text = start_text:gsub("^%s*", ""):gsub("%s*$", "")
    local end_part = end_text:gsub("^%s*", ""):gsub("%s*$", "")

    local fold_info = string.format(" ... %d lines ... ", line_count)
    local fold_content = text .. fold_info .. end_part
    local available_width = vim.o.columns - #indent - 5
    local dots = string.rep("⋅", math.max(0, available_width - #fold_content))

    return indent .. fold_content .. dots
end

function M.setup()
    o.foldmethod = "expr"
    -- o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    o.foldexpr = "v:lua.require'customs.fold'.foldexpr()"
    o.foldlevel = 99
    o.foldlevelstart = 99
    o.foldenable = true
    o.fillchars = [[foldopen:,foldclose:]]
    vim.opt.foldtext = "v:lua.require'customs.fold'.foldtext()"
end

return M
