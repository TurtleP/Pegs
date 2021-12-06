local peg    = require((...):gsub("player", "peg"))
local player = class({extends = peg})

local vector = require("libraries.vector")

function player:new(x, y)
    self:super(1, "player", x, y)
    self.vector = vector(0, 0)
end

function player:filter(other)
    local name = other:name()

    if name == "gap" then
        self:delete()
        return false
    end

    if not other:static() and not other:blocked() then
        other:move(self.vector:unpack())
        return false
    end

    return "slide"
end

function player:movement(button)
    self.vector = vector(0, 0)
    if button == "dpright" then
        self.vector = vector(16, 0)
    elseif button == "dpleft" then
        self.vector = vector(-16, 0)
    elseif button == "dpup" then
        self.vector = vector(0, -16)
    elseif button == "dpdown" then
        self.vector = vector(0, 16)
    end
    self:move(self.vector:unpack())
end

return player
