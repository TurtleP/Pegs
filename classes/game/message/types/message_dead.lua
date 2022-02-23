local message = require((...):gsub("%.types.+", "") .. ".message")

local utility = require("data.utility")
local message_die  = class({extends = message})

local tween   = require("libraries.tween")
local vector  = require("libraries.vector")
local colors  = require("data.colors")
local audio   = require("data.audio")
local fonts   = require("data.fonts")

function message_die:new()
    self:super("you fell and died.")

    local x, y = self:center()
    self.target = y

    self.y = -fonts.height()
    self.position = vector(x, self.y)

    self.tween = tween.new(1, self, {y = self.target}, "outBounce")

    self.textColor       = colors.user_interface
    self.backgroundColor = colors.background

    self.colorTimer = 0
    self.colorMaxTime = 2

    self.inited = false
end

function message_die:init(dt)
    if not self.inited then
        audio:play("die")
        self.inited = true
    else
        message.update(self, dt)
    end
end

function message_die:update(dt)
    self:init(dt)

    self.tween:update(dt)
    self.colorTimer = math.min(self.colorTimer + dt * 0.25, 1)

    self.textColor = utility.colorfade(self.colorTimer, self.colorMaxTime, self.textColor,       colors.background)
    self.backgroundColor = utility.colorfade(self.colorTimer, self.colorMaxTime, self.backgroundColor, colors.user_interface)
end

function message_die:draw()
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())

    love.graphics.setColor(self.textColor)
    fonts.print(self._message, self.position.x, self.y)

    love.graphics.setColor(1, 1, 1)
end

function message_die:finished()
    return self.inited and audio:stopped("die") and self.timer:expired()
end

return message_die
