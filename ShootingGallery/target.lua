local Target = {}

function Target:new()
    local t = {}
    setmetatable(t, self)
    self.__index = self
    return t
end

function Target:place(x, y) end

function Target:draw() end

function Target:isHit(x, y) end

return Target
