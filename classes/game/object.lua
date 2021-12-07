local object = {}

function object:new(x, y, width, height)
    self.x = x
    self.y = y

    self.width = width
    self.height = height

    self._deleted = false
    self._static = false
end

function object:static()
    return self._static
end

function object:setStatic(state)
    self._static = state
end

function object:passive()
    return false
end

function object:position()
    return self.x, self.y
end

function object:size()
    return self.width, self.height
end

function object:bounds()
    return self.x, self.y, self.width, self.height
end

function object:deleted()
    return self._deleted
end

function object:delete()
    self._deleted = true
end

return object
