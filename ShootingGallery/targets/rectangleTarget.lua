---@type Target Target
local Target = require("targets.target")

---@class RectangleTarget:Target
local RectangleTarget = Target:new()
RectangleTarget.minSideLength = TARGET_MIN_SIZE_RECT
RectangleTarget.maxSideLength = TARGET_MAX_SIZE_RECT
RectangleTarget.angle = TARGET_ROTATION_ANGLE
RectangleTarget.rotationSpeed = TARGET_ROTATION_SPEED

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

function RectangleTarget:reloadSpeed()
    Target.reloadSpeed(self)
    self.rotationSpeed = self.rotationSpeed * (math.random() < 0.5 and -1 or 1)
end

function RectangleTarget:draw()
    self:debuggingDraw()
end

function RectangleTarget:basicDraw()
    graphics.setColor(1, 0, 0)
    graphics.push()
    graphics.translate(self.x, self.y)
    graphics.rotate(self.angle)
    graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height) -- origin in the middle
    graphics.pop()
end

function RectangleTarget:debuggingDraw()
    self:basicDraw()
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
    local plusAlpha = self.angle + alpha
    local minusAlpha = self.angle - alpha
    graphics.circle("line", self.x, self.y, r)
    graphics.print("h: " .. self.height, 5, graphics.getHeight() - 100)
    graphics.print("w: " .. self.width, 5, graphics.getHeight() - 150)
    graphics.print("r: " .. roundValue(r, 5), 5, graphics.getHeight() - 200)
    graphics.print("alpha: " .. roundValue(alpha, 5), 5, graphics.getHeight() - 250)
    graphics.print("angle: " .. roundValue(self.angle, 5), 5, graphics.getHeight() - 300)
    graphics.print("cos: " .. roundValue(math.cos(plusAlpha), 5), 5, graphics.getHeight() - 350)
    graphics.print("sin: " .. roundValue(math.sin(plusAlpha), 5), 5, graphics.getHeight() - 400)
    graphics.setColor(1, 1, 0)
    for _, point in pairs(self:getCorners()) do
        graphics.circle("fill", point.x, point.y, 5)
    end
end

function RectangleTarget:getCorners()
    local r = math.sqrt(self.height ^ 2 + self.width ^ 2) / 2
    local alpha = math.atan(self.height / self.width)
    local plusAlpha = self.angle + alpha
    local minusAlpha = self.angle - alpha
    return {
        { x = self.x + r * math.cos(plusAlpha), y = self.y + r * math.sin(plusAlpha) },
        { x = self.x + r * math.cos(math.pi + minusAlpha), y = self.y + r * math.sin(math.pi + minusAlpha) },
        { x = self.x + r * math.cos(math.pi + plusAlpha), y = self.y + r * math.sin(math.pi + plusAlpha) },
        { x = self.x + r * math.cos(minusAlpha), y = self.y + r * math.sin(minusAlpha) }
    }
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
    if not (qGreater >= 2 and qSmaller >= 2) then
        return false
    end
    local qLeft, qRight = 0, 0
    for _, point in pairs(self:getCorners()) do
        if point.x == x and point.y == y then
            return true
        end
        if point.x >= x then
            qRight = qRight + 1
        else
            qLeft = qLeft + 1
        end
        if qLeft * qRight > 0 then
            return true
        end
    end
    return false
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
