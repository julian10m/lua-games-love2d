---@class Target
---@field protected x number
---@field protected y number
---@field protected xSpeed number
---@field protected ySpeed number
local Target = {}

Target.minInitialSpeed = TARGET_MIN_INITIAL_SPEED
Target.maxInitialSpeed = TARGET_MAX_INITIAL_SPEED

---Constructor returning a new target object.
---@return table
function Target:new()
    local t = {}
    setmetatable(t, self)
    self.__index = self
    self.reloadSpeed(t)
    return t
end

---Sets new values for both the x and y speeds of the target.
function Target:reloadSpeed()
    self.xSpeed = math.random(self.minInitialSpeed, self.maxInitialSpeed) * (math.random() < 0.5 and -1 or 1)
    self.ySpeed = math.random(self.minInitialSpeed, self.maxInitialSpeed) * (math.random() < 0.5 and -1 or 1)
end

---Updates the state of the target
---@param dt number
function Target:update(dt)
    self:updateCenterPosition(dt)
end

---Updates the center position of the target
---@param dt number
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

---Sets the position of the target
---@param x number
---@param y number
function Target:place(x, y) end

---Draws the target on the game
function Target:draw() end

---Tells whether a point (x, y) touches the target
---@param x number
---@param y number
function Target:isHit(x, y) end

return Target
