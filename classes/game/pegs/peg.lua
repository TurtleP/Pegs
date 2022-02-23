local object  = require("classes.game.object")
local utility = require("data.utility")
local colors  = require("data.colors")
local physics = require("libraries.physics")

local peg = class({extends = object})

local vector = require("libraries.vector")

local textures = require("data.textures")
local quads = require("data.quads")

function peg:new(type, name, x, y)
    self:super(x, y, 16, 16)

    self._type = type
    self._name = name

    self._blocked = false
    self._lastPosition = vector(x, y)
    self._deleted = false
    self._mismatch = false

    self._mismatch_exclude = {"wall", "player", "barrier"}
end

function peg:draw()
    love.graphics.setColor(colors.user_interface)
    love.graphics.draw(textures.objects, quads.objects[self._type], self.x, self.y)
end

function peg:handlePlayer(name)
    if name ~= "player" then
        return "slide"
    end
    return false
end

function peg:deletePair(other)
    if not self:matches(other) then
        return "slide"
    end

    other:delete()
    self:delete()

    return false
end

function peg:handleSameType(other)
    return self:deletePair(other)
end

function peg:filter(other)
    local name = other:name()

    if name == "gap" then
        self:delete()
        return "slide"
    end

    if self:name() == name then
        return self:handleSameType(other)
    elseif self:name() ~= name and name ~= "player" then
        if not utility.any(self._mismatch_exclude, name) then
            self._mismatch = true
            return false
        end
    end
    return self:handlePlayer(name)
end

function peg:move(x, y)
    self._lastPosition = vector(self.x, self.y)

    self.x = self.x + x
    self.y = self.y + y
end

function peg:setPosition(x, y)
    self.x = x
    self.y = y
end

function peg:moved()
    local x, y = self:position()
    local ox, oy = self._lastPosition:unpack()

    return x ~= ox and y ~= oy
end

function peg:blocked()
    return self._blocked
end

function peg:mismatch()
    return self._mismatch
end

function peg:name()
    return self._name
end

function peg:id()
    return self._type
end

function peg:matches(other)
    return self._type == other:id()
end

return peg
