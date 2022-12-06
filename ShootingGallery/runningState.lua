RunningState = {}

function RunningState:update(game, dt)
    game.timer = math.max(game.timer - dt, 0)
    if game.timer == 0 then
        game:reload()
    end
end

function RunningState:mousepressed(game, x, y, button)
    if button == MOUSE.middleClick then return end
    if isTargetHit(x, y) then
        game:placeTarget()
        local deltaScore = 1
        if button == MOUSE.rightClick then
            deltaScore = 2
            game.timer = game.timer - 1
        end
        game.score = game.score + deltaScore
    elseif game.score > 0 then
        game.score = game.score - 1
    end
end

function RunningState:draw()
    graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
end

function isTargetHit(x, y)
    return distanceBetween(x, y, target.x, target.y) < target.radius
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

return RunningState
