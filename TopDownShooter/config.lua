graphics = love.graphics
graphics.setFont(graphics.newFont(30))

movements = {
    d = { dir = "x", delta = 1 },
    w = { dir = "y", delta = -1 },
    a = { dir = "x", delta = -1 },
    s = { dir = "y", delta = 1 }
}

mouse = {}
mouse.leftClick = 1

MIN_COLLISION_DISTANCE = 30
ZOMBIE_MAX_SPAWN_TIME = 2

sprites = {}
sprites.background = graphics.newImage('sprites/background.png')
sprites.bullet = graphics.newImage('sprites/bullet.png')
sprites.player = graphics.newImage('sprites/player.png')
sprites.zombie = graphics.newImage('sprites/zombie.png')

---Returns the Euclidean distance between points (x1, y1) and (x2, y2)
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function haveCollided(objA, objB)
    return distanceBetween(objA.x, objA.y, objB.x, objB.y) < MIN_COLLISION_DISTANCE
end
