local world = require("config")
local anim8 = require("libraries.anim8.anim8")
graphics = love.graphics
local sprites = {}
sprites.playerSheet = love.graphics.newImage("sprites/playerSheet.png")

local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())

local animations = {}
animations.idle = anim8.newAnimation(grid("1-15", 1), 0.05)
animations.jump = anim8.newAnimation(grid("1-7", 2), 0.05)
animations.run = anim8.newAnimation(grid("1-15", 3), 0.05)

local width, height = 40, 100
local player = world:newRectangleCollider(360, 100, width, height, { collision_class = COLLISION_CLASSES.Player })
player:setFixedRotation(true)
player.speed = 240
player.animation = animations.run
player.direction = 1
player.isGrounded = true
player.isMoving = false
local platform = world:newRectangleCollider(250, 400, 300, 100, { collision_class = COLLISION_CLASSES.Platform })
platform:setType("static")
local dangerZone = world:newRectangleCollider(0, 550, 800, 50, { collision_class = COLLISION_CLASSES.Danger })
dangerZone:setType("static")

function love.load()

end

function love.update(dt)
    world:update(dt)
    if not player.body then return end

    local px, py = player:getPosition()

    local colliders = world:queryRectangleArea(
        px - width / 2, py + height / 2,
        width, 2, { COLLISION_CLASSES.Platform }
    )
    player.isGrounded = #colliders > 0
    local leftDown = love.keyboard.isDown("left")
    local rightDown = love.keyboard.isDown("right")

    if not (leftDown or rightDown) or (leftDown and rightDown) then
        player.isMoving = false
    else
        player.isMoving = true
        if rightDown then
            player:setX(px + player.speed * dt)
            player.direction = 1
        else
            player:setX(px - player.speed * dt)
            player.direction = -1
        end
    end

    if not player.isGrounded then
        player.animation = animations.jump
    elseif player.isMoving then
        player.animation = animations.run
    else
        player.animation = animations.idle
    end

    if player:enter(COLLISION_CLASSES.Danger) then
        player:destroy()
    end

    player.animation:update(dt)
end

function love.draw()
    world:draw()
    if not player.body then return end
    local px, py = player:getPosition()
    player.animation:draw(sprites.playerSheet, px, py, nil, 0.25 * player.direction, 0.25, 130, 300)
end

function love.keypressed(key)
    if key == "up" and player.isGrounded then
        player:applyLinearImpulse(0, -1000)
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local colliders = world:queryCircleArea(x, y, 200)
        for i, c in ipairs(colliders) do
            c:destroy()
        end
    end
end
