local scrollbar = class()

local colors = require("data.colors")

function scrollbar:new(x, y, height, size)
    self.y = y

    self.width = 8
    self.x = x - self.width - 2

    self.fullHeight = height
    self.height = height / math.max((size - 3), 1)

    if size ~= 1 then
        self.max = math.ceil(size / 3)
    else
        self.max = 0
    end

    self.position = 0
end

function scrollbar:draw()
    love.graphics.setColor(colors.selection)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.fullHeight)

    love.graphics.setColor(colors.user_interface)
    love.graphics.rectangle("fill", self.x, self.y + (self.height * self.position), self.width, self.height)
end

function scrollbar:getScrollValue()
    return self.position
end

function scrollbar:scroll(dir)
    self.position = math.clamp(self.position + dir, 0, self.max)
end

return scrollbar
