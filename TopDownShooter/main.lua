local graphics = love.graphics
local movements = {
    d = { dir = "x", delta = 1 },
    w = { dir = "y", delta = -1 },
    a = { dir = "x", delta = -1 },
    s = { dir = "y", delta = 1 }
}
MIN_DIST = 30

---Returns the Euclidean distance between points (x1, y1) and (x2, y2)
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function love.load()
    sprites = {}
    sprites.background = graphics.newImage('sprites/background.png')
    sprites.bullet = graphics.newImage('sprites/bullet.png')
    sprites.player = graphics.newImage('sprites/player.png')
    sprites.zombie = graphics.newImage('sprites/zombie.png')
    player = {}
    player.x = graphics.getWidth() / 2
    player.y = graphics.getHeight() / 2
    player.angle = 0
    player.speed = 120
    graphics.setFont(graphics.newFont(30))
    zombies = {}
    bullets = {}
    gameState = 1
    maxTime = 1
    timer = maxTime
    score = 0
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
        local angle = playerZombieAngle(z)
        z.x = z.x + z.speed * math.cos(angle) * dt
        z.y = z.y + z.speed * math.sin(angle) * dt
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
            spawnZombie()
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
        graphics.draw(
            sprites.player,
            player.x,
            player.y,
            playerMouseAngle(),
            nil,
            nil,
            sprites.player:getWidth() / 2,
            sprites.player:getHeight() / 2
        )
        for _, zombie in ipairs(zombies) do
            graphics.draw(
                sprites.zombie,
                zombie.x,
                zombie.y,
                playerZombieAngle(zombie),
                nil,
                nil,
                sprites.zombie:getWidth() / 2,
                sprites.zombie:getHeight() / 2
            )
        end
        for _, bullet in ipairs(bullets) do
            graphics.draw(
                sprites.bullet,
                bullet.x,
                bullet.y,
                bullet.angle,
                0.5,
                nil,
                sprites.bullet:getWidth() / 2,
                sprites.bullet:getHeight() / 2
            )
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
        spawnZombie()
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
            spawnBullet()
        end
    end
end

function playerMouseAngle()
    return playerAngle(love.mouse.getX(), love.mouse.getY())
end

function playerZombieAngle(zombie)
    return math.pi + playerAngle(zombie.x, zombie.y)
end

function playerAngle(x, y)
    return math.atan2(y - player.y, x - player.x)
end

function spawnZombie()
    local zombie = {}
    local side = math.random(1, 4)
    if side == 1 then
        zombie.x = -30
        zombie.y = math.random() * graphics.getHeight()
    elseif side == 2 then
        zombie.x = graphics.getWidth() + 30
        zombie.y = math.random() * graphics.getHeight()
    elseif side == 3 then
        zombie.x = math.random() * graphics.getWidth()
        zombie.y = -30
    else
        zombie.x = math.random() * graphics.getWidth()
        zombie.y = graphics.getHeight() + 30
    end
    zombie.speed = 130
    table.insert(zombies, zombie)
end

function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 130
    bullet.angle = playerMouseAngle()
    table.insert(bullets, bullet)
end
