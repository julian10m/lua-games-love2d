---@type MenuState MenuState
local MenuState = require("states.menuState")
---@type RunningState RunningState
local RunningState = require("states.runningState")
---@type FinishedState FinishedState
local FinishedState = require("states.finishedState")

---@class Game
---@field private state MenuState|RunningState|FinishedState
---@field private highestScore number
local Game = {}

---Sets the game into a new running state.
function Game:setRunningState()
    self.state = RunningState:new()
end

---Sets the game into the menu state.
function Game:setMenuState()
    self.state = MenuState
end

---Sets the game into the finished state.
---@param score number
function Game:setFinishedState(score)
    self.state = FinishedState:new(score)
end

---Updates the highest score
---@param score number
function Game:updateHighestScore(score)
    self.highestScore = self.highestScore or score
    self.highestScore = (score > self.highestScore) and score or self.highestScore
end

---Updates the game state.
---@param dt number
function Game:update(dt)
    self.state:update(self, dt)
end

---Left click handler.
---@param x number
---@param y number
function Game:leftClick(x, y)
    self.state:leftClick(self, x, y)
end

---Right click handler.
---@param x number
---@param y number
function Game:rightClick(x, y)
    self.state:rightClick(self, x, y)
end

---Draws the current game.
function Game:draw()
    self:drawBackground()
    self.state:draw(self.highestScore)
    self:drawCrosshair()
end

---Draws the background.
function Game:drawBackground()
    graphics.draw(sprites.sky, 0, 0)
end

---Draws the crosshair.
function Game:drawCrosshair()
    graphics.draw(sprites.crosshair, love.mouse.getX() - sprites.crosshair:getWidth() / 2,
        love.mouse.getY() - sprites.crosshair:getHeight() / 2
    )
end

return Game
