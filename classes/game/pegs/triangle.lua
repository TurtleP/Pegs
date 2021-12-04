local peg = require((...):gsub("triangle", "peg"))
local triangle = class({extends = peg})

function triangle:new(value, x, y)
    self:super(value, x, y)
end

return triangle
