local M = {}

local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)),
           tonumber("0x" .. hex:sub(3, 4)),
           tonumber("0x" .. hex:sub(5, 6))
end

local function rgb_to_hex(r, g, b)
    return string.format("#%02x%02x%02x", r, g, b)
end

--- Alpha blends 2 colors given blending ratio
---@param a_hex string The first hex color (e.g. "#f38ba8")
---@param b_hex string The second hex color (e.g. "#1e1e2e")
---@param ratio number The blend ratio from 0.0 to 1.0 (e.g. 0.15)
---@return string hex The resulting blended hex color string
function M.hex_blend(a_hex, b_hex, ratio)
    local a_r, a_g, a_b = hex_to_rgb(a_hex)
    local b_r, b_g, b_b = hex_to_rgb(b_hex)

    -- Lua doesn't have math.round, math.floor(... + 0.5) is the standard
    local r = math.floor((a_r * ratio) + (b_r * (1 - ratio)) + 0.5)
    local g = math.floor((a_g * ratio) + (b_g * (1 - ratio)) + 0.5)
    local b = math.floor((a_b * ratio) + (b_b * (1 - ratio)) + 0.5)

    -- Clamp to valid values
    r = math.min(math.max(r, 0), 255)
    g = math.min(math.max(g, 0), 255)
    b = math.min(math.max(b, 0), 255)

    return rgb_to_hex(r, g, b)
end

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
