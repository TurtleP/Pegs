local peg  = require((...):gsub("plus", "peg"))
local plus = class({extends = peg})

local physics = require("libraries.physics")

function plus:new(x, y)
    self:super(6, "plus", x, y)

    self._transform = false
    self._other = nil
end

function plus:handleSameType(other)
    self:delete()
    other:setTransform(true)
end

function plus:setTransform(transform)
    self._transform = transform
end

function plus:transform()
    return self._transform
end

function plus:gamepadpressed(map, button)
    if button == "dpright" then
        self._type = math.wrap(self._type + 1, 3, 6)
    elseif button == "dpleft" then
        self._type = math.wrap(self._type - 1, 3, 6)
    elseif button == "a" then
        self:delete()

        local entity = map:identify(self._type, self:position())
        physics.addEntity(entity)
    end
end

return plus
