local game = class("game")

local audio = require("data.audio")

local map = require("classes.game.map")

function game:enter(levels, levelIndex)
    audio:play("game")
    self.levels = levels

    assert(tonumber(levelIndex) or not levelIndex, "levelIndex must be a number")
    self.levelIndex = levelIndex or 1

    self.map = map(levels[self.levelIndex])
end

function game:update(dt)
    self.map:update()
end

function game:drawTop(depth)
    self.map:draw()
end

function game:drawBottom()

end

function game:gamepadpressed(button)
    self.map:gamepadpressed(button)
end

function game:exit()

end

return game
