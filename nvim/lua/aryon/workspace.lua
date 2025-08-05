-- Temporary solution to local config overrides

local project_config = vim.fn.getcwd() .. "/.nvim/"

if vim.fn.isdirectory(project_config) == 1 then
    vim.opt.runtimepath:append(project_config)
end

local local_config = vim.fn.getcwd() .. "/.local/.nvim/"

if vim.fn.isdirectory(local_config) == 1 then
    vim.opt.runtimepath:append(local_config)
end
