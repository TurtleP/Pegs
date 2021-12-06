local peg  = require((...):gsub("plus", "peg"))
local plus = class({extends             = peg})

function plus:new(x, y)
    self:super(6, "plus", x, y)
end

return plus
