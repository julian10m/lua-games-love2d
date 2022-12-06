GAME_STATE = {
    menu = 1,
    running = 2
}

MOUSE = {
    leftClick = 1,
    rightClick = 2,
    middleClick = 3
}

INIT_TIMER = 10
INIT_SCORE = 0

function loadSprites()
    sprites = {}
    sprites.sky = love.graphics.newImage("sprites/sky.png")
    sprites.crosshair = love.graphics.newImage("sprites/crosshair.png")
    sprites.target = love.graphics.newImage("sprites/target.png")
    return sprites
end
