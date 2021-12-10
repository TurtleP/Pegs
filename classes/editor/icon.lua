local element = require((...):gsub("icon", "element"))
local icon = class({extends = element})

function icon:new(texture, quad, x, y)
    self.x = x
    self.y = y

    self.width = texture:getWidth()
    self.height = texture:getHeight()

    self.texture = texture
    self.quad = quad
end

function icon:draw()
    if self.quad then
        love.graphics.draw(self.texture, self.quad, self.x, self.y)
    end
    love.graphics.draw(self.texture, self.x, self.y)
end

return icon
