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

---@param interval_ms number: the interval to debounce.
---@param fn fun(...): any the function to debounce.
---@return fun(...): any | nil
function M.cached_debounce(interval_ms, fn)
    local last = 0
    local cache = nil

    return function(...)
        local now = vim.uv.now()
        if now - last < interval_ms then
            return cache
        end
        last = now
        cache = fn(...)
        return cache
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

---cache the result of a function, so that it only executes once.
---@param fn fun(...): any the function to cache.
---@return fun(...): any the cached function.
function M.cache(fn)
    local executed = false
    local r = nil
    return function()
        if not executed then
            executed = true
            r = fn()
        end
        return r
    end
end

---Create a new function that calls `hook` before calling `fn`.
---@param hook fun(...): any the function to call before `fn`.
---@param fn fun(...): any the function to call after `hook`.
---@return fun(...): any the new function.
function M.prehook(hook, fn)
    return function(...)
        hook(...)
        return fn(...)
    end
end

---Create a new function that calls `fn` only once.
---@param fn fun(...): any the function to call before `hook`.
---@return fun(...): any the new function.
function M.once(fn)
    local executed = false
    return function(...)
        if not executed then
            executed = true
            return fn(...)
        end
    end
end

return M
