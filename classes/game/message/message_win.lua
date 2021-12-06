local message = require((...):gsub("message_win", "message"))
local colors  = require("data.colors")
local audio   = require("data.audio")
local message_win  = class({extends = message})

function message_win:new()
    self:super("NICE PEGGING!")
    self.inited = false
end

function message_win:update(dt)
    if not self.inited then
        audio:play("win")
        self.inited = true
    else
        message.update(self, dt)
    end
end

function message_win:draw()
    local x, y = self:center()

    love.graphics.setColor(colors.user_interface)

    local width = 0
    local sector = (math.pi * 2 / #self._message)

    for index = 1, #self._message do
        if index > 0 then
            width = width + self._font:getWidth(self._message:sub(index - 1, index - 1))
        end

        local mul = math.sin((love.timer.getTime() * 14) + sector * index) * 8
        love.graphics.print(self._message:sub(index, index), self._font, x + width, y + mul)
    end
end

function message_win:finished()
    return self.inited and audio:stopped("win") and self.timer:expired()
end

return message_win
