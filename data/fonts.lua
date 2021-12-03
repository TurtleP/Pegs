local fonts = {}
fonts.inited = false

if not fonts.inited then
    fonts.menu = love.graphics.newFont("graphics/superstar.ttf", 24)
    fonts.menu_small = love.graphics.newFont("graphics/superstar.ttf", 16)
    fonts.menu_big = love.graphics.newFont("graphics/superstar.ttf", 40)

    fonts.inited = true
end

return fonts
