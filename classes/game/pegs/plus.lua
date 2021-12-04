local peg = require((...):gsub("plus", "peg"))
local plus = class({extends = peg})

function plus:new(value, x, y)
    self:super(value, x, y)
end

return plus
