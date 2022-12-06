function updateScore(x, y, button)
    if isTargetHit(x, y) then
        placeTarget()
        local deltaScore = 1
        if button == MOUSE.rightClick then
            deltaScore = 2
            timer = timer - 1
        end
        score = score + deltaScore
    elseif score > 0 then
        score = score - 1
    end
end

function reloadGame()
    loadInitValues()
    launchGame()
end

function loadInitValues()
    gameState = GAME_STATE.menu
    score = INIT_SCORE
    timer = INIT_TIMER
end

function launchGame()
    gameState = GAME_STATE.running
end

function drawCrosshair()
    graphics.draw(sprites.crosshair, love.mouse.getX() - sprites.crosshair:getWidth() / 2,
        love.mouse.getY() - sprites.crosshair:getHeight() / 2
    )
end

function drawGameStateDependentContent()
    if gameState == GAME_STATE.menu then
        graphics.printf("Click anywhere to begin!", 0, graphics.getHeight() / 2, graphics.getWidth(), "center")
    elseif gameState == GAME_STATE.running then
        graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end
end

function drawBackground()
    graphics.draw(sprites.sky, 0, 0)
    graphics.setColor(1, 1, 1)
    graphics.print("Score: " .. score, 25, 5)
    graphics.setColor(1, 1, 1)
    graphics.print("Time left: " .. timer - timer % 0.001, graphics.getWidth() - 300, 5)
end

function isTargetHit(x, y)
    return distanceBetween(x, y, target.x, target.y) < target.radius
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function placeTarget()
    target.x = math.random(target.radius, graphics.getWidth() - target.radius)
    target.y = math.random(target.radius, graphics.getHeight() - target.radius)
end
