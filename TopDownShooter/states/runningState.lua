local Bullet = require("characters.bullet")
local Player = require("characters.player")
local Zombie = require("characters.zombie")

---@class RunningState
local RunningState = {}
RunningState.timer = maxTime
RunningState.score = 0

---Constructor
---@return RunningState
function RunningState:new()
    local state = {}
    state.player = Player:new()
    state.zombies = {}
    state.bullets = {}
    setmetatable(state, self)
    self.__index = self
    return state
end

---Updates the state of the game after dt seconds.
---@param game Game
---@param dt number
function RunningState:update(game, dt)
    for key, key_action in pairs(movements) do
        if love.keyboard.isDown(key) then
            self.player[key_action.dir] = self.player[key_action.dir] + key_action.delta * self.player.speed * dt
        end
    end
    for i, z in ipairs(self.zombies) do
        local angle = math.pi + self.player:getAngle(z.x, z.y)
        z.x = z.x + z.speed * math.cos(angle) * dt
        z.y = z.y + z.speed * math.sin(angle) * dt
        if distanceBetween(z.x, z.y, self.player.x, self.player.y) < MIN_DIST then
            game:updateHighestScore(self.score)
            game:setFinishedState(self.score)
        end
    end
    for i = #self.bullets, 1, -1 do
        local b = self.bullets[i]
        b.x = b.x + b.speed * math.cos(b.angle) * dt
        b.y = b.y + b.speed * math.sin(b.angle) * dt

        if b.x < 0 or b.y < 0 or b.x > graphics.getWidth() or b.y > graphics.getHeight() then
            table.remove(self.bullets, i)
        else
            for j = #self.zombies, 1, -1 do
                local z = self.zombies[j]
                if distanceBetween(z.x, z.y, b.x, b.y) < MIN_DIST then
                    table.remove(self.zombies, j)
                    table.remove(self.bullets, i)
                    self.score = self.score + 1
                    break
                end
            end
        end
    end
    self.timer = self.timer - dt
    if self.timer <= 0 then
        table.insert(self.zombies, Zombie:new())
        maxTime = 0.95 * maxTime
        self.timer = maxTime
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

---Shooting handler
---@param x number mouse x-axis
---@param y number mouse y-axis
---@param deltaScore number
---@param deltaTimer number
function RunningState:handleShooting(x, y, deltaScore, deltaTimer)
    if self.target:isHit(x, y) then
        self:placeNewTarget()
        self.score = self.score + deltaScore
        self.timer = self.timer - deltaTimer
    else
        if self.score > 0 then
            self.score = self.score - 1
        end
        self.target:reloadSpeed()
        table.insert(self.attempts, { x = x, y = y })
    end
end

---Draws the current state of the running game.
---@param highestScore number
function RunningState:draw(highestScore)
    graphics.setColor(1, 1, 1)
    -- local scoreMsg = "Score: " .. self.score
    -- if highestScore then scoreMsg = scoreMsg .. "\nHighest score: " .. highestScore end
    -- graphics.print(scoreMsg, 25, 5)
    -- graphics.print("Time left: " .. self.timer - self.timer % 0.001, graphics.getWidth() - 300, 5)
    self.player:draw(love.mouse.getX(), love.mouse.getY())
    for _, zombie in ipairs(self.zombies) do
        zombie:draw(math.pi + self.player:getAngle(zombie.x, zombie.y))
    end
    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end
    graphics.printf("Score: " .. score, 0, graphics.getHeight() - 100, graphics.getWidth(), "center")
end

return RunningState
