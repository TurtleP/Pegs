local element = require((...):gsub("button", "element"))
local button  = class({extends = element})

local colors = require ("data.colors")
local fonts  = require("data.fonts")

function button:new(x, y, width, height, config)
    self:super(x, y, width, height)

    if config then
        self._background = config.background
        self.callback = config.callback

        self.text = config.text
    end
end

function button:setBackgroundColor(color)
    self._background = color
end

function button:background()
    return self._background
end

function button:draw()
    if self._background then
        love.graphics.setColor(self._background)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 2, 2)
    end

    if self.text then
        love.graphics.setColor(colors.user_interface)
        love.graphics.printf(self.text, fonts.menu, self.x, self.y, self.width, "center")
    end
end

function button:touchpressed(x, y)
    if element.touchpressed(self, x, y) then
        if self.callback then
            self.callback(self)
        end
        return true
    end
end

return button
