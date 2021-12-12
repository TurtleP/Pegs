local map = class("map")

local camera = require("libraries.camera")
local physics = require("libraries.physics")

local colors  = require("data.colors")
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

map.States.STATE_DEAD    = "dead"
map.States.STATE_WIN     = "win"
map.States.STATE_WRONG   = "wrong"
map.States.STATE_INVALID = "invalid"

function map:new(data)
    local zoom = 2
    self.camera = camera(0, 0, zoom, 0)

    self.size = {width = #data[#data] * 16, height = #data * 16}
    self.windowSize = {width = 400, height = 240}


    self:decode(data)
    self._state = nil
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

    local exclude = {"gap", "player", "barrier", "wall"}

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
    local target_x, target_y = self.player:position()

    local window_view_width  = self.windowSize.width  / (2 * self.camera.scale)
    local window_view_height = self.windowSize.height / (2 * self.camera.scale)

    local dx, dy = target_x - self.camera.x, target_y - self.camera.y

    if self.size.width < self.windowSize.width then
        self.camera.x = self.size.width / 2
    else
        self.camera.x = math.clamp(self.camera.x + dx / 2, window_view_width, self.size.width  - window_view_width)
    end

    if self.size.height < self.windowSize.height then
        self.camera.y = self.size.height / 2
    else
        self.camera.y = math.clamp(self.camera.y + dy / 2, window_view_height, self.size.height - window_view_height)
    end
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
    love.graphics.setColor(colors.user_interface)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())

    self.camera:attach()

    love.graphics.setColor(colors.background)
    love.graphics.rectangle("fill", 0, 0, self.size.width, self.size.height)

    local entities = physics.getEntities()
    for _, object in pairs(entities) do
        if object.draw then
            object:draw()
        end
    end

    self.camera:detach()
end

function map:gamepadpressed(button)
    if self._state then
        return
    end

    local transform, which = self:checkTransform()
    if self.player:static() or transform then
        if transform then
            which:gamepadpressed(self, button)
        end
        return
    end
    self.player:movement(button)
end

return map
