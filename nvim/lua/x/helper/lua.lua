local M = {}

---Check if a variable is an array.
---@param a table: the table to check.
---@return boolean
function M.is_array(a)
    if type(a) ~= "table" then
        return false
    end
    local i = 0
    for _ in pairs(a) do
        i = i + 1
        if a[i] == nil then
            return false
        end
    end
    return true
end

---Merge two tables into one.
---If elements in a and b share the same key, value from b will overwrite value from a.
---@param a table: the first table to merge.
---@param b table: the second table to merge.
---@return table: the merged table.
function M.merge_tbl(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then
        return {}
    end

    local m = {}
    for k, v in pairs(a) do
        m[k] = v
    end
    for k, v in pairs(b) do
        m[k] = v
    end

    return m
end

---crop string b from a,
-- e.g. crop("abcde", "abc") -> "de"
--      crop("abcde", "cd") -> "abe"
--      crop("abcde", "fg") -> "abcde"
---@param a string
---@param b string
---@return string
function M.crop(a, b)
    -- escape
    b = b:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
    local result = a:gsub(b, "")
    return result
end

local Lock = {}
Lock.__index = Lock

function Lock.new()
    local self = setmetatable({}, Lock)
    self._lock = false
    return self
end

function Lock:lock()
    self._lock = true
end

function Lock:unlock()
    self._lock = false
end

function Lock:locked()
    return self._lock
end

M.Lock = Lock

---wrap a function with debouncer.
---@param interval_ms number: the interval to debounce.
---@param fn fun(...): any the function to debounce.
---@return fun(...): any | nil
function M.debounce(interval_ms, fn)
    local last = 0

    return function(...)
        local now = vim.uv.now()
        if now - last < interval_ms then
            -- print("debounce: skipping function call")
            return
        end
        last = now
        return fn(...)
    end
end

---TODO: remove when window is closed, potential memory leak.
---
---Wrap a function with debouncer, fallback to cached result if called within interval.
---  All different calls share the same underlying timer.
---@param interval_ms number: the interval to debounce.
---@param key string: cache key.
---@param fn fun(...): any the function to debounce.
---@return fun(...): any | nil
function M.cached_debounce(interval_ms, key, fn)
    local last = 0
    local cache = {}
    key = key or 1

    return function(...)
        local now = vim.uv.now()
        if now - last < interval_ms then
            -- print("debounce: returning cached result")
            return cache[key]
        end
        last = now
        cache[key] = fn(...)
        return cache[key]
    end
end

function M.utf8_char_count(str)
    local count = 0
    local i = 1
    while i <= #str do
        local byte = string.byte(str, i)
        if byte < 128 then
            -- ASCII character (1 byte)
            i = i + 1
        elseif byte < 224 then
            -- 2-byte UTF-8 character
            i = i + 2
        elseif byte < 240 then
            -- 3-byte UTF-8 character
            i = i + 3
        else
            -- 4-byte UTF-8 character
            i = i + 4
        end
        count = count + 1
    end
    return count
end

return M
