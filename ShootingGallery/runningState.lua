local RunningState = {}

RunningState.score = INIT_SCORE
RunningState.timer = INIT_TIMER

RunningState.leftClickDeltaScore = 1
RunningState.leftClickDeltaTimer = 0

RunningState.rightClickDeltaScore = RunningState.leftClickDeltaScore * 2
RunningState.rightClickDeltaTimer = 1

function RunningState:new()
    target:place()
    local state = {}
    setmetatable(state, self)
    self.__index = self
    return state
end

function RunningState:update(game, dt)
    self.timer = math.max(self.timer - dt, 0)
    if self.timer == 0 then
        game:setFinishedState(self.score)
    end
end

function RunningState:leftClick(game, x, y)
    self:handleShooting(x, y, self.leftClickDeltaScore, self.leftClickDeltaTimer)
end

function RunningState:rightClick(game, x, y)
    self:handleShooting(x, y, self.rightClickDeltaScore, self.rightClickDeltaTimer)
end

function RunningState:handleShooting(x, y, deltaScore, deltaTimer)
    if target:isHit(x, y) then
        target:place()
        self.score = self.score + deltaScore
        self.timer = self.timer - deltaTimer
    elseif self.score > 0 then
        self.score = self.score - 1
    end
end

function RunningState:draw(highestScore)
    graphics.setColor(1, 1, 1)
    local scoreMsg = "Score: " .. self.score
    if highestScore then scoreMsg = scoreMsg .. "\nHighest score: " .. highestScore end
    graphics.print(scoreMsg, 25, 5)
    graphics.print("Time left: " .. self.timer - self.timer % 0.001, graphics.getWidth() - 300, 5)
    target:draw()
end

return RunningState
