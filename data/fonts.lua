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

local font = love.graphics.newImage("graphics/font.png")
local quads = {}

local glyphs = "0123456789abcdefghijklmnopqrstuvwxyz.:/,'C-_>X !{}?[]*()=%`"
for index = 1, #glyphs do
    local glyph_value = glyphs:sub(index, index)
    quads[glyph_value] = love.graphics.newQuad((index - 1) * 8, 0, 8, 8, font)
end

local glyph_width = 8

function fonts.print(text, x, y, scale_x, scale_y)
    text = tostring(text)

    x = x or 0
    y = y or 0

    scale_x = scale_x or 2
    scale_y = scale_y or scale_x

    local start_x = x

    for index = 1, #text do
        local glyph = text:sub(index, index)

        if glyph == "\n" or glyph == "|" then
            x = (start_x - (index * (glyph_width * scale_x)))
            y = y + (glyph_width * scale_y)
        else
            if not quads[glyph] then
                print("Glyph " .. glyph .. " does not exist!")
            else
                love.graphics.draw(font, quads[glyph], x + (index - 1) * (glyph_width * scale_x), y, 0, scale_x, scale_y)
            end
        end
    end

    return y + (glyph_width * scale_x)
end

function fonts.width(text, scale)
    return #text * (glyph_width * (scale or 2))
end

function fonts.height(text, scale)
    return glyph_width * (scale or 2)
end

function fonts._format(text, limit, scale_x, scale_y)
    local width, result = 0, ""
    for index = 1, #text do
        local glyph = text:sub(index, index)
        width = width + fonts.width(glyph, scale_x)

        if width >= limit then
            glyph = "\n" .. glyph
            width = fonts.width(glyph, scale_x)
        end
        result = result .. glyph
    end
    return result
end

function fonts.printf(text, x, y, limit, align, scale_x, scale_y)
    local offset = 0
    if align == "center" then
        offset = ((limit - fonts.width(text, scale_x)) * 0.5)
    else
        text = fonts._format(text, limit, scale_x, scale_y)
    end

    fonts.print(text, x, y, scale_x, scale_y)
end

return fonts
