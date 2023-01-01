---@type CircleTarget CircleTarget
local CircleTarget = require("targets.circleTarget")
---@type RectangleTarget RectangleTarget
local RectangleTarget = require("targets.rectangleTarget")

---@class RunningState
local RunningState = {}

RunningState.score = INIT_SCORE
RunningState.timer = INIT_TIMER

RunningState.leftClickDeltaScore = 1
RunningState.leftClickDeltaTimer = 0

RunningState.rightClickDeltaScore = RunningState.leftClickDeltaScore * 2
RunningState.rightClickDeltaTimer = 1

---Constructor
---@return RunningState
function RunningState:new()
    self:placeNewTarget()
    local state = {}
    setmetatable(state, self)
    self.__index = self
    return state
end

---Places a new target on the game
function RunningState:placeNewTarget()
    self.target = self:createRandomTarget()
    self.attempts = {}
    self.target:place()
end

---Creates a new target
---@return RectangleTarget | CircleTarget
function RunningState:createRandomTarget()
    if math.random() < TARGET_PROB_RECTANGLE then
        return RectangleTarget:new()
    end
    return CircleTarget:new()
end

---Updates the state of the game after dt seconds.
---@param game Game
---@param dt number
function RunningState:update(game, dt)
    self.timer = math.max(self.timer - dt, 0)
    if self.timer == 0 then
        game:updateHighestScore(self.score)
        game:setFinishedState(self.score)
    end
    self.target:update(dt)
end

---Left click handler
---@param game Game
---@param x number mouse x-axis
---@param y number mouse y-axis
function RunningState:leftClick(game, x, y)
    self:handleShooting(x, y, self.leftClickDeltaScore, self.leftClickDeltaTimer)
end

---Right click handler
---@param game Game
---@param x number mouse x-axis
---@param y number mouse y-axis
function RunningState:rightClick(game, x, y)
    self:handleShooting(x, y, self.rightClickDeltaScore, self.rightClickDeltaTimer)
end

---Shooting handler
---@param x number mouse x-axis
---@param y number mouse y-axis
---@param deltaScore number
---@param deltaTimer number
function RunningState:handleShooting(x, y, deltaScore, deltaTimer)
    if self.target:isHit(x, y) then
        self:placeNewTarget()
        self.score = self.score + deltaScore
        self.timer = self.timer - deltaTimer
    else
        if self.score > 0 then
            self.score = self.score - 1
        end
        self.target:reloadSpeed()
        table.insert(self.attempts, { x = x, y = y })
    end
end

---Draws the current state of the running game.
---@param highestScore number
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
