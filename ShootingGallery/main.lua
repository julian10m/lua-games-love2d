dofile("config.lua")
dofile("utils.lua")

function love.load()
    gameFont = graphics.newFont(30)
    love.mouse.setVisible(false)
    sprites = loadSprites()
    loadInitValues()
    target = { radius = 50 }
    placeTarget()
end

function love.update(dt)
    if gameState == GAME_STATE.running then
        timer = math.max(timer - dt, 0)
        if timer == 0 then
            gameState = GAME_STATE.menu
        end
    end
end

function love.draw()
    graphics.setFont(gameFont)
    drawBackground()
    drawGameStateDependentContent()
    drawCrosshair()
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == MOUSE.middleClick then return end
    if gameState == GAME_STATE.menu then
        if button == MOUSE.leftClick then reloadGame() end
    elseif gameState == GAME_STATE.running then
        updateScore(x, y, button)
    end
end
