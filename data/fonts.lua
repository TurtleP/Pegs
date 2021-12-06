local fonts = {}
fonts.inited = false

if not fonts.inited then
    fonts.menu = love.graphics.newFont("graphics/superstar.ttf", 24)
    fonts.menu_small = love.graphics.newFont("graphics/superstar.ttf", 16)
    fonts.menu_medium = love.graphics.newFont("graphics/superstar.ttf", 20)
    fonts.menu_big = love.graphics.newFont("graphics/superstar.ttf", 40)

    fonts.message = love.graphics.newFont("graphics/superstar.ttf", 32)

    fonts.inited = true
end

return fonts
