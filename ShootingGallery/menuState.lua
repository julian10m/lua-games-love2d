MenuState = {}

function MenuState:update(game, dt)
    return
end

function MenuState:mousepressed(game, x, y, button)
    if button == MOUSE.leftClick then
        game:setRunningState()
    end
end

function MenuState:draw()
    graphics.printf("Click anywhere to begin!", 0, graphics.getHeight() / 2, graphics.getWidth(), "center")
end

return MenuState
