---@class Bullet
---@field public x number
---@field public y number
---@field private angle number in radians.
local Bullet = {}

Bullet.speed = 130
Bullet.sprite = sprites.bullet

---Constructor
---@param x number
---@param y number
---@param angle number in radians
---@return Bullet
function Bullet:new(x, y, angle)
    local b = {}
    b.x, b.y, b.angle = x, y, angle
    setmetatable(b, self)
    self.__index = self
    return b
end

---Updates the position
---@param dt number
function Bullet:update(dt)
    local dist = self.speed * dt
    self.x = self.x + dist * math.cos(self.angle)
    self.y = self.y + dist * math.sin(self.angle)
end

---Returns true if the bullet is off screen, otherwise false.
---@return boolean
function Bullet:isOffScreen()
    return self.x < 0 or self.y < 0 or self.x > graphics.getWidth() or self.y > graphics.getHeight()
end

---Draws a bullet.
function Bullet:draw()
    graphics.draw(
        self.sprite,
        self.x, self.y, self.angle,
        0.5, nil,
        self.sprite:getWidth() / 2, self.sprite:getHeight() / 2
    )
end

return Bullet
