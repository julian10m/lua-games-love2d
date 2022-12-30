local Target = require("targets.target")

local RectangleTarget = Target:new()
RectangleTarget.minSideLength = MIN_SIZE_RECT_TARGET
RectangleTarget.maxSideLength = MAX_SIZE_RECT_TARGET
RectangleTarget.angle = TARGET_ROTATION_ANGLE
RectangleTarget.rotationSpeed = 0.5 * math.pi

function RectangleTarget:new(width, height)
    local t = Target.new(self)
    t.width = math.random(self.minSideLength, self.maxSideLength)
    t.height = math.random(self.minSideLength, self.maxSideLength)
    t.angle = math.random() * math.pi
    t.rotationSpeed = self.rotationSpeed * (math.random() < 0.5 and -1 or 1)
    return t
end

function RectangleTarget:update(dt)
    self:updateCenterPosition(dt)
    self.angle = (self.angle + self.rotationSpeed * dt) % (2 * math.pi)
end

function RectangleTarget:largestSide()
    return math.max(self.width, self.height)
end

function RectangleTarget:place(x, y)
    self.x = x or math.random(self:largestSide() / 2, graphics.getWidth() - self:largestSide() / 2)
    self.y = y or math.random(self:largestSide() / 2, graphics.getHeight() - self:largestSide() / 2)
end

-- function RectangleTarget:reloadSpeed()
--     self.rotationSpeed = self.rotationSpeed * (math.random() < 0.5 and -1 or 1)
-- end

function RectangleTarget:draw()
    graphics.setColor(1, 0, 0)
    graphics.push()
    graphics.translate(self.x, self.y)
    graphics.rotate(self.angle)
    graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height) -- origin in the middle
    graphics.pop()
end

function RectangleTarget:drawDebugging()
    graphics.setColor(1, 0, 0)
    graphics.push()
    graphics.translate(self.x, self.y)
    graphics.rotate(self.angle)
    graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height) -- origin in the middle
    graphics.pop()
    graphics.print("angle: " .. self.angle / math.pi, 5, graphics.getHeight() - 50)
    graphics.setColor(0, 0, 0)
    graphics.line(self.x - 200, self:topLeftSideFunc(self.x - 200), self.x + 200, self:topLeftSideFunc(self.x + 200))
    graphics.setColor(0, 0, 1)
    graphics.line(self.x - 200, self:topRightSideFunc(self.x - 200), self.x + 200, self:topRightSideFunc(self.x + 200))
    graphics.setColor(1, 1, 0)
    graphics.line(self.x - 200, self:belowRightSideFunc(self.x - 200), self.x + 200,
        self:belowRightSideFunc(self.x + 200))
    graphics.setColor(0, 1, 0)
    graphics.line(self.x - 200, self:belowLeftSideFunc(self.x - 200), self.x + 200, self:belowLeftSideFunc(self.x + 200))
    graphics.setColor(0, 0, 0)
    local r = math.sqrt(self.height ^ 2 + self.width ^ 2) / 2
    local alpha = math.atan(self.height / self.width)

    local theta = self.angle + alpha
    graphics.print("h: " .. self.height, 5, graphics.getHeight() - 100)
    graphics.print("w: " .. self.width, 5, graphics.getHeight() - 150)
    graphics.print("r: " .. r, 5, graphics.getHeight() - 200)
    graphics.print("alpha: " .. alpha, 5, graphics.getHeight() - 250)
    graphics.print("theta: " .. theta, 5, graphics.getHeight() - 300)
    graphics.print("cos: " .. math.cos(theta), 5, graphics.getHeight() - 350)
    graphics.print("sin: " .. math.sin(theta), 5, graphics.getHeight() - 400)
    graphics.circle("line", self.x, self.y, r)
    graphics.setColor(1, 1, 0)
    graphics.circle("fill", self.x + r * math.cos(theta), self.y + r * math.sin(theta), 5)
    graphics.circle("fill", self.x + r * math.cos(math.pi - alpha + self.angle),
        self.y + r * math.sin(math.pi - alpha + self.angle), 5)
    graphics.circle("fill", self.x + r * math.cos(math.pi + alpha + self.angle),
        self.y + r * math.sin(math.pi + alpha + self.angle), 5)
    graphics.circle("fill", self.x + r * math.cos(-alpha + self.angle), self.y + r * math.sin(-alpha + self.angle), 5)
    graphics.setColor(1, 1, 1)
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
