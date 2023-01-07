require("config")
local Bullet = require("characters.bullet")
local Player = require("characters.player")
local Zombie = require("characters.zombie")

function love.load()
    player = Player:new()
    zombies = {}
    bullets = {}
    timer = maxTime
end

function love.update(dt)
    if gameState == 1 then
        return
    end
    for key, key_action in pairs(movements) do
        if love.keyboard.isDown(key) then
            player[key_action.dir] = player[key_action.dir] + key_action.delta * player.speed * dt
        end
    end
    player.angle = player.angle + 0.01 * dt
    local isTouched = false
    for i, z in ipairs(zombies) do
        local angle = playerZombieAngle(z.x, z.y)
        z.x = z.x + z.speed * math.cos(angle) * dt
        z.y = z.y + z.speed * math.sin(angle) * dt
        z.angle = playerZombieAngle(z.x, z.y)
        if distanceBetween(z.x, z.y, player.x, player.y) < MIN_DIST then
            isTouched = true
            break
        end
    end
    if isTouched then
        zombies = {}
        bullets = {}
        gameState = 1
        player.x = graphics.getWidth() / 2
        player.y = graphics.getHeight() / 2
    end
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        b.x = b.x + b.speed * math.cos(b.angle) * dt
        b.y = b.y + b.speed * math.sin(b.angle) * dt

        if b.x < 0 or b.y < 0 or b.x > graphics.getWidth() or b.y > graphics.getHeight() then
            table.remove(bullets, i)
        else
            for j = #zombies, 1, -1 do
                local z = zombies[j]
                if distanceBetween(z.x, z.y, b.x, b.y) < MIN_DIST then
                    table.remove(zombies, j)
                    table.remove(bullets, i)
                    score = score + 1
                    break
                end
            end
        end
    end
    if gameState == 2 then
        timer = timer - dt
        if timer <= 0 then
            table.insert(zombies, Zombie:new())
            maxTime = 0.95 * maxTime
            timer = maxTime
        end
    end
end

function love.draw()
    graphics.draw(sprites.background, 0, 0)

    if gameState == 1 then
        graphics.printf(
            "Click anywhere to begin!",
            0,
            50,
            graphics.getWidth(),
            "center"
        )
    else
        player:draw()
        for _, zombie in ipairs(zombies) do
            zombie:draw()
        end
        for _, bullet in ipairs(bullets) do
            bullet:draw()
        end
    end
    graphics.printf(
        "Score: " .. score,
        0,
        graphics.getHeight() - 100,
        graphics.getWidth(),
        "center"
    )
end

function love.keypressed(k)
    if k == "space" then
        table.insert(zombies, Zombie:new())
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        --if button == mouse.leftClick then
        if gameState == 1 then
            gameState = 2
            maxTime = 2
            timer = 2
            score = 0
        else
            table.insert(bullets, Bullet:new(player.x, player.y, playerMouseAngle()))
        end
    end
end
