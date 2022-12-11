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
TARGET_RADIUS = 50

TARGET_WIDTH = 50
TARGET_HEIGHT = 100

GAME_FONT = graphics.newFont(30)
graphics.setFont(GAME_FONT)

sprites = {
    sky = graphics.newImage("sprites/sky.png"),
    crosshair = graphics.newImage("sprites/crosshair.png"),
    circleTarget = graphics.newImage("sprites/target.png"),
}

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
