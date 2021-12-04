local map = class("map")

local camera = require("libraries.camera")
local colors = require("data.colors")

local utility = require("data.utility")

local peg = require("classes.game.pegs")

local ObjectTypes = {}

ObjectTypes.OBJECT_NONE     = 0
ObjectTypes.OBJECT_PLAYER   = 1
ObjectTypes.OBJECT_BARRIER  = 2
ObjectTypes.OBJECT_SQUARE   = 3
ObjectTypes.OBJECT_TRIANGLE = 4
ObjectTypes.OBJECT_CIRCLE   = 5
ObjectTypes.OBJECT_PLUS     = 6
ObjectTypes.OBJECT_GAP      = 7

function map:new(data)
    self.world = self:decode(data)
    self.worldMap = data

    local zoom = 2
    self.camera = camera(0, 0, zoom, 0)

    self.size = {width = #data[#data] * 16, height = #data * 16}
    self.windowSize = {width = 400, height = 240}

    self.centeredCamera = (self.size.width  < love.graphics.getWidth() and
                           self.size.height < love.graphics.getHeight())
end

function map:identify(value, x, y)
    local when = utility.switch(ObjectTypes, value)
    local object = nil

    when.case(ObjectTypes.OBJECT_NONE, function()
    end)

    when.case(ObjectTypes.OBJECT_PLAYER, function()
        if not self.player then
            object = peg.player(x, y)
            self.player = object
        end
    end)

    when.case(ObjectTypes.OBJECT_TRIANGLE, function()
        object = peg.triangle(value, x, y)
    end)

    when.case(ObjectTypes.OBJECT_PLUS, function()
        object = peg.plus(value, x, y)
    end)

    when.default(function()
        object = peg.base(value, x, y)
    end)

    return object
end

function map:decode(data)
    local world = {}

    for y = 1, #data do
        for x = 1, #data[y] do
            local value = data[y][x]

            -- check not empty
            local object = self:identify(value, (x - 1), (y - 1))

            if object then
                table.insert(world, object)
            end
        end
    end

    return world
end

function map:updateCamera()
    if not self.player or self.centeredCamera then
        self.camera:lookAt(self.size.width / 2, self.size.height / 2)
        return
    end

    local target_x, target_y = self.player:position()

    local wvw = self.windowSize.width  / (2 * self.camera.scale)
    local wvh = self.windowSize.height / (2 * self.camera.scale)

    local dx, dy = target_x - self.camera.x, target_y - self.camera.y

    self.camera.x = math.clamp(self.camera.x + dx / 2, 0, self.size.width  - wvw)
    self.camera.y = math.clamp(self.camera.y + dy / 2, 0, self.size.height - wvh)
end

function map:update(dt)
    self:updateCamera()
end

function map:draw()
    self.camera:attach()

    for _, object in pairs(self.world) do
        object:draw()
    end

    self.camera:detach()
end

function map:gamepadpressed(button)
    self.player:movement(button)
end

return map
