
local path = (...):gsub('%.init$', '')

local states = {}
states.inited = false

states.current = nil

states.items = {}

local __NULL__ = function() end

function states.registerEvents()
    local events = { "update", "gamepadpressed", "gamepadaxis",
                     "touchpressed", "touchmoved", "touchreleased" }

    for _, callback in ipairs(events) do
        states[callback] = function(...)
            local state = states.getCurrent()

            if state[callback] then
                state[callback](state, ...)
            end
        end
    end
end

function states.init(start)
    if states.inited then
        error("Cannot re-init module")
    end

    local items = love.filesystem.getDirectoryItems(path)
    table.remove_value(items, "init.lua")

    for index = 1, #items do
        local name = items[index]:gsub(".lua", "")
        local success, value = pcall(require, path .. "." .. name)

        if success then
            states.items[name] = value
        else
            error(value)
        end
    end

    states.inited = true

    if start then
        states.switch(start)
    end

    states.registerEvents()

    return states
end

function states.getCurrent()
    return assert:some(states.current)
end

function states.switch(name, ...)
    local switch = assert:type(states.items[name], "table")

    if states.current then
        states.current:exit()
    end

    states.current = switch
    switch:enter(...)
end

function states.update(dt)
    if states.current then
        states.current:update(dt)
    end
end

local function getDepth(screen)
    if love.graphics.get3DDepth then
        return screen ~= "bottom" and love.graphics.get3DDepth() or nil
    end
    return 0
end

local function any(t, find)
    for _, value in ipairs(t) do
        if find == value then
            return true
        end
    end
    return false
end

function states.draw(screen)
    local state = states:getCurrent()

    if state then
        local depth = getDepth(screen)
        if screen == "right" then
            depth = -depth
        end

        if state.drawTop and state.drawBottom then
            if state.drawTop and any({"top", "left", "right"}, screen) then
                state:drawTop(depth)
            end

            if state.drawBottom and screen == "bottom" then
                state:drawBottom()
            end
        else
            state:draw(screen, depth)
        end
    end
end

return states
