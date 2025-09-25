local M = {}

---@class plugin.gf.Location
---@field file string relative path to the file
---@field line number of the line in the file
---@field col number of the column in the file

---@param abs boolean? whether to return absolute path or relative path
---@return plugin.gf.Location
function M.get_cloc(abs)
    abs = abs or false
    local path = vim.fn.expand("%:p")
    if not abs then
        -- "%" seems not to be so reliable
        local cwd = vim.fn.getcwd() .. "/"
        path = require("helper.lua").crop(path, cwd)
    end

    local line = vim.fn.line(".")
    local col = vim.fn.col(".")

    return {
        file = path,
        line = line or 1,
        col = col or 1,
    }
end

---supported format: <cWORD> with "file:line:col"
function M.smart_goto_loc()
    local cfile = vim.fn.expand("<cWORD>")
    print("cfile: " .. cfile)
    local parts = vim.split(cfile, ":")

    local file = parts[1]
    local line = tonumber(parts[2])
    local col = tonumber(parts[3])

    print("loc: " .. file .. " line: " .. (line or 1) .. " col: " .. (col or 1))

    -- Try relative to current working directory first
    if vim.fn.filereadable(file) ~= 1 then
        -- Try relative to current file's directory
        local current_dir = vim.fn.expand("%:p:h")
        file = current_dir .. "/" .. file
    end

    print("loc: " .. file .. " line: " .. (line or 1) .. " col: " .. (col or 1))

    if vim.fn.filereadable(file) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(file))
        if line then
            vim.fn.cursor(line, col or 1)
        end
    else
        -- Fall back to default gf behavior
        vim.cmd("normal! gf")
    end
end

-- Setup function
function M.setup(opts)
    opts = opts or {}

    opts = vim.tbl_deep_extend("force", {
        -- Default options can be set here
        default_option = true,
    }, opts)

    -- enhance gf
    vim.keymap.set("n", "gf", function()
        M.smart_goto_loc()
    end, { desc = "Go to file with cursor location" })
end

return M
