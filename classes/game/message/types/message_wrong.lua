local message     = require((...):gsub("%.types.+", "") .. ".message")
local message_die = require((...):gsub("message_wrong", "message_dead"))

local audio   = require("data.audio")

local message_wrong  = class({extends = message_die})

function message_wrong:new()
    self:super()

    self._message = "those pegs don`t\nmatch!"
    self.timer:reset(2)
end

function message_wrong:init(dt)
    if not self.inited then
        audio:play("wrong", true)
        self.inited = true
    else
        message.update(self, dt)
    end
end

function message_wrong:finished()
    return self.inited and audio:stopped("wrong") and self.timer:expired()
end

return message_wrong
