local Bullet = {}
Bullet.speed = 130
Bullet.sprite = sprites.bullet

function Bullet:new(x, y, angle)
    local b = {}
    b.x, b.y, b.angle = x, y, angle
    setmetatable(b, self)
    self.__index = self
    return b
end

function Bullet:draw()
    graphics.draw(
        self.sprite,
        self.x,
        self.y,
        self.angle,
        0.5,
        nil,
        self.sprite:getWidth() / 2,
        self.sprite:getHeight() / 2
    )
end

return Bullet
