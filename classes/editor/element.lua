local element = class()

function element:new(x, y, width, height)
    self.x = x
    self.y = y

    self.width  = width
    self.height = height
end

function element:position()
    return self.x, self.y
end

function element:size()
    return self.width, self.height
end

function element:draw()
    error("Not Implemented.")
end

function element:touchpressed(x, y)
    return x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height
end

return element
