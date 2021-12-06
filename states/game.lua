local game = class("game")

local audio = require("data.audio")

local map      = require("classes.game.map")
local messages = require("classes.game.message")

function game:enter(levels, levelIndex)
    audio:play("game")
    self.levels = levels

    self.levelIndex = levelIndex or 1

    self.map = map(levels[tostring(self.levelIndex .. ".lua")])

    self.messages = {}
    self.messages.dead  = messages.death()
    self.messages.win   = messages.win()
    self.messages.wrong = messages.wrong()
end

function game:update(dt)
    if self.map:state() then
        local state = self.map:state()

        self.messages[state]:update(dt)

        if self.messages[state]:finished() then
            if state == map.States.STATE_WIN then
                self.levelIndex = self.levelIndex + 1
            end
            self:enter(self.levels, self.levelIndex)
        end
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
