dofile("config.lua")

local MenuState = require("menuState")
local RunningState = require("runningState")
local FinishedState = require("finishedState")

local Game = {}

function Game:restart()
    self.state = MenuState
end

function Game:setRunningState()
    self.state = RunningState:new()
end

function Game:setMenuState()
    self.state = MenuState
end

function Game:setFinishedState(score)
    self.highestScore = self.highestScore or score
    self.highestScore = (score > self.highestScore) and score or self.highestScore
    self.state = FinishedState:new(score)
end

function Game:update(dt)
    self.state:update(self, dt)
end

function Game:leftClick(x, y)
    self.state:leftClick(self, x, y)
end

function Game:rightClick(x, y)
    self.state:rightClick(self, x, y)
end

function Game:draw()
    self:drawBackground()
    self.state:draw(self.highestScore)
    self:drawCrosshair()
end

function Game:drawBackground()
    graphics.draw(sprites.sky, 0, 0)
end

function Game:drawCrosshair()
    graphics.draw(sprites.crosshair, love.mouse.getX() - sprites.crosshair:getWidth() / 2,
        love.mouse.getY() - sprites.crosshair:getHeight() / 2
    )
end

return Game
