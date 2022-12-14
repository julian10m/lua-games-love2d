local FinishedState = {}

function FinishedState:new(score)
    local state = {}
    state.score = score
    setmetatable(state, self)
    self.__index = self
    return state
end

function FinishedState:update(game, dt)
    return
end

function FinishedState:leftClick(game, x, y)
    game:setMenuState()
end

function FinishedState:rightClick(game, x, y, button)
    return
end

function FinishedState:draw()
    graphics.printf("Your score: " .. self.score .. "\n\nClick to return to the menu!", 0, graphics.getHeight() / 2,
        graphics.getWidth(), "center")
end

return FinishedState
