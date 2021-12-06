local mappack = class()

local colors = require("data.colors")
local fonts  = require("data.fonts")

local tween = require("libraries.tween")

function mappack:new(index, path)
    self.x = 10
    self.y = 15

    self.index = index

    local metadata = require(path .. ".info")

    self.name = metadata.name
    self.author = metadata.author

    self.staticX = self.x
    self.tween = tween.new(0.25, self, { x = self.x + 20}, "outQuad")

    self.selected = false
    self.height = fonts.menu:getHeight() + fonts.menu_small:getHeight()
    self.offset = 8

    self.levels = {}
    local items = love.filesystem.getDirectoryItems(path:gsub("%.", "/"))

    for mapIndex = 1, #items do
        if items[mapIndex]:sub(-4) == ".lua" then
            local name = items[mapIndex]:gsub(".lua", "")

            if name ~= "info" then
                _, self.levels[items[mapIndex]] = pcall(require, path .. "." .. name)
            end
        end
    end
end

function mappack:getLevels()
    return self.levels
end

function mappack:update(dt)
    if self.selected then
        self.tween:update(dt)
    else
        self.tween:reset()
    end
end

function mappack:select(selected)
    self.selected = selected
end

function mappack:draw()
    local color = colors.user_interface
    if self.selected then
        color = colors.selection

        love.graphics.setColor(color)
        love.graphics.rectangle("fill", self.staticX, self.y + (self.index - 1) * (self.height + self.offset), 4, self.height)
    end

    love.graphics.setColor(color)
    love.graphics.print(self.name, fonts.menu, self.x, self.y + (self.index - 1) * (self.height + self.offset))
    love.graphics.print("By " .. self.author, fonts.menu_small, self.x, (self.y + fonts.menu:getHeight()) + (self.index - 1) * (self.height + self.offset))
end

return mappack
