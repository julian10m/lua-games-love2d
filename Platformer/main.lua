world = require("config")
anim8 = require("libraries.anim8.anim8")
local cameraFile = require("libraries.hump.camera")
local sti = require("libraries.Simple-Tiled-Implementation.sti")
require("libraries.show")
local cam = cameraFile()
graphics = love.graphics

local sprites = {}
sprites.playerSheet = love.graphics.newImage("sprites.playerSheet.png")
sprites.enemySheet = love.graphics.newImage("sprites.enemySheet.png")
sprites.background = love.graphics.newImage("sprtes.background.png")
local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())
local enemyGrid = anim8.newGrid(100, 79, sprites.enemySheet:getWidth(), sprites.enemySheet:getHeight())
local animations = {}
local platforms = {}

animations.idle = anim8.newAnimation(grid("1-15", 1), 0.05)
animations.jump = anim8.newAnimation(grid("1-7", 2), 0.05)
animations.run = anim8.newAnimation(grid("1-15", 3), 0.05)
animations.enemy = anim8.newAnimation(enemyGrid("1-2", 1), 0.03)

local width, height = 40, 100
local playerStartX, playerStartY = 360, 100
local player = world:newRectangleCollider(playerStartX, playerStartY, width, height,
    { collision_class = COLLISION_CLASSES.Player })
player:setFixedRotation(true)
player.speed = 240
player.animation = animations.run
player.direction = 1
player.isGrounded = true
player.isMoving = false
local enemies = require("enemy")
local sounds = {}
sounds.jump = love.audio.newSource("audio.jump.wav", "static")
sounds.music = love.audio.newSource("audio.music.mp3", "stream")
sounds.music:setLooping(true)
sounds.music:setVolume(0.5)
sounds.music:play()

local dangerZone = world:newRectangleCollider(-500, 800, 5000, 50, { collision_class = COLLISION_CLASSES.Danger })
dangerZone.setType("static")

function love.load()
    love.window.setMode(1000, 768)
    --https://www.mapeditor.org/
    --https://github.com/karai17/Simple-Tiled-Implementation
    --https://github.com/vrld/hump
    --https://opengameart.org/
    saveData = {}
    saveData.currentLevel = "level1"
    if love.filesystem.getInfo("data.lua") then
        local data = love.filesystem.load("data.lua")
        data()
    end
    loadMap(saveData.currentLevel)
    flagX, flagY = 0, 0
end

function love.update(dt)
    world:update(dt)
    gameMap:update(dt)
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
        player:setPosition(playerStartX, playerStartY)
    end

    player.animation:update(dt)
    updateEnemies(dt)
    cam.lookAt(px, love.graphics.getHeight() / 2)
    local colliders = world:queryCircleArea(flagX, flagY, 10, { COLLISION_CLASSES.Player })
    if #colliders > 0 then
        loadMap("level2")
    end
end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0)
    cam:attach()
    gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
    world:draw()
    local px, py = player:getPosition()
    player.animation:draw(sprites.playerSheet, px, py, nil, 0.25 * player.direction, 0.25, 130, 300)
    drawEnemies()
    cam:deattach()
end

function love.keypressed(key)
    if key == "up" and player.isGrounded then
        player:applyLinearImpulse(0, -1000)
        sounds.jump:play()
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

function loadMap(mapName)
    saveData.currentLevel = mapName
    love.filesystem.write("data.lua", table.show(saveData, "saveData"))
    destroyAll()
    gameMap = sti("maps." .. mapName .. ".lua")
    for i, obj in ipairs(gameMap.layers.Start.objects) do
        player:setPosition(obj.x, obj.y)
    end
    for i, obj in ipairs(gameMap.layers.Platforms.objects) do
        spawnPlatform(obj.x, obj.y, obj.width, obj.height)
    end
    for i, obj in ipairs(gameMap.layers.Enemies.objects) do
        spawnEnemy(obj.x, obj.y)
    end
    for i, obj in ipairs(gameMap.layers.Flag.objects) do
        flagX, flagY = obj.x, obj.y
    end
end

function spawnPlatform(x, y, width, height)
    if width > 0 and height > 0 then
        local platform = world:newRectangleCollider(x, y, width, height, { collision_class = COLLISION_CLASSES.Platform })
        platform:setType("static")
        table.insert(platforms, platform)
    end
end

function destroyAll()
    for i = #platforms, 1, -1 do
        platforms[i]:destroy()
    end
    for i = #enemies, 1, -1 do
        enemies[i]:destroy()
    end
    platforms = {}
    enemies = {}
end
