local textures = {}
textures.inited = false

if not textures.inited then
    textures.logo = love.graphics.newImage("graphics/title.png")

    textures.inited = true
end

function textures:centered(screen, name)
    local width, height = love.graphics.getDimensions(screen)

    return (width - textures[name]:getWidth()) * 0.5,
           (height - textures[name]:getHeight()) * 0.5
end

return textures
