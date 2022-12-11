local Target = require("target")

local RectangleTarget = Target:new()
RectangleTarget.width = TARGET_WIDTH
RectangleTarget.height = TARGET_HEIGHT
RectangleTarget.angle = TARGET_ROTATION_ANGLE

function RectangleTarget:new(width, height)
    local t = Target.new(self)
    if width then
        t.width = width
        if height then
            t.height = height
        end
    end
    -- t.angle = math.pi * math.random()
    return t
end

function RectangleTarget:place(x, y)
    self.x = x or math.random(self.width / 2, graphics.getWidth() - self.width / 2)
    self.y = y or math.random(self.height / 2, graphics.getHeight() - self.height / 2)
end

function RectangleTarget:draw()
    graphics.setColor(1, 0, 0)
    graphics.push()
    graphics.translate(self.x, self.y)
    graphics.rotate(self.angle)
    -- graphics.rectangle("fill", 0, 0, self.width, self.height)
    graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height) -- origin in the middle
    graphics.pop()
    graphics.setColor(1, 1, 1)
end

function RectangleTarget:isHit(x, y)
    return self.x - self.width / 2 <= x and
        x <= self.x + self.width / 2 and
        self.y - self.height / 2 <= y and
        y <= self.y + self.height / 2
end

return RectangleTarget
