local Target = {}

function Target:new()
    local t = {}
    setmetatable(t, self)
    self.__index = self
    t.xSpeed = 2 * (math.random() < 0.5 and -1 or 1)
    t.ySpeed = 2 * (math.random() < 0.5 and -1 or 1)
    return t
end

function Target:update(dt)
    self:updateCenterPosition(dt)
end

function Target:updateCenterPosition(dt)
    local nextX = self.x + self.xSpeed
    local nextY = self.y + self.ySpeed
    if nextX < 0 or nextX > graphics.getWidth() then
        self.xSpeed = -1 * self.xSpeed
    end
    if nextY < 0 or nextY >= graphics.getHeight() then
        self.ySpeed = -1 * self.ySpeed
    end
    self.x = self.x + self.xSpeed
    self.y = self.y + self.ySpeed
end

function Target:place(x, y) end

function Target:draw() end

function Target:isHit(x, y) end

return Target
