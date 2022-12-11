local game = dofile("game.lua")

function love.load()
    game:restart()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    mouseClickActions[button](game, x, y)
end
