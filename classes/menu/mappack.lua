local mappack = class()

local colors = require("data.colors")
local fonts  = require("data.fonts")

local tween = require("libraries.tween")

function mappack:new(index, path)
    self.x = 10
    self.y = 15

    self.index = index

    self.staticX = self.x
    self.tween = tween.new(0.25, self, { x = self.x + 20}, "outQuad")

    self.height = fonts.menu:getHeight() + fonts.menu_small:getHeight()
    self.offset = 8

    self._selected = false

    self.levels = {}

    local metadata = nil
    if type(path) == "table" then
        metadata = path
    else
        metadata = require(path .. ".info")
    end

    self._name   = tostring(metadata.name)
    self._author = tostring(metadata.author)

    self._levelCount = 0

    if type(path) == "string" then
        local items = love.filesystem.getDirectoryItems(path:gsub("%.", "/"))

        for mapIndex = 1, #items do
            if items[mapIndex]:sub(-4) == ".lua" then
                local name = items[mapIndex]:gsub(".lua", "")

                if name ~= "info" then
                    local success, result = pcall(require, path .. "." .. name)

                    if success then
                        self.levels[items[mapIndex]] = result
                        self._levelCount = self._levelCount + 1
                    end
                end
            end
        end
    end
end

function mappack:levelCount()
    return self._levelCount
end

function mappack:getLevels()
    return self.levels
end

function mappack:update(dt)
    if self._selected then
        self.tween:update(dt)
    else
        self.tween:reset()
    end
end

function mappack:select(selected)
    self._selected = selected
end

function mappack:draw()
    local color = colors.user_interface
    if self._selected then
        color = colors.selection

        love.graphics.setColor(color)
        love.graphics.rectangle("fill", self.staticX, self.y + (self.index - 1) * (self.height + self.offset), 4, self.height)
    end

    love.graphics.setColor(color)
    love.graphics.print(self._name, fonts.menu, self.x, self.y + (self.index - 1) * (self.height + self.offset))
    love.graphics.print("By " .. self._author, fonts.menu_small, self.x, (self.y + fonts.menu:getHeight()) + (self.index - 1) * (self.height + self.offset))
end

return mappack
