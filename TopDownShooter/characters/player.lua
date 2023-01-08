---@class Player
---@field public x number
---@field public y number
local Player = {}

Player.sprite = sprites.player
Player.speed = 120

---Constructor
---@return Player
function Player:new()
    local p = {}
    p.x, p.y = graphics.getWidth() / 2, graphics.getHeight() / 2
    setmetatable(p, self)
    self.__index = self
    return p
end

---Updates the position.
---@param dt number
function Player:update(dt)
    for key, key_action in pairs(validKeys) do
        if love.keyboard.isDown(key) then
            self[key_action.dir] = self[key_action.dir] + key_action.delta * self.speed * dt
        end
    end
end

---Draws the player looking at a point (x, y), i.e., rotated at the required angle.
---@param x number
---@param y number
function Player:draw(x, y)
    graphics.draw(
        self.sprite,
        self.x, self.y, self:getAngle(x, y),
        nil, nil,
        self.sprite:getWidth() / 2, self.sprite:getHeight() / 2
    )
end

---Returns the angle between a point (x, y) and the position where the player is.
---@param x number
---@param y number
---@return number angle in radians.
function Player:getAngle(x, y)
    return math.atan2((y - self.y), (x - self.x))
end

return Player
