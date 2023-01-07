---@class FinishedState
local FinishedState = {}

---Constructor
---@param score number
---@return FinishedState
function FinishedState:new(score)
    local state = {}
    state.score = score
    setmetatable(state, self)
    self.__index = self
    return state
end

---Updates the state
---@param game Game
---@param dt number
function FinishedState:update(game, dt)
    return
end

---Left click handler
---@param game Game
---@param x number mouse x-axis
---@param y number mouse y-axis
function FinishedState:leftClick(game, x, y)
    game:setMenuState()
end

---Right click handler
---@param game Game
---@param x number mouse x-axis
---@param y number mouse y-axis
function FinishedState:rightClick(game, x, y)
    return
end

---Draws the finished state
function FinishedState:draw()
    graphics.printf("Your score: " .. self.score .. "\n\nClick to return to the menu!", 0, graphics.getHeight() / 2,
        graphics.getWidth(), "center")
end

return FinishedState
