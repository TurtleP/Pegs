local textures = {}
textures.inited = false

function textures:load(name)
    return love.graphics.newImage("graphics/" .. name)
end

if not textures.inited then
    textures.logo = textures:load("title.png")

    textures.objects = textures:load("objects.png")

    textures.export = textures:load("editor/export.png")
    textures.trash  = textures:load("editor/trash.png")
    textures.config = textures:load("editor/config.png")
    textures.left   = textures:load("editor/left.png")
    textures.right  = textures:load("editor/right.png")

    textures.nextLevel = textures:load("editor/nextlevel.png")
    textures.prevLevel = textures:load("editor/prevlevel.png")
    textures.mappackName = textures:load("editor/mappackname.png")

    textures.inited = true
end

function textures:width(name)
    return self[name]:getWidth()
end

function textures:height(name)
    return self[name]:getHeight()
end

function textures:centered(screen, name)
    local width, height = love.graphics.getDimensions(screen)

    return (width - textures[name]:getWidth()) * 0.5,
           (height - textures[name]:getHeight()) * 0.5
end

return textures
