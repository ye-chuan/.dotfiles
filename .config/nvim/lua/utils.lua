local M = {}

---@generic T
---@param arr T[]
---@param target T
---@return integer index
function M.arr_find(arr, target)
    for i, val in ipairs(arr) do
        if val == target then
            return i
        end
    end
    return -1
end

---@generic T
---@param arr T[]
---@param target T
---@return boolean
function M.arr_contains(arr, target)
    return M.arr_find(arr, target) >= 0
end

return M
