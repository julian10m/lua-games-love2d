RunningState = {}
RunningState.leftClickScore = 1
RunningState.rightClickScore = RunningState.leftClickScore * 2

function RunningState:update(game, dt)
    game.timer = math.max(game.timer - dt, 0)
    if game.timer == 0 then
        game:restart()
    end
end

function RunningState:leftClick(game, x, y)
    if isTargetHit(x, y) then
        game:placeTarget()
        game.score = game.score + RunningState.leftClickScore
    elseif game.score > 0 then
        game.score = game.score - 1
    end
end

function RunningState:rightClick(game, x, y)
    if isTargetHit(x, y) then
        game:placeTarget()
        game.score = game.score + RunningState.rightClickScore
        game.timer = game.timer - 1
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
