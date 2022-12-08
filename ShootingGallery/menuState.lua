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

function MenuState:draw(highestScore)
    local welcomeMsg = "Click anywhere to begin!"
    if highestScore then welcomeMsg = "The highest score so far is " ..
        highestScore .. "\nThink you can beat it? ;)\n\n" .. welcomeMsg end
    graphics.printf(welcomeMsg, 0, graphics.getHeight() / 2, graphics.getWidth(), "center")
end

return MenuState
