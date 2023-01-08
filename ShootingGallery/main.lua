require("config")
---@type Game game
local game = require("game")

---Loads the game
function love.load()
    game:setMenuState()
end

---Updates the dame
---@param dt number
function love.update(dt)
    game:update(dt)
end

---Draws the game.
function love.draw()
    game:draw()
end

---Callback for mouse clicks
---@param x number mouse x-axis position
---@param y number mouse y-axis position
---@param button number
function love.mousepressed(x, y, button)
    if button == mouse.leftClick then
        game:leftClick(x, y)
    elseif button == mouse.rightClick then
        game:rightClick(x, y)
    end
end
