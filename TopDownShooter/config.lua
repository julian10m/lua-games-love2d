MIN_COLLISION_DISTANCE = 30
ZOMBIE_MAX_SPAWN_TIME = 2

graphics = love.graphics
graphics.setFont(graphics.newFont(30))

validKeys = {
    d = { dir = "x", delta = 1 },
    w = { dir = "y", delta = -1 },
    a = { dir = "x", delta = -1 },
    s = { dir = "y", delta = 1 }
}

mouse = {
    leftClick = 1,
}

sprites = {
    background = graphics.newImage('sprites/background.png'),
    bullet = graphics.newImage('sprites/bullet.png'),
    player = graphics.newImage('sprites/player.png'),
    zombie = graphics.newImage('sprites/zombie.png'),
}
