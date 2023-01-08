math.randomseed(1000 * os.time() * 13 / 7)
math.random()
math.random()
math.random()

graphics = love.graphics
graphics.setFont(graphics.newFont(30))

love.mouse.setVisible(false)

mouse = {
    leftClick = 1,
    rightClick = 2
}

INIT_TIMER = 20
INIT_SCORE = 0

TARGET_PROB_RECTANGLE = 0.5

TARGET_MIN_INITIAL_SPEED = 10
TARGET_MAX_INITIAL_SPEED = 200
TARGET_ROTATION_SPEED = 0.5 * math.pi

TARGET_MIN_RADIUS_CIRC = 25
TARGET_MAX_RADIUS_CIRC = 50

TARGET_MIN_SIZE_RECT = 25
TARGET_MAX_SIZE_RECT = 100
TARGET_ROTATION_ANGLE = 0

sprites = {
    sky = graphics.newImage("sprites/sky.png"),
    crosshair = graphics.newImage("sprites/crosshair.png"),
    -- circleTarget = graphics.newImage("sprites/target.png"),
}
