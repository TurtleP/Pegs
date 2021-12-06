local object = require("classes.game.object")
local peg = class({extends = object})

local vector = require("libraries.vector")

local texture = love.graphics.newImage("graphics/objects.png")
local quads = {}
for index  = 1, 7 do
    quads[index] = love.graphics.newQuad((index - 1) * 17, 0, 16, 16, texture)
end

function peg:new(type, name, x, y)
    self:super(x, y, 16, 16)

    self._type = type
    self._name = name

    self._blocked = false
    self._lastPosition = vector(x, y)
    self._deleted = false
    self._mismatch = false
end

function peg:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("line", self.x, self.y, 16, 16)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(texture, quads[self._type], self.x, self.y)
end

function peg:handlePlayer(name)
    if name ~= "player" then
        self._blocked = true
        return "slide"
    end
    return false
end

function peg:handleSameType(other)
    self:delete()
    other:delete()
end

function peg:filter(other)
    local name = other:name()

    if name == "gap" then
        self:delete()
        return false
    elseif self:name() == name then
        self:handleSameType(other)
    elseif self:name() ~= name then
        if name ~= "player" then
            self._mismatch = true
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

function peg:type()
    return self._type
end

function peg:matches(other)
    return self._type == other:type()
end

return peg
