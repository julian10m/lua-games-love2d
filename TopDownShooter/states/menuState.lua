---@class MenuState
local MenuState = {}

---updates the state
---@param game Game
---@param dt number
function MenuState:update(game, dt)
    return
end

---Left click handler
---@param game Game
---@param x number mouse x-axis
---@param y number mouse y-axis
function MenuState:leftClick(game, x, y)
    game:setRunningState()
end

---Draws the menu.
---@param highestScore? number
function MenuState:draw(highestScore)
    graphics.printf("Click anywhere to begin!", 0, 50, graphics.getWidth(), "center")
    if highestScore then
        graphics.printf("\nHighest score: " .. highestScore, 0, graphics.getHeight() - 100, graphics.getWidth(), "center")
    end
end

return MenuState
