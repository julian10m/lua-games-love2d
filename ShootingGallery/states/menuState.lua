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

---Right click handler
---@param game Game
---@param x number mouse x-axis
---@param y number mouse y-axis
function MenuState:rightClick(game, x, y)
    return
end

---Draws the menu.
---@param highestScore? number
function MenuState:draw(highestScore)
    local welcomeMsg = "Click anywhere to begin!"
    if highestScore then welcomeMsg = "The highest score so far is " ..
            highestScore .. "\nThink you can beat it? ;)\n\n" .. welcomeMsg
    end
    graphics.printf(welcomeMsg, 0, graphics.getHeight() / 2, graphics.getWidth(), "center")
end

return MenuState
