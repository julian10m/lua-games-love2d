require("config")
---@type Game game
local game = require("game")

---Load game
function love.load()
    game:setMenuState()
end

---Update game
---@param dt number
function love.update(dt)
    game:update(dt)
end

---Draw game.
function love.draw()
    game:draw()
end

---Callback for a mouse click
---@param x number mouse x-axis position
---@param y number mouse y-axis position
---@param button number
function love.mousepressed(x, y, button)
    if button == mouse.leftClick then
        game:leftClick(x, y)
    end
end
