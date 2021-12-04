local peg = class()

local texture = love.graphics.newImage("graphics/objects.png")
local quads = {}
for index  = 1, 7 do
    quads[index] = love.graphics.newQuad((index - 1) * 17, 0, 16, 16, texture)
end

function peg:new(type, x, y)
    self.x = x
    self.y = y

    self.width  = 16
    self.height = 16

    self.type = type
end

function peg:draw()
    love.graphics.draw(texture, quads[self.type], self.x * 16, self.y * 16)
end

function peg:move(x, y)
    self.x = self.x + x
    self.y = self.y + y
end

function peg:position()
    return self.x, self.y
end

function peg:__eq(other)
    return self.type == other.type
end

return peg
