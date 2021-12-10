local menubar = class()

local colors = require("data.colors")
local fonts  = require("data.fonts")

local textures = require("data.textures")
local quads    = require("data.quads")

local button     = require("classes.editor.button")
local iconbutton = require("classes.editor.iconbutton")

local SHADOW_HEIGHT = 3

function menubar:new()
    self.x = 0
    self.y = 0

    self.width = love.graphics.getWidth("bottom")
    self.height = 32


    local box_width, box_height = 24, 16
    self._levelBox = {self.x + (48 - box_width) * 0.5, self.y + (self.height - box_height) * 0.5, box_width, box_height}

    local start_x = (self._levelBox[1] + self._levelBox[3])
    local width = 226

    local center_x = start_x + (width - (#quads.objects - 1) * 31) * 0.5

    self.items = {}
    for i = 1, #quads.objects do
        self.items[i] = iconbutton(center_x + (i - 1) * 31, self.y + (self.height - 24) * 0.5, {background = colors.background, icon = textures.objects, quad = quads.objects[i]})
    end

    self._selection = nil
    self._level = 1

    self._export = iconbutton((self.width - 42) + textures:width("export") * 0.5, self._levelBox[2], {background = colors.background, icon = textures.export, width = 24, height = 16, iconSize = 12, selectable = false})
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

    love.graphics.setColor(1, 1, 1, 1)

    local x, y, width, height = unpack(self._levelBox)
    love.graphics.rectangle("fill", x, y, width, height, 2, 2)

    love.graphics.setColor(colors.user_interface)
    love.graphics.print(self._level, fonts.menu_small, x + (24 - fonts.menu_small:getWidth(self._level)) * 0.5, y + (16 - fonts.menu_small:getHeight()) * 0.5)

    love.graphics.setColor(1, 1, 1)
    self._export:draw()
end

function menubar:level()
    return self._level
end

function menubar:unselect()
    if not self._selection then
        return
    end

    self.items[self._selection]:unselect()
    self._selection = nil
end

function menubar:selection()
    return self._selection
end

function menubar:size()
    return self.width, self.height + SHADOW_HEIGHT
end

function menubar:touchpressed(editor, x, y)
    for index, value in ipairs(self.items) do
        if value:touchpressed(x, y) then
            if self._selection and value ~= self.items[self._selection] then
                self.items[self._selection]:unselect()
            end
            self._selection = index
        end
    end

    if self._selection then
        if editor:mode() == "erase" then
            editor:setMode("edit")
        end
        self.items[self._selection]:select()
    end

    if self._export:touchpressed(x, y) then
        editor:exportMap()
    end
end

return menubar
