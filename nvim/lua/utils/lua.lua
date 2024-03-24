local M = {}

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

return M
