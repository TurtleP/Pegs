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

function utility.colorfade(currenttime, maxtime, c1, c2) --Color function
    local tp = currenttime / maxtime
    local ret = {} --return color

    for i = 1, #c1 do
        ret[i] = c1[i] + (c2[i] - c1[i]) * tp
        ret[i] = math.max(ret[i], 0)
        ret[i] = math.min(ret[i], 1)
    end

    return ret
end

--[[
Switch statement based on a flat array or key array @list.
Copies the `list` into `items` to preserve original data.
 - @param check: `any` what we switch against.
 - @return `table` with functions
    - `t.case` @check == @var, if true, run `function` func
        - removes the value from the item checklist
    - `t.default` runs for anything remaining
        - removes remaining values from item checklist
]]
function utility.switch(list, check)
    local t = {}
    local items = {}

    for _, value in pairs(list) do
        table.insert(items, value)
    end

    local lastFound = false

    local function remove(var)
        if #items == 0 then
            return false
        end

        local foundIndex = nil

        for index, value in ipairs(items) do
            if value == var then
                foundIndex = index
                break
            end
        end

        if foundIndex then
            table.remove(items, foundIndex)
        end

        return foundIndex ~= nil
    end

    local function removeAll()
        if #items == 0 then
            return false
        end

        for index, _ in ipairs(items) do
            items[index] = nil
        end

        return true
    end

    t.case = function(var, func)
        if check == var then
            func()
            lastFound = remove(var)
        end
        return lastFound
    end

    t.default = function(func)
        if lastFound then
            return
        end

        func()
        return removeAll()
    end

    return t
end

return utility
