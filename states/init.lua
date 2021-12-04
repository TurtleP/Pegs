
local path = (...):gsub('%.init$', '')

local states = {}
states.inited = false

states.value = {name = nil, state =  nil, args = nil}
states.items = {}

local __NULL__ = function() end

local function find_any(t, find)
    for _, value in ipairs(t) do
        if find == value then
            return true
        end
    end
    return false
end

local function remove_value(t, item)
    for index, value in pairs(t) do
        if item == value then
            return table.remove(t, index)
        end
    end
    return nil
end

local ErrorMessages = {}
ErrorMessages.ERROR_TYPE_TABLE = "target state '%s' is not a table."
ErrorMessages.ERROR_TYPE_DOES_NOT_EXIST = "target state '%s' does not exist."
ErrorMessages.ERROR_TYPE_FUNC_DOES_NOT_EXIST = "current state function '%s' does not exist."

function states.init(start)
    if states.inited then
        error("Cannot re-init module")
    end

    local items = love.filesystem.getDirectoryItems(path)
    remove_value(items, "init.lua")

    for index = 1, #items do
        local name = items[index]:gsub(".lua", "")
        local success, value = pcall(require, path .. "." .. name)

        if success then
            states.items[name] = value
        else
            error(value)
        end
    end

    if start then
        states.switch(start)
    end

    local events = { "update", "gamepadpressed",   "gamepadaxis",
                     "touchpressed", "touchmoved", "touchreleased" }

    for _, callback in ipairs(events) do
        states[callback] = function(...)
            local state = states.current()

            if state[callback] then
                state[callback](state, ...)
            end
        end
    end

    states.inited = true
    return states
end

function states.current()
    return states.value.name ~= "" and states.value.state
end

function states._has_method(name)
    local state = states.current()

    if state and state[name] then
        return state
    end
    return nil
end

function states._call_method(name, ...)
    local target = states._has_method(name)
    assert(target ~= nil, ErrorMessages.ERROR_TYPE_FUNC_DOES_NOT_EXIST:format(name))

    target[name](target, ...)
end

function states.reset()
    states.switch(states.value.name, states.value.args)
end

function states.switch(name, ...)
    local target = states.items[name]

    assert(target ~= nil, ErrorMessages.ERROR_TYPE_DOES_NOT_EXIST:format(name))
    assert(type(target) == "table", ErrorMessages.ERROR_TYPE_TABLE:format(name))

    if states.current() then
        states._call_method("exit")
    end

    states.value = {name = name, state = target, args = ...}

    states._call_method("enter", ...)
end

local function getDepth(screen)
    if love.graphics.get3DDepth then
        return screen ~= "bottom" and love.graphics.get3DDepth() or nil
    end
    return 0
end

local anyCheck = {"top", "left", "right"}
function states.draw(screen)
    local state = states.current()

    if state then
        local depth = getDepth(screen)
        if screen == "right" then
            depth = -depth
        end

        if state.drawTop and state.drawBottom then
            if state.drawTop and find_any(anyCheck, screen) then
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
