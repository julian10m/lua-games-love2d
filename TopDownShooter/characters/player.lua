local Player = {}
Player.sprite = sprites.player
Player.speed = 120

function Player:new(x, y, angle)
    local p = {}
    p.x, p.y, p.angle = graphics.getWidth() / 2, graphics.getHeight() / 2, 0
    setmetatable(p, self)
    self.__index = self
    return p
end

function Player:draw(x, y)
    graphics.draw(
        self.sprite,
        self.x,
        self.y,
        self:getAngle(x, y),
        nil,
        nil,
        self.sprite:getWidth() / 2,
        self.sprite:getHeight() / 2
    )
end

function Player:getAngle(x, y)
    return math.atan((y - self.y) / (x - self.x))
end

return Player
