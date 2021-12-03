local utility = {}

function utility.draw_depth(texture, x, y, depth, z, ...)
    love.graphics.draw(texture, x + (depth * z), y, ...)
end

function utility.print_depth(text, x, y, depth, z, ...)
    love.graphics.print(text, x + (depth * z), y, ...)
end

function utility.print_font_depth(text, font, x, y, ...)
    love.graphics.setFont(font)
    utility.print_depth(text, x, y, ...)
end

function utility.printf_depth(text, x, y, depth, z, ...)
    love.graphics.printf(text, x + (depth * z), y, ...)
end

function utility.printf_font_depth(text, font, x, y, ...)
    love.graphics.setFont(font)
    utility.printf_depth(text, x, y, ...)
end

return utility
