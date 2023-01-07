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

function Player:draw()
    graphics.draw(
        self.sprite,
        self.x,
        self.y,
        playerMouseAngle(),
        nil,
        nil,
        self.sprite:getWidth() / 2,
        self.sprite:getHeight() / 2
    )
end

return Player
