local Target = {}
Target.minInitialSpeed = MIN_INITIAL_SPEED_TARGET
Target.maxInitialSpeed = MAX_INITIAL_SPEED_TARGET

function Target:new()
    local t = {}
    setmetatable(t, self)
    self.__index = self
    self.reloadSpeed(t)
    return t
end

function Target:reloadSpeed()
    self.xSpeed = math.random(self.minInitialSpeed, self.maxInitialSpeed) * (math.random() < 0.5 and -1 or 1)
    self.ySpeed = math.random(self.minInitialSpeed, self.maxInitialSpeed) * (math.random() < 0.5 and -1 or 1)
end

function Target:update(dt)
    self:updateCenterPosition(dt)
end

function Target:updateCenterPosition(dt)
    local nextX = self.x + self.xSpeed * dt
    local nextY = self.y + self.ySpeed * dt
    if nextX < 0 or nextX > graphics.getWidth() then
        self.xSpeed = -1 * self.xSpeed
    end
    if nextY < 0 or nextY >= graphics.getHeight() then
        self.ySpeed = -1 * self.ySpeed
    end
    self.x = self.x + self.xSpeed * dt
    self.y = self.y + self.ySpeed * dt
end

function Target:place(x, y) end

function Target:draw() end

function Target:isHit(x, y) end

return Target
