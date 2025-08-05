local function hash(path)
    local hash = 5381
    local MOD = 2^32 -- Use a large prime number for modulo to prevent overflow
    for i = 1, #path do
        hash = ((hash * 32) + hash + path:byte(i)) % MOD  -- hash * 33 + c
    end
    return string.format("%x", hash)
end

-- List of distinct paths to test
local paths = {
    "/home/user/docs",
    "/home/user/music",
    "/home/user/pictures",
    "/var/log/syslog",
    "/usr/local/bin",
    "/",
    "",
    "/usr/bin/local",
    "/Usr/bin/local",
}

-- Store hashes to check for uniqueness
local hashes = {}
local is_unique = true

for _, path in ipairs(paths) do
    local hash_value = hash(path)
    print("Path: " .. path .. " -> Hash: " .. hash_value)
    if hashes[hash_value] then
        print("Collision detected for path: " .. path)
        is_unique = false
    else
        hashes[hash_value] = true
    end
end

if is_unique then
    print("All hashes are unique.")
else
    print("Some hashes are not unique.")
end

