local peg     = require((...):gsub("barrier", "peg"))
local barrier = class({extends                = peg})

function barrier:new(x, y)
    self:super(2, "barrier", x, y)
end

function barrier:static()
    return true
end

return barrier
