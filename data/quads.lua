local textures = require((...):gsub("quads", "textures"))

local quads = {}
quads.inited = false

if not quads.inited then
    quads.objects = {}
    for index  = 1, 7 do
        quads.objects[index] = love.graphics.newQuad((index - 1) * 17, 0, 16, 16, textures.objects)
    end

    quads.inited = true
end

return quads
