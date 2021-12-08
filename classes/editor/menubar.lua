local menubar = class()

local colors = require("data.colors")

local textures = require("data.textures")
local quads    = require("data.quads")

local button = require("classes.editor.button")

local SHADOW_HEIGHT = 3

function menubar:new()
    self.x = 0
    self.y = 0

    self.width = love.graphics.getWidth("bottom")
    self.height = 32

    local center_x = ((self.width - 32) - ((#quads.objects - 1) * 31)) * 0.5

    self.items = {}
    for i = 1, #quads.objects do
        self.items[i] = button(center_x + (i - 1) * 31, self.y + (self.height - 24) * 0.5, textures.objects, quads.objects[i])
    end

    self._selection = nil
end

function menubar:draw()
    love.graphics.setColor(colors.user_interface)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    love.graphics.setColor(colors.shadow)
    love.graphics.rectangle("fill", self.x, self.y + self.height, self.width, SHADOW_HEIGHT)

    love.graphics.setColor(1, 1, 1, 1)

    for _, value in ipairs(self.items) do
        value:draw()
    end
end

function menubar:selection()
    return self._selection
end

function menubar:size()
    return self.width, self.height + SHADOW_HEIGHT
end

function menubar:touchpressed(x, y)
    for index, value in ipairs(self.items) do
        if value:touchpressed(x, y) then
            if self._selection then
                self.items[self._selection]:unselect()
            end
            print(index)
            self._selection = index
            break
        end
    end
end

return menubar
