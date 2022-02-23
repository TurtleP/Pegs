local game = class("game")

local audio = require("data.audio")

local map      = require("classes.game.map")
local messages = require("classes.game.message")

local states = require("states")

local function map_name(index)
    return index .. ".lua"
end

function game:enter(levels, levelIndex)
    self.levels = levels
    self.levelIndex = levelIndex or 1

    if not self.levels[map_name(self.levelIndex)] then
        states.switch("menu")
    end

    self.map = map(self.levels[map_name(self.levelIndex)])
    audio:play("game")

    self.messages = {}
    for key, value in pairs(messages) do
        self.messages[key] = value()
    end
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
