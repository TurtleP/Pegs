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

function utility.switch(check)
    local t = {}

    t.case = function(var, func)
        if check == var then
            func()
        end
    end

    t.not_case = function(var, func)
        if check ~= var then
            func()
        end
    end

    t.not_any = function(values, func)
        local pass = true
        for _, value in ipairs(values) do
            if value == check then
                pass = false
            end
        end

        if pass then
            func()
        end
    end

    return t
end

return utility
