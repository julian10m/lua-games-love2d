RunningState = {}
RunningState.leftClickDeltaScore = 1
RunningState.leftClickDeltaTimer = 0
RunningState.rightClickDeltaScore = RunningState.leftClickDeltaScore * 2
RunningState.rightClickDeltaTimer = 1

function RunningState:update(game, dt)
    game.timer = math.max(game.timer - dt, 0)
    if game.timer == 0 then
        game:restart()
    end
end

function RunningState:leftClick(game, x, y)
    RunningState:handleShooting(game, x, y, RunningState.leftClickDeltaScore, RunningState.leftClickDeltaTimer)
end

function RunningState:rightClick(game, x, y)
    RunningState:handleShooting(game, x, y, RunningState.rightClickDeltaScore, RunningState.rightClickDeltaTimer)
end

function RunningState:draw()
    graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
end

function RunningState:handleShooting(game, x, y, deltaScore, deltaTimer)
    if isTargetHit(x, y) then
        game:placeTarget()
        game.score = game.score + deltaScore
        game.timer = game.timer - deltaTimer
    elseif game.score > 0 then
        game.score = game.score - 1
    end
end

function isTargetHit(x, y)
    return distanceBetween(x, y, target.x, target.y) < target.radius
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

return RunningState
