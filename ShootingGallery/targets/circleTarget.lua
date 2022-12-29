local Target = require("targets.target")

local CircleTarget = Target:new()
CircleTarget.minRadius = MIN_RADIUS_CIRC_TARGET
CircleTarget.maxRadius = MAX_RADIUS_CIRC_TARGET

function CircleTarget:new(radius)
    local t = Target.new(self)
    if radius then
        t.radius = radius
    else
        t.radius = math.random(self.minRadius, self.maxRadius)
    end
    return t
end

function CircleTarget:place(x, y)
    self.x = x or math.random(self.radius, graphics.getWidth() - self.radius)
    self.y = y or math.random(self.radius, graphics.getHeight() - self.radius)
end

function CircleTarget:draw()
    graphics.setColor(1, 0, 0)
    graphics.circle("fill", self.x, self.y, self.radius)
    -- graphics.draw(sprites.circleTarget, self.x - self.radius, self.y - self.radius)
end

function CircleTarget:isHit(x, y)
    return distanceBetween(x, y, self.x, self.y) < self.radius
end

return CircleTarget
