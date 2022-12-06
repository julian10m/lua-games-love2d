function love.load()
    gameState = 1
    target = {}
    target.x = 300
    target.y = 100
    target.radius = 50
    score = 0
    timer = 5
    gameFont = love.graphics.newFont(30)
    sprites = {}
    sprites.sky = love.graphics.newImage("sprites/sky.png")
    sprites.crosshair = love.graphics.newImage("sprites/crosshair.png")
    sprites.target = love.graphics.newImage("sprites/target.png")
    love.mouse.setVisible(false)
end

function love.update(dt)
    if gameState == 2 then
        if timer > 0 then
            timer = timer - dt
        else
            gameState = 1
            if timer < 0 then
                timer = 0
            end
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
    if gameState == 1 then
        love.graphics.printf(
            "Click anywhere to begin!",
            0,
            love.graphics.getHeight() / 2,
            love.graphics.getWidth(),
            "center")
    elseif gameState == 2 then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end
    love.graphics.draw(
        sprites.crosshair,
        love.mouse.getX() - sprites.crosshair:getWidth() / 2,
        love.mouse.getY() - sprites.crosshair:getHeight() / 2
    )
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if gameState == 1 then
            gameState = 2
            timer = 5
            score = 0
        else
            if distanceBetween(x, y, target.x, target.y) < target.radius then
                score = score + 1
                target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
                target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
            else
                if score > 0 then
                    score = score - 1
                end
            end
        end
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
