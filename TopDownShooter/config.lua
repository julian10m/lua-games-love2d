graphics = love.graphics
graphics.setFont(graphics.newFont(30))

movements = {
    d = { dir = "x", delta = 1 },
    w = { dir = "y", delta = -1 },
    a = { dir = "x", delta = -1 },
    s = { dir = "y", delta = 1 }
}

MIN_DIST = 30
maxTime = 1
gameState = 1
score = 0

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

function playerMouseAngle()
    return playerAngle(love.mouse.getX(), love.mouse.getY())
end

function playerZombieAngle(x, y)
    return math.pi + playerAngle(x, y)
end

function playerAngle(x, y)
    return math.atan((y - player.y) / (x - player.x))
end
