---@class Utils
local Utils = {}

---Returns the Euclidean distance between points (x1, y1) and (x2, y2)
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function Utils:distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

---Rounds a number to a given number of digits.
---@param value number
---@param digits number
---@return number
function Utils:roundValue(value, digits)
    local inverse = 1 / (10 ^ digits)
    return value - value % inverse
end

return Utils
