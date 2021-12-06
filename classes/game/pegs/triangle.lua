local path = (...):gsub("triangle", "")

local peg     = require(path .. ".peg")
local barrier = require(path .. ".barrier")

local triangle = class({extends = peg})

local physics = require("libraries.physics")

function triangle:new(x, y)
    self:super(4, "triangle", x, y)
end

function triangle:handleSameType(other)
    peg.handleSameType(self, other)

    local entity = barrier(other:position())
    physics.addEntity(entity)
end

return triangle
