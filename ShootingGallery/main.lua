dofile("config.lua")
Game = dofile("game.lua")

function love.load()
    game = Game:new()
    love.mouse.setVisible(false)
    sprites = loadSprites()
    target = { radius = 50 }
    game:placeTarget()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    game:mousepressed(x, y, button)
end
