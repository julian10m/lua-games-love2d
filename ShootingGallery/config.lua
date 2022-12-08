graphics = love.graphics
love.mouse.setVisible(false)

GAME_STATE = {
    menu = 1,
    running = 2
}

MOUSE = {
    leftClick = 1,
    rightClick = 2,
    middleClick = 3
}

mouseClickActions = {
    [MOUSE.leftClick] = function(game, x, y) game:leftClick(x, y) end,
    [MOUSE.rightClick] = function(game, x, y) game:rightClick(x, y) end,
}

INIT_TIMER = 10
INIT_SCORE = 0
GAME_FONT = graphics.newFont(30)

sprites = {
    sky = graphics.newImage("sprites/sky.png"),
    crosshair = graphics.newImage("sprites/crosshair.png"),
    target = graphics.newImage("sprites/target.png"),
}

target = { radius = 50 }
