local wf = require("libraries/winfield/winfield")
local gx, gy = 0, 100
local world = wf.newWorld(gx, gy, false)

COLLISION_CLASSES = {
    Platform = "Platform",
    Player = "Player",
    Danger = "Danger"
}
world:addCollisionClass(COLLISION_CLASSES.Platform)
world:addCollisionClass(COLLISION_CLASSES.Player)
world:addCollisionClass(COLLISION_CLASSES.Danger)
--world:addCollisionClass("Player", { ignores = { "Platform" } })

world:setQueryDebugDrawing(true)
return world