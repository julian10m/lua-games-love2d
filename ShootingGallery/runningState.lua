RunningState = {}

RunningState.score = INIT_SCORE
RunningState.timer = INIT_TIMER

RunningState.leftClickDeltaScore = 1
RunningState.leftClickDeltaTimer = 0

RunningState.rightClickDeltaScore = RunningState.leftClickDeltaScore * 2
RunningState.rightClickDeltaTimer = 1

function RunningState:new()
    self:placeTarget()
    local state = {}
    setmetatable(state, self)
    self.__index = self
    return state
end

function RunningState:placeTarget()
    target.x = math.random(target.radius, graphics.getWidth() - target.radius)
    target.y = math.random(target.radius, graphics.getHeight() - target.radius)
end

function RunningState:update(game, dt)
    self.timer = math.max(self.timer - dt, 0)
    if self.timer == 0 then
        game:restart()
    end
end

function RunningState:leftClick(game, x, y)
    self:handleShooting(game, x, y, self.leftClickDeltaScore, self.leftClickDeltaTimer)
end

function RunningState:rightClick(game, x, y)
    self:handleShooting(game, x, y, self.rightClickDeltaScore, self.rightClickDeltaTimer)
end

function RunningState:handleShooting(game, x, y, deltaScore, deltaTimer)
    if isTargetHit(x, y) then
        self:placeTarget()
        self.score = self.score + deltaScore
        self.timer = self.timer - deltaTimer
    elseif self.score > 0 then
        self.score = self.score - 1
    end
end

function isTargetHit(x, y)
    return distanceBetween(x, y, target.x, target.y) < target.radius
end

function RunningState:draw()
    graphics.setColor(1, 1, 1)
    graphics.print("Score: " .. self.score, 25, 5)
    graphics.print("Time left: " .. self.timer - self.timer % 0.001, graphics.getWidth() - 300, 5)
    graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
end

return RunningState
