local M = {}

function M.is_linux()
    return vim.uv.os_uname().sysname == "Linux"
end

function M.is_mac()
    return vim.uv.os_uname().sysname == "Darwin"
end

function M.is_wsl()
    local output = vim.fn.systemlist "uname -r"
    return not not string.find(output[1] or "", "WSL")
end

function M.is_windows()
    -- TODO: find a better way to detect win32
    return false
end

return M
