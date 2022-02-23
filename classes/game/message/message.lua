local message = class()

local fonts = require("data.fonts")

function message:new(message)
    self._message = message

    self.timer = timer(1, nil, nil)
end

function message:center()
    local width  = fonts.width(self._message)
    local height = fonts.height(self._message)

    return (love.graphics.getWidth("bottom") - width) * 0.5, (love.graphics.getHeight() - height) * 0.5
end

function message:update(dt)
    self.timer:update(dt)
end

function message:finished()
    error("TODO: Implement me!")
end

return message
