love.graphics.setDefaultFilter("nearest", "nearest")

require("libraries.nest"):init({mode = "ctr"})
require("libraries.batteries"):export()

local colors = require("data.colors")
local states = require("states").init("menu")


function love.load()
    love.graphics.setBackgroundColor(colors.background)
    -- love.audio.setVolume(0)
end

function love.update(dt)
    states.update(dt)
end

function love.draw(screen)
    states.draw(screen)
end

function love.gamepadpressed(_, button)
    states.gamepadpressed(button)
end
