local physics = {}

local bump = require("libraries.bump")

local world = nil
local entities = {}

function physics.new(objects)
    world = bump.newWorld(16)

    for _, entity in ipairs(objects) do
        physics.addEntity(entity)
    end

    entities = objects
end

local function defaultFilter()
    return "slide"
end

function physics.addEntity(entity)
    local x, y, width, height = entity:bounds()

    world:add(entity, x, y, width, height)
    table.insert(entities, entity)
end

function physics.update(dt)

    for entry, entity in ipairs(entities) do
        local x, y = entity:position()

        local filter = defaultFilter
        if entity.filter then
            filter = entity.filter
        end

        local ax, ay, collisions, len = world:move(entity, x, y, filter)

        -- hit something, resolve
        if len and len > 0 then
            for index = 1, #collisions do
                local collision = collisions[index].other

                if not collisions[index].other:passive()  then
                    if collisions[index].normalY ~= 0 then
                        physics.resolveVertical(entity, collision, -collisions[index].normalY)
                    elseif collisions[index].normalX ~= 0 then
                        physics.resolveHorizontal(entity, collision, -collisions[index].normalX)
                    end
                else
                    if entity.passiveCollide then
                        entity:passiveCollide(entity, collision)
                    end
                end
            end
        end

        if ax and ay then
            entity:setPosition(ax, ay)
        end

        if entity:deleted() then
            world:remove(entity)
            table.remove(entities, entry)
        end
    end
end

function physics.resolveVertical(entity, against, velocity)
    local name = against:name()

    if velocity > 0 then
        if entity.floorCollide then
            entity:floorCollide(name, against)
        end
    else
        if entity.ceilCollide then
            entity:ceilCollide(name, against)
        end
    end
end

function physics.resolveHorizontal(entity, against, velocity)
    local name = against:name()

    if velocity > 0 then
        if entity.rightCollide then
            entity:rightCollide(name, against)
        end
    else
        if entity.leftCollide then
            entity:leftCollide(name, against)
        end
    end
end

function physics.getEntities()
    return entities
end

return physics
