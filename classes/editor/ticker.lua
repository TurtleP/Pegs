local element = require((...):gsub("ticker", "element"))
local ticker  = class({extends = element})

local colors   = require("data.colors")
local fonts    = require("data.fonts")
local textures = require("data.textures")

local iconbutton = require("classes.editor.iconbutton")

function ticker:new(text, x, y, value)
    self:super(x, y, 150, 32)

    self._text = text
    self._value = value

    self.left = iconbutton(self.x + fonts.menu:getWidth(text) + 8, self.y + (self.height - 24) * 0.5, {icon = textures.left, iconSize = 8, callback = function()
        self._value = math.max(self._value - 1, 1)
    end})

    self.right = iconbutton(self.x + self.width, self.y + (self.height - 24) * 0.5, {icon = textures.right, iconSize = 8, callback = function()
        self._value = math.min(self._value + 1, 64)
    end})
end

function ticker:value()
    return self._value
end

function ticker:draw()
    love.graphics.print(self._text, fonts.menu, self.x, self.y + 3 + (self.height - fonts.menu:getHeight()) * 0.5)

    self.left:draw()

    local x, _ = self.left:position()
    local left_width, _ = self.left:size()

    local other, _ = self.right:position()

    local width = (other - (x + left_width))

    love.graphics.print(self._value, fonts.menu, x + left_width + (width - fonts.menu:getWidth(self._value)) * 0.5, self.y + 3 + (self.height - fonts.menu:getHeight()) * 0.5)

    self.right:draw()
end

function ticker:touchpressed(x, y)
    self.left:touchpressed(x, y)

    self.right:touchpressed(x, y)
end

return ticker
