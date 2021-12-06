local peg = require((...):gsub("gap", "peg"))
local gap = class({extends = peg})

function gap:new(x, y)
    self:super(7, "gap", x, y)
end

function gap:isPassive()
    return true
end

function peg:isStatic()
    return true
end

return gap
