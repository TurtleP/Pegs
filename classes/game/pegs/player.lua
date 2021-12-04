local peg = require((...):gsub("player", "peg"))
local player = class({extends = peg})

function player:new(x, y)
    self:super(1, x, y)
end

function player:movement(button)
    if button == "dpright" then
        self:move(1, 0)
    elseif button == "dpleft" then
        self:move(-1, 0)
    elseif button == "dpup" then
        self:move(0, -1)
    elseif button == "dpdown" then
        self:move(0, 1)
    end
    print(self.x, self.y)
end

return player
