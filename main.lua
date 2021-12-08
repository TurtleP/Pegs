love.graphics.setDefaultFilter("nearest", "nearest")

local nest = require("libraries.nest")
if nest then
    nest:init({mode = "ctr"})
end

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

    if button == "leftshoulder" then
        love.event.quit()
    end
end

function love.touchpressed(_, x, y)
    states.touchpressed(x, y)
end
