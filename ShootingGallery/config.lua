math.randomseed(1000 * os.time() * 13 / 7)
math.random()
math.random()
math.random()

graphics = love.graphics
love.mouse.setVisible(false)

mouseClickActions = {
    [1] = function(game, x, y) game:leftClick(x, y) end,
    [2] = function(game, x, y) game:rightClick(x, y) end,
}

INIT_TIMER = 20
INIT_SCORE = 0
TARGET_RADIUS = 50

MIN_RECT_TARGET_SIZE = 25
MAX_RECT_TARGET_SIZE = 100
TARGET_ROTATION_ANGLE = 0

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
