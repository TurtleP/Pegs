local message = class()

local fonts = require("data.fonts")

function message:new(message)
    self._message = message
    self._font = fonts.menu_big
end

function message:center()
    local width  = self._font:getWidth(self._message)
    local height = self._font:getHeight()

    return (love.graphics.getWidth("bottom") - width) * 0.5, (love.graphics.getHeight() - height) * 0.5
end

function message:update(_)
end

return message
