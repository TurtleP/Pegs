local object = require((...):gsub("wall", "object"))
local wall = class({extends = object})

function wall:new(x, y, width, height)
    self:super(x, y, width, height)
end

function wall:static()
    return true
end

function wall:name()
    return "wall"
end

function wall:_draw()
    love.graphics.setColor(0, 0, 1)

    local x, y = self:position()
    love.graphics.rectangle("line", x, y, self:size())

    love.graphics.setColor(1, 1, 1)
end

return wall
