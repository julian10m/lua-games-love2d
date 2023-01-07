local Zombie = {}
Zombie.speed = 130
Zombie.sprite = sprites.zombie

function Zombie:new(x, y, angle)
    local z = {}
    if x and y and angle then
        z.x, z.y, z.angle = x, y, angle
    else
        z.x, z.y, z.angle = self:getSpawnPosition()
    end
    setmetatable(z, self)
    self.__index = self
    return z
end

function Zombie:getSpawnPosition()
    local x, y, side = nil, nil, math.random(1, 4)
    if side == 1 then
        x, y = -30, math.random() * graphics.getHeight()
    elseif side == 2 then
        x, y = graphics.getWidth() + 30, math.random() * graphics.getHeight()
    elseif side == 3 then
        x, y = math.random() * graphics.getWidth(), -30
    else
        x, y = math.random() * graphics.getWidth(), graphics.getHeight() + 30
    end
    return x, y, playerZombieAngle(x, y)
end

function Zombie:draw()
    graphics.draw(
        self.sprite,
        self.x,
        self.y,
        self.angle,
        nil,
        nil,
        self.sprite:getWidth() / 2,
        self.sprite:getHeight() / 2
    )
end

return Zombie
