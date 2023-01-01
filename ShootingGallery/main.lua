---@type Game game
local game = dofile("game.lua")

function love.load()
    game:setMenuState()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == mouse.leftClick then
        game:leftClick(x, y)
    elseif button == mouse.rightClick then
        game:rightClick(x, y)
    end
end
