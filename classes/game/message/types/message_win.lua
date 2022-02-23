local message = require((...):gsub("%.types.+", "") .. ".message")

local colors  = require("data.colors")
local audio   = require("data.audio")
local fonts   = require("data.fonts")

local message_win  = class({extends = message})

function message_win:new()
    self:super("nice pegging!")
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
            width = width + fonts.width(self._message:sub(index - 1, index - 1), 2)
        end

        local mul = math.sin((love.timer.getTime() * 14) + sector * index) * 8
        fonts.print(self._message:sub(index, index), x + width, y + mul, 2)
    end
end

function message_win:finished()
    return self.inited and audio:stopped("win") and self.timer:expired()
end

return message_win
