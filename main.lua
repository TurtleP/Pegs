love.graphics.setDefaultFilter("nearest", "nearest")

local nest = require("libraries.nest")
if nest then
    nest:init({mode = "ctr"})
end

require("libraries.batteries"):export()

local colors = require("data.colors")
local states = require("states").init("menu")

require("classes.notification")

function love.load()
    love.audio.setVolume(0)
    love.graphics.setBackgroundColor(colors.background)
end

function love.update(dt)
    states.update(dt)

    updateNotifications(dt)
end

function love.draw(screen)
    states.draw(screen)

    drawNotifications(screen)
end

function love.gamepadpressed(_, button)
    states.gamepadpressed(button)
end

function love.gamepadaxis(_, axis, value)
    states.gamepadaxis(axis, value)
end

function love.touchpressed(_, x, y)
    states.touchpressed(x, y)
end

function love.touchmoved(_, x, y)
    states.touchmoved(x, y)
end
