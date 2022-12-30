---@type Target Target
local Target = require("targets.target")

---@class RectangleTarget:Target
local RectangleTarget = Target:new()
RectangleTarget.minSideLength = TARGET_MIN_SIZE_RECT
RectangleTarget.maxSideLength = TARGET_MAX_SIZE_RECT
RectangleTarget.angle = TARGET_ROTATION_ANGLE
RectangleTarget.rotationSpeed = TARGET_ROTATION_SPEED

---Constructor returning a new circle target object.
---@param width? number
---@param height? number
---@return RectangleTarget
function RectangleTarget:new(width, height)
    local t = Target.new(self)
    t.width = math.random(self.minSideLength, self.maxSideLength)
    t.height = math.random(self.minSideLength, self.maxSideLength)
    t.angle = math.random() * math.pi
    t.rotationSpeed = self.rotationSpeed * (math.random() < 0.5 and -1 or 1)
    return t
end

---Updates the state of the target
---@param dt number
function RectangleTarget:update(dt)
    self:updateCenterPosition(dt)
    self.angle = (self.angle + self.rotationSpeed * dt) % (2 * math.pi)
end

---Returns the largest side among the witth and the height of the rectangle
---@return number
function RectangleTarget:largestSide()
    return math.max(self.width, self.height)
end

---Sets the position of the target
---@param x number
---@param y number
function RectangleTarget:place(x, y)
    self.x = x or math.random(self:largestSide() / 2, graphics.getWidth() - self:largestSide() / 2)
    self.y = y or math.random(self:largestSide() / 2, graphics.getHeight() - self:largestSide() / 2)
end

---Sets new values for the rotation, x and y speeds of the target.
function RectangleTarget:reloadSpeed()
    Target.reloadSpeed(self)
    self.rotationSpeed = self.rotationSpeed * (math.random() < 0.5 and -1 or 1)
end

---Draws the target on the game
function RectangleTarget:draw()
    self:debuggingDraw()
end

---Usual display of the target
function RectangleTarget:basicDraw()
    graphics.setColor(1, 0, 0)
    graphics.push()
    graphics.translate(self.x, self.y)
    graphics.rotate(self.angle)
    graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height) -- origin in the middle
    graphics.pop()
end

---Displays the target and plots additional things to help debug.
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

---Returns the position of the 4 corners of the rectangle
---@return table
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

---Tells whether a point (x, y) touches the target
---@param x number
---@param y number
---@return boolean
function RectangleTarget:isHit(x, y)
    if self.angle == 0 then
        return self.x - self.width / 2 <= x and
            x <= self.x + self.width / 2 and
            self.y - self.height / 2 <= y and
            y <= self.y + self.height / 2
    end
    return self:hasTwoLinesOnTopAndTwoBelow(x, y) and self:isPointBetweenCornersOnAxisX(x, y)
end

---Tells whether a point (x, y) has 2 lines of the rectangle on top and 2 below
---@param x number
---@param y number
---@return boolean
function RectangleTarget:hasTwoLinesOnTopAndTwoBelow(x, y)
    local qGreater, qSmaller = 0, 0
    for _, f in pairs({ self.topLeftSideFunc, self.topRightSideFunc, self.belowRightSideFunc, self.belowLeftSideFunc }) do
        qGreater = qGreater + (self:isGreater(f, x, y) and 1 or 0)
        qSmaller = qSmaller + (self:isSmaller(f, x, y) and 1 or 0)
    end
    return qGreater >= 2 and qSmaller >= 2
end

---Tells whether a point (x, y) has all cornes on one side or not.
---@param x number
---@param y number
---@return boolean
function RectangleTarget:isPointBetweenCornersOnAxisX(x, y)
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

---Tells whether a function f evaluated at x is greater or equal than y
---@param f function
---@param x number
---@param y number
---@return boolean
function RectangleTarget:isGreater(f, x, y)
    return f(self, x) >= y
end

---Tells whether a function f evaluated at x is smaller or equal than y
---@param f function
---@param x number
---@param y number
---@return boolean
function RectangleTarget:isSmaller(f, x, y)
    return f(self, x) <= y
end

---Returns the x-distance from the target to an x-value
---@param x number
---@return number
function RectangleTarget:deltaX(x)
    return x - self.x
end

---Returns the slope given the inclination angle of the rectangle
---@return number
function RectangleTarget:slope()
    return math.tan(self.angle)
end

---Returns the orthogonal inclination of the rectangle
---@return number
function RectangleTarget:orthogonalSlope()
    return -1 / self:slope()
end

---Evaluates the side 1 function on x.
---@param x number
---@return number
function RectangleTarget:topLeftSideFunc(x)
    return self:slope() * self:deltaX(x) +
        (self.height / 2) * math.cos(self.angle) * (1 + self:slope() ^ 2) + self.y
end

---Evaluates the side 2 function on x.
---@param x number
---@return number
function RectangleTarget:belowRightSideFunc(x)
    return self:topLeftSideFunc(x) - (self.height / math.cos(self.angle))
end

---Evaluates the side 3 function on x.
---@param x number
---@return number
function RectangleTarget:belowLeftSideFunc(x)
    return self:orthogonalSlope() * self:deltaX(x) -
        (self.width / 2) * math.sin(self.angle) * (1 + self:orthogonalSlope() ^ 2) + self.y
end

---Evaluates the side 4 function on x.
---@param x number
---@return number
function RectangleTarget:topRightSideFunc(x)
    return self:belowLeftSideFunc(x) + (self.width / math.sin(self.angle))
end

return RectangleTarget
