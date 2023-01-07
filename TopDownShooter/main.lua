require("config")
local game = require("game")

function love.load()
    game:setMenuState()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.mousepressed(x, y, button)
    if button == mouse.leftClick then
        game:leftClick(x, y)
    end
end
