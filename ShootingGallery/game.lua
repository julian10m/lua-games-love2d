MenuState = require("menuState")
RunningState = require("runningState")

Game = {
    score = INIT_SCORE,
    timer = INIT_TIMER,
    font = graphics.newFont(30),
    state = MenuState
}

function Game:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Game:placeTarget()
    target.x = math.random(target.radius, graphics.getWidth() - target.radius)
    target.y = math.random(target.radius, graphics.getHeight() - target.radius)
end

function Game:setRunningState()
    self.state = RunningState
end

function Game:setMenuState()
    self.state = MenuState
end

function Game:reload()
    self.score = INIT_SCORE
    self.timer = INIT_TIMER
    self.state = MenuState
end

function Game:update(dt)
    self.state:update(self, dt)
end

function Game:mousepressed(x, y, button)
    self.state:mousepressed(self, x, y, button)
end

function Game:draw()
    graphics.setFont(game.font)
    self:drawBackground()
    self.state:draw()
    self:drawCrosshair()
end

function Game:drawBackground()
    graphics.draw(sprites.sky, 0, 0)
    graphics.setColor(1, 1, 1)
    graphics.print("Score: " .. self.score, 25, 5)
    graphics.setColor(1, 1, 1)
    graphics.print("Time left: " .. self.timer - self.timer % 0.001, graphics.getWidth() - 300, 5)
end

function Game:drawCrosshair()
    graphics.draw(sprites.crosshair, love.mouse.getX() - sprites.crosshair:getWidth() / 2,
        love.mouse.getY() - sprites.crosshair:getHeight() / 2
    )
end

return Game
