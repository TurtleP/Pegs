local button     = require((...):gsub("iconbutton", "button"))
local iconbutton = class({extends = button})

local colors = require("data.colors")

function iconbutton:new(x, y, config)
    self:super(x, y, config.width or 24, config.height or 24, config)

    self._texture = assert:some(config.icon)
    self._quad = config.quad

    self._defaultBackground = self._background

    self._defaultColor = colors.user_interface
    self._color = self._defaultColor

    self._iconSize = 16

    if config.iconSize then
        self._iconSize = config.iconSize
    end

    self._allowSelect = true
    if config.selectable ~= nil then
        self._allowSelect = config.selectable
    end
end

function iconbutton:draw()
    button.draw(self)

    love.graphics.setColor(self._color)

    if self._quad then
        return love.graphics.draw(self._texture, self._quad, self.x + (self.width - self._iconSize) * 0.5, self.y + (self.height - self._iconSize) * 0.5)
    end
    love.graphics.draw(self._texture, self.x + (self.width - self._iconSize) * 0.5, self.y + (self.height - self._iconSize) * 0.5)
end

function iconbutton:selected()
    return self._color == colors.background
end

function iconbutton:unselect()
    self._background = self._defaultBackground
    self._color = self._defaultColor
end

function iconbutton:select()
    if self._allowSelect and not self:selected() then
        self._background = colors.selection
        self._color = colors.background
    end
end

function iconbutton:touchpressed(x, y)
    if button.touchpressed(self, x, y) then
        return true
    end
    return false
end

return iconbutton
