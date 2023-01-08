---@type Utils Utils
local Utils = require("utils")
---@type Player Player
local Player = require("characters.player")
---@type Bullet Bullet
local Bullet = require("characters.bullet")
---@type Zombie Zombie
local Zombie = require("characters.zombie")

---@class RunningState
---@field private player Player
---@field private zombies Zombie[]
---@field private bullets Bullet[]
---@field private timer number
local RunningState = {}

RunningState.zombieMaxSpawnTime = ZOMBIE_MAX_SPAWN_TIME
RunningState.score = 0

---Constructor
---@return RunningState
function RunningState:new()
    local state = {}
    state.player = Player:new()
    state.zombies, state.bullets = {}, {}
    state.timer = self.zombieMaxSpawnTime
    setmetatable(state, self)
    self.__index = self
    return state
end

---Updates the state of the game after dt seconds.
---@param game Game
---@param dt number
function RunningState:update(game, dt)
    self.player:update(dt)
    self:updateZombies(game, dt)
    self:updateBullets(dt)
    self:updateTimer(dt)
end

---Updates the position of each zombie and in case one touches the player, switches to finished state.
---@param game Game
---@param dt number
function RunningState:updateZombies(game, dt)
    for _, z in ipairs(self.zombies) do
        z:update(math.pi + self.player:getAngle(z.x, z.y), dt)
        if Utils:haveCollided(z, self.player) then
            game:updateHighestScore(self.score)
            game:setFinishedState(self.score)
        end
    end
end

---Updates the position of each bullet, removing those off screen and intersected zombies
---@param dt number
function RunningState:updateBullets(dt)
    for i = #self.bullets, 1, -1 do
        local b = self.bullets[i]
        b:update(dt)
        if b:isOffScreen() then
            table.remove(self.bullets, i)
        else
            for j = #self.zombies, 1, -1 do
                local z = self.zombies[j]
                if Utils:haveCollided(z, b) then
                    table.remove(self.zombies, j)
                    table.remove(self.bullets, i)
                    self.score = self.score + 1
                    break
                end
            end
        end
    end
end

---Updates and the timer and adds a new zombie when it reaches 0.
---@param dt number
function RunningState:updateTimer(dt)
    self.timer = self.timer - dt
    if self.timer <= 0 then
        table.insert(self.zombies, Zombie:new())
        self.zombieMaxSpawnTime = 0.95 * self.zombieMaxSpawnTime
        self.timer = self.zombieMaxSpawnTime
    end
end

---Left click handler
---@param game Game
---@param x number mouse x-axis
---@param y number mouse y-axis
function RunningState:leftClick(game, x, y)
    table.insert(self.bullets,
        Bullet:new(self.player.x, self.player.y, self.player:getAngle(love.mouse.getX(), love.mouse.getY())))
end

---Draws the current state of the running game.
---@param highestScore number
function RunningState:draw(highestScore)
    graphics.setColor(1, 1, 1)
    self.player:draw(love.mouse.getX(), love.mouse.getY())
    self:drawZombies()
    self:drawBullets()
    self:drawScore(highestScore)
end

---Draws the zombies in the current running state.
function RunningState:drawZombies()
    for _, zombie in ipairs(self.zombies) do
        zombie:draw(math.pi + self.player:getAngle(zombie.x, zombie.y))
    end
end

---Draws the bullets in the current running state.
function RunningState:drawBullets()
    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end
end

---Draws the score board
---@param highestScore number
function RunningState:drawScore(highestScore)
    local scoreMsg = "Score: " .. self.score
    if highestScore then scoreMsg = scoreMsg .. "\nHighest score: " .. highestScore end
    graphics.printf(scoreMsg, 0, graphics.getHeight() - 100, graphics.getWidth(), "center")
end

return RunningState
