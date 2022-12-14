local Target = require("targets.target")

local RectangleTarget = Target:new()
RectangleTarget.minSideLength = MIN_RECT_TARGET_SIZE
RectangleTarget.maxSideLength = MAX_RECT_TARGET_SIZE
RectangleTarget.angle = TARGET_ROTATION_ANGLE

function RectangleTarget:new(width, height)
    local t = Target.new(self)
    t.width = math.random(self.minSideLength, self.maxSideLength)
    t.height = math.random(self.minSideLength, self.maxSideLength)
    t.angle = math.random() * math.pi
    return t
end

function RectangleTarget:update(dt)
    self:updateCenterPosition(dt)
    self.angle = (self.angle + 0.5 * dt * math.pi) % (2 * math.pi)
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
end

function RectangleTarget:isHit(x, y)
    if self.angle == 0 then
        return self.x - self.width / 2 <= x and
            x <= self.x + self.width / 2 and
            self.y - self.height / 2 <= y and
            y <= self.y + self.height / 2
    end
    local qGreater, qSmaller = 0, 0
    for _, f in pairs({ self.topLeftSideFunc, self.topRightSideFunc, self.belowRightSideFunc, self.belowLeftSideFunc }) do
        qGreater = qGreater + self:isGreater(f, x, y)
        qSmaller = qSmaller + self:isSmaller(f, x, y)
    end
    return qGreater >= 2 and qSmaller >= 2
end

function RectangleTarget:isGreater(f, x, y)
    return (f(self, x) >= y) and 1 or 0
end

function RectangleTarget:isSmaller(f, x, y)
    return (f(self, x) <= y) and 1 or 0
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

function RectangleTarget:topLeftSideFunc(x)
    return self:slope() * self:deltaX(x) +
        (self.height / 2) * math.cos(self.angle) * (1 + self:slope() ^ 2) + self.y
end

function RectangleTarget:belowRightSideFunc(x)
    return self:topLeftSideFunc(x) - (self.height / math.cos(self.angle))
end

function RectangleTarget:belowLeftSideFunc(x)
    return self:orthogonalSlope() * self:deltaX(x) -
        (self.width / 2) * math.sin(self.angle) * (1 + self:orthogonalSlope() ^ 2) + self.y
end

function RectangleTarget:topRightSideFunc(x)
    return self:belowLeftSideFunc(x) + (self.width / math.sin(self.angle))
end

return RectangleTarget
