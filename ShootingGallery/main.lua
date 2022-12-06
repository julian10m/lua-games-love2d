dofile("config.lua")

function love.load()
    gameFont = love.graphics.newFont(30)
    love.mouse.setVisible(false)
    sprites = loadSprites()
    gameState = GAME_STATE.menu
    score = INIT_SCORE
    timer = INIT_TIMER
    target = {}
    target.radius = 50
    placeTarget()
end

function love.update(dt)
    if gameState == GAME_STATE.running then
        timer = math.max(timer - dt, 0)
        if timer == 0 then
            gameState = GAME_STATE.menu
        end
    end
end

function love.draw()
    love.graphics.draw(sprites.sky, 0, 0)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gameFont)
    love.graphics.print("Score: " .. score, 25, 5)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Time left: " .. timer - timer % 0.001, love.graphics.getWidth() - 300, 5)
    if gameState == GAME_STATE.menu then
        love.graphics.printf(
            "Click anywhere to begin!",
            0,
            love.graphics.getHeight() / 2,
            love.graphics.getWidth(),
            "center")
    elseif gameState == GAME_STATE.running then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end
    love.graphics.draw(
        sprites.crosshair,
        love.mouse.getX() - sprites.crosshair:getWidth() / 2,
        love.mouse.getY() - sprites.crosshair:getHeight() / 2
    )
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == MOUSE.middleClick then return end
    if gameState == GAME_STATE.menu then
        if button == MOUSE.leftClick then
            gameState = GAME_STATE.running
            timer = INIT_TIMER
            score = INIT_SCORE
        end
    else
        if distanceBetween(x, y, target.x, target.y) < target.radius then
            placeTarget()
            local deltaScore = 1
            if button == MOUSE.rightClick then
                deltaScore = 2
                timer = timer - 1
            end
            score = score + deltaScore
        else
            if score > 0 then
                score = score - 1
            end
        end
    end
end

function placeTarget()
    target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
    target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
