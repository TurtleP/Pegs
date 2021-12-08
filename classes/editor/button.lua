local colors = require "data.colors"
local button = class()

local ICON_SIZE = 16

function button:new(x, y, texture, quad)
    self.x = x
    self.y = y

    self.width = 24
    self.height = 24

    self._texture = texture
    self._quad = quad
    self._selected = false
end

function button:unselect()
    self._selected = false
end

function button:draw()
    love.graphics.setColor(colors.background)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 2, 2)

    local color = colors.user_interface
    if self._selected then
        color = colors.selection
    end

    love.graphics.setColor(color)
    love.graphics.draw(self._texture, self._quad, self.x + (self.width - ICON_SIZE) * 0.5, self.y + (self.height - ICON_SIZE) * 0.5)
end

function button:touchpressed(x, y)
    if (x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height) then
        self._selected = true
        return true
    end
end

return button
