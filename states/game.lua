local game = class("game")

local audio = require("data.audio")

local map      = require("classes.game.map")
local messages = require("classes.game.message")

function game:enter(levels, levelIndex)
    audio:play("game")
    self.levels = levels

    assert(tonumber(levelIndex) or not levelIndex, "levelIndex must be a number")
    self.levelIndex = levelIndex or 1

    self.map = map(levels[self.levelIndex])

    self.messages = {}
    self.messages.dead = messages.death()
    self.messages.win  = messages.win()
end

function game:update(dt)
    if self.map:state() then
        self.messages[self.map:state()]:update(dt)
        return
    end
    self.map:update(dt)
end

function game:drawTop(depth)
    self.map:draw()
end

function game:drawBottom()
    if self.map:state() then
        self.messages[self.map:state()]:draw()
    end
end

function game:gamepadpressed(button)
    self.map:gamepadpressed(button)

    if button == "back" then
        self:enter(self.levels, self.levelIndex)
    end
end

function game:exit()

end

return game
