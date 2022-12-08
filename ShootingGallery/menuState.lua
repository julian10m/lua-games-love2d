MenuState = {}

function MenuState:update(game, dt)
    return
end

function MenuState:leftClick(game, x, y)
    game:setRunningState()
end

function MenuState:rightClick(game, x, y, button)
    return
end

function MenuState:draw()
    graphics.printf("Click anywhere to begin!", 0, graphics.getHeight() / 2, graphics.getWidth(), "center")
end

return MenuState
