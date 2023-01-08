---@class Utils
local Utils = {}

---Returns the Euclidean distance between points (x1, y1) and (x2, y2)
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function Utils.distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

---Returns true if the provided objects are "very" close and considered collided, otherwise false.
---@param objA Player|Zombie|Bullet
---@param objB Player|Zombie|Bullet
---@return boolean
function Utils:haveCollided(objA, objB)
    return self.distanceBetween(objA.x, objA.y, objB.x, objB.y) < MIN_COLLISION_DISTANCE
end

return Utils
