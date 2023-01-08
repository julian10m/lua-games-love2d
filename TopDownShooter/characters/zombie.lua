---@class Zombie
---@field public x number
---@field public y number
local Zombie = {}

Zombie.speed = 130
Zombie.sprite = sprites.zombie

---Constructor
---@param x number?
---@param y number?
---@return Zombie
function Zombie:new(x, y)
    local z = {}
    if x and y then
        z.x, z.y = x, y
    else
        z.x, z.y = self:getRandomSpawnPosition()
    end
    setmetatable(z, self)
    self.__index = self
    return z
end

---Returns a randomly generated spawn position.
---@return number, number
function Zombie:getRandomSpawnPosition()
    local x, y, side = nil, nil, math.random(1, 4)
    if side == 1 then
        y, x = math.random() * graphics.getHeight(), -30
    elseif side == 2 then
        y, x = math.random() * graphics.getHeight(), graphics.getWidth() + 30
    elseif side == 3 then
        x, y = math.random() * graphics.getWidth(), -30
    else
        x, y = math.random() * graphics.getWidth(), graphics.getHeight() + 30
    end
    return x, y
end

---Updates the position assuming the object is moving straight with a given angle during a time dt.
---@param angle number in radians.
---@param dt number
function Zombie:update(angle, dt)
    local dist = self.speed * dt
    self.x = self.x + dist * math.cos(angle)
    self.y = self.y + dist * math.sin(angle)
end

---Draws the zombie rotated a given angle.
---@param angle number in radians.
function Zombie:draw(angle)
    graphics.draw(
        self.sprite,
        self.x, self.y, angle,
        nil, nil,
        self.sprite:getWidth() / 2, self.sprite:getHeight() / 2
    )
end

return Zombie
