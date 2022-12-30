---@type Target Target
local Target = require("targets.target")

---@class CircleTarget:Target
local CircleTarget = Target:new()
CircleTarget.minRadius = TARGET_MIN_RADIUS_CIRC
CircleTarget.maxRadius = TARGET_MAX_RADIUS_CIRC

---Constructor returning a new circle target object.
---@param radius number
---@return CircleTarget
function CircleTarget:new(radius)
    local t = Target.new(self)
    if radius then
        t.radius = radius
    else
        t.radius = math.random(self.minRadius, self.maxRadius)
    end
    return t
end

---Sets the position of the target
---@param x number
---@param y number
function CircleTarget:place(x, y)
    self.x = x or math.random(self.radius, graphics.getWidth() - self.radius)
    self.y = y or math.random(self.radius, graphics.getHeight() - self.radius)
end

---Draws the target on the game
function CircleTarget:draw()
    graphics.setColor(1, 0, 0)
    graphics.circle("fill", self.x, self.y, self.radius)
    -- graphics.draw(sprites.circleTarget, self.x - self.radius, self.y - self.radius)
end

---Tells whether a point (x, y) touches the target
---@param x number
---@param y number
---@return boolean
function CircleTarget:isHit(x, y)
    return distanceBetween(x, y, self.x, self.y) < self.radius
end

return CircleTarget
