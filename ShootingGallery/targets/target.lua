local Target = {}

Target.xSpeed = 2
Target.ySpeed = 2

function Target:new()
    local t = {}
    setmetatable(t, self)
    self.__index = self
    return t
end

function Target:update(dt)
    self:updateCenterPosition(dt)
end

function Target:updateCenterPosition(dt)
    if self.x + self.xSpeed < 0 or self.x + self.xSpeed > graphics.getWidth() then
        self.xSpeed = -1 * self.xSpeed
    end
    if self.y + self.ySpeed < 0 or self.y + self.ySpeed >= graphics.getHeight() then
        self.ySpeed = -1 * self.ySpeed
    end
    self.x = self.x + self.xSpeed
    self.y = self.y + self.ySpeed
end

function Target:place(x, y) end

function Target:draw() end

function Target:isHit(x, y) end

return Target
