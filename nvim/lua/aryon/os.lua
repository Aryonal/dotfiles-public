local function is_linux()
    return vim.loop.os_uname().sysname == "Linux"
end

local function is_mac()
    return vim.loop.os_uname().sysname == "Darwin"
end

local function is_wsl()
    local output = vim.fn.systemlist "uname -r"
    return not not string.find(output[1] or "", "WSL")
end

if is_linux() then
    -- yank to system clipboard
    vim.cmd([[
            set clipboard+=unnamedplus
            ]])
end

if is_mac() then
    -- yank to system clipboard
    vim.cmd([[
            set clipboard+=unnamedplus
            ]])
end

if is_wsl() then
    print("wsl is not ready yet")
end
