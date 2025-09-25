-- Temporary solution to local config overrides
-- Compatible with projects w/ .nvim/ but w/o .nvim.lua, .nvimrc, .exrc

---@param pattern string
---@param cwd_only boolean?
---@return string|nil
local function find_pattern(pattern, cwd_only)
    local current_dir = vim.fn.getcwd()

    if cwd_only then
        local config_path = current_dir .. "/" .. pattern
        if vim.fn.isdirectory(config_path) == 1 then
            return config_path
        end
        return nil
    end

    while current_dir ~= "/" do
        local config_path = current_dir .. "/" .. pattern
        if vim.fn.isdirectory(config_path) == 1 then
            return config_path
        end
        current_dir = vim.fn.fnamemodify(current_dir, ":h")
    end

    return nil
end

local project_config = find_pattern(".nvim")
if project_config then
    vim.secure.read(project_config)
    vim.opt.runtimepath:append(project_config)
end

local local_config = find_pattern(".local/.nvim")
if local_config then
    vim.secure.read(local_config)
    vim.opt.runtimepath:append(local_config)
end
