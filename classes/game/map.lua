local map = class("map")

local camera = require("libraries.camera")
local physics = require("libraries.physics")

local utility = require("data.utility")

local peg  = require("classes.game.pegs")
local wall = require("classes.game.wall")

local ObjectTypes = {}

ObjectTypes.OBJECT_NONE     = 0
ObjectTypes.OBJECT_PLAYER   = 1
ObjectTypes.OBJECT_BARRIER  = 2
ObjectTypes.OBJECT_SQUARE   = 3
ObjectTypes.OBJECT_TRIANGLE = 4
ObjectTypes.OBJECT_CIRCLE   = 5
ObjectTypes.OBJECT_PLUS     = 6
ObjectTypes.OBJECT_GAP      = 7

map.States = {}

map.States.STATE_DEAD   = "dead"
map.States.STATE_WIN    = "win"
map.States.STATE_WRONG  = "wrong"

function map:new(data)
    local zoom = 2
    self.camera = camera(0, 0, zoom, 0)

    self.size = {width = #data[#data] * 16, height = #data * 16}
    self.windowSize = {width = 400, height = 240}

    self.centeredCamera = (self.size.width  < love.graphics.getWidth() and
                           self.size.height < love.graphics.getHeight())

    self:decode(data)
    self._state = nil

    local walls = {}
end

function map:getPieceName(id)
    for key, value in pairs(ObjectTypes) do
        if id == value then
            return key:split("_")[2]:lower()
        end
    end
    return false
end

function map:checkCleared()
    local entities = physics.getEntities()
    local count = 0

    local exclude = {"player", "barrier", "wall"}

    for _, value in ipairs(entities) do
        local name = value:name()
        if not utility.any(exclude, name) then
            count = count + 1
        end
    end

    return count == 0
end

function map:checkWrong()
    local entities = physics.getEntities()

    for  _, value in ipairs(entities) do
        if value.mismatch and value:mismatch() then
            return true
        end
    end
    return false
end

function map:checkTransform()
    local entities = physics.getEntities("plus")

    for  _, value in ipairs(entities) do
        if value:transform() then
            return true, value
        end
    end
    return false
end

function map:identify(value, x, y)
    local when = utility.switch(ObjectTypes, value)
    local object, name = nil, self:getPieceName(value)

    when.case(ObjectTypes.OBJECT_NONE, function()
    end)

    when.case(ObjectTypes.OBJECT_BARRIER, function()
        object = peg.barrier(x, y)
    end)

    when.case(ObjectTypes.OBJECT_PLAYER, function()
        if not self.player then
            object = peg.player(x, y)
            self.player = object
        end
    end)

    when.case(ObjectTypes.OBJECT_SQUARE, function()
        object = peg.square(x, y)
    end)

    when.case(ObjectTypes.OBJECT_GAP, function()
        object = peg.gap(x, y)
    end)

    when.case(ObjectTypes.OBJECT_TRIANGLE, function()
        object = peg.triangle(x, y)
    end)

    when.case(ObjectTypes.OBJECT_PLUS, function()
        object = peg.plus(x, y)
    end)

    when.default(function()
        object = peg.base(value, name, x, y)
    end)

    return object
end

function map:decode(data)
    local objects = {}

    for mapy = 1, #data do
        for mapx = 1, #data[mapy] do
            local value = data[mapy][mapx]

            -- check not empty
            local object = self:identify(value, (mapx - 1) * 16, (mapy - 1) * 16)

            if object then
                table.insert(objects, object)
            end
        end
    end

    -- left wall
    table.insert(objects, wall(-16, 0, 16, self.size.height + 16))

    -- top wall
    table.insert(objects, wall(-16, -16, self.size.width + 16, 16))

    -- right wall
    table.insert(objects, wall(self.size.width, -16, 16, self.size.height + 16))

    --bottom wall
    table.insert(objects, wall(0, self.size.height, self.size.width - 16, 16))

    physics.new(objects)
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
    if self.player:deleted() then
        self._state = map.States.STATE_DEAD
        return
    end

    if self:checkCleared() then
        self._state = map.States.STATE_WIN
        return
    end

    if self:checkWrong() then
        self._state = map.States.STATE_WRONG
        return
    end

    self:updateCamera()
    physics.update(dt)
end

function map:state()
    return self._state
end

function map:draw()
    self.camera:attach()

    local entities = physics.getEntities()
    for _, object in pairs(entities) do
        if object.draw then
            object:draw()
        end
    end

    self.camera:detach()
end

function map:gamepadpressed(button)
    local transform, which = self:checkTransform()
    if self._state or self.player:static() or transform then
        if transform then
            which:gamepadpressed(self, button)
        end
        return
    end
    self.player:movement(button)
end

return map
