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
    t.angle = math.random() * math.pi
    return t
end

function RectangleTarget:largestSide()
    return math.max(self.width, self.height)
end

function RectangleTarget:place(x, y)
    self.x = x or math.random(self:largestSide() / 2, graphics.getWidth() - self:largestSide() / 2)
    self.y = y or math.random(self:largestSide() / 2, graphics.getHeight() - self:largestSide() / 2)
end

function RectangleTarget:draw()
    graphics.setColor(1, 0, 0)
    graphics.push()
    graphics.translate(self.x, self.y)
    graphics.rotate(self.angle)
    graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height) -- origin in the middle
    graphics.pop()
    graphics.print("angle: " .. self.angle / math.pi, 5, graphics.getHeight() - 50)
    graphics.setColor(0, 0, 0)
    graphics.line(self.x - 50, self:rightSideFunc(self.x - 50), self.x + 50, self:rightSideFunc(self.x + 50))
    graphics.setColor(0, 0, 1)
    graphics.line(self.x - 50, self:topSideFunc(self.x - 50), self.x + 50, self:topSideFunc(self.x + 50))
    graphics.setColor(0, 1, 1)
    graphics.line(self.x - 50, self:leftSideFunc(self.x - 50), self.x + 50, self:leftSideFunc(self.x + 50))
    graphics.setColor(0, 1, 0)
    graphics.line(self.x - 50, self:belowSideFunc(self.x - 50), self.x + 50, self:belowSideFunc(self.x + 50))
    graphics.setColor(1, 1, 1)
end

function RectangleTarget:isHit(x, y)
    if self.angle == 0 then
        return self.x - self.width / 2 <= x and
            x <= self.x + self.width / 2 and
            self.y - self.height / 2 <= y and
            y <= self.y + self.height / 2
    end
    if self.angle < math.pi / 2 then
        return self:rightSideFunc(x) >= y and self:topSideFunc(x) >= y and
            self:leftSideFunc(x) <= y and self:belowSideFunc(x) <= y
    end
    return self:rightSideFunc(x) <= y and self:topSideFunc(x) >= y and
        self:leftSideFunc(x) >= y and self:belowSideFunc(x) <= y
end

function RectangleTarget:deltaX(x)
    return x - self.x
end

function RectangleTarget:slope()
    return math.tan(self.angle)
end

function RectangleTarget:orthogonalSlope()
    return -1 / self:slope()
end

function RectangleTarget:rightSideFunc(x)
    return self:slope() * self:deltaX(x) +
        (self.height / 2) * math.cos(self.angle) * (1 + self:slope() ^ 2) + self.y
end

function RectangleTarget:leftSideFunc(x)
    return self:rightSideFunc(x) - (self.height / math.cos(self.angle))
end

function RectangleTarget:belowSideFunc(x)
    -- this would be the top  side if the coordinates were not inverted
    return self:orthogonalSlope() * self:deltaX(x) -
        (self.width / 2) * math.sin(self.angle) * (1 + self:orthogonalSlope() ^ 2) + self.y
end

function RectangleTarget:topSideFunc(x)
    -- this would be the below side if the coordinates were not inverted
    return self:belowSideFunc(x) + (self.width / math.sin(self.angle))
end

return RectangleTarget
