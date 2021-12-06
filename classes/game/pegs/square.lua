local peg = require((...):gsub("square", "peg"))
local square = class({extends = peg})

function square:new(x, y)
    self:super(3, "square", x, y)
end

function square:filter(other)
    local name = other:name()

    if name == "gap" then
        self:delete()
        other:delete()
        return false
    end
    return self:handlePlayer(name)
end

return square
