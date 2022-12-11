local Target = require("target")

local RectangleTarget = Target:new()
RectangleTarget.width = TARGET_WIDTH
RectangleTarget.height = TARGET_HEIGHT

function RectangleTarget:new(width, height)
    local t = Target.new(self)
    if width then
        t.width = width
        if height then
            t.height = height
        end
    end
    return t
end

function RectangleTarget:place(x, y)
    self.x = x or math.random(0, graphics.getWidth() - self.width)
    self.y = y or math.random(0, graphics.getHeight() - self.height)
end

function RectangleTarget:draw()
    graphics.setColor(1, 0, 0)
    graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    graphics.setColor(1, 1, 1)
end

function RectangleTarget:isHit(x, y)
    return self.x <= x and x <= self.x + self.width and self.y <= y and y <= self.y + self.height
end

return RectangleTarget
