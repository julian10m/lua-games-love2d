local CircleTarget = require("targets.circleTarget")
local RectangleTarget = require("targets.rectangleTarget")

local RunningState = {}

RunningState.score = INIT_SCORE
RunningState.timer = INIT_TIMER

RunningState.leftClickDeltaScore = 1
RunningState.leftClickDeltaTimer = 0

RunningState.rightClickDeltaScore = RunningState.leftClickDeltaScore * 2
RunningState.rightClickDeltaTimer = 1

function RunningState:new()
    self:placeNewTarget()
    local state = {}
    setmetatable(state, self)
    self.__index = self
    return state
end

function RunningState:placeNewTarget()
    self.target = self:createRandomTarget()
    self.attempts = {}
    self.target:place()
end

function RunningState:createRandomTarget()
    if math.random() < 0.5 then
        return RectangleTarget:new()
    end
    return CircleTarget:new()
end

function RunningState:update(game, dt)
    self.timer = math.max(self.timer - dt, 0)
    if self.timer == 0 then
        game:setFinishedState(self.score)
    end
    self.target:update(dt)
end

function RunningState:leftClick(game, x, y)
    self:handleShooting(x, y, self.leftClickDeltaScore, self.leftClickDeltaTimer)
end

function RunningState:rightClick(game, x, y)
    self:handleShooting(x, y, self.rightClickDeltaScore, self.rightClickDeltaTimer)
end

function RunningState:handleShooting(x, y, deltaScore, deltaTimer)
    if self.target:isHit(x, y) then
        self:placeNewTarget()
        self.score = self.score + deltaScore
        self.timer = self.timer - deltaTimer
    else
        table.insert(self.attempts, { x = x, y = y })
        if self.score > 0 then
            self.score = self.score - 1
        end
    end
end

function RunningState:draw(highestScore)
    graphics.setColor(1, 1, 1)
    local scoreMsg = "Score: " .. self.score
    if highestScore then scoreMsg = scoreMsg .. "\nHighest score: " .. highestScore end
    graphics.print(scoreMsg, 25, 5)
    graphics.print("Time left: " .. self.timer - self.timer % 0.001, graphics.getWidth() - 300, 5)
    self.target:draw()
    graphics.setColor(0, 0, 0)
    for _, point in pairs(self.attempts) do
        graphics.circle("line", point.x, point.y, 2)
    end
    graphics.setColor(1, 1, 1)
end

return RunningState
