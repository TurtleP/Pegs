local config = class()

local colors = require ("data.colors")
local fonts  = require("data.fonts")

local button = require("classes.editor.button")
local ticker = require("classes.editor.ticker")

function config:new(editor)
    self.width = 192
    self.height = 128

    self.x = (love.graphics.getWidth("bottom") - self.width) * 0.5
    self.y = 16 + (love.graphics.getHeight() - self.height) * 0.5

    self._editor = editor

    local columns, rows = self._editor:size()

    self.columnsTicker = ticker("Width: ", self.x + self.width * 0.05, self.y + self.height * 0.2, columns)
    self.rowsTicker = ticker("Height:", self.x + self.width * 0.05, self.y + self.height * 0.4, rows)

    self.doneButton = button(self.x + (self.width - 96) * 0.5, self.y + self.height - 32, 96, 24, {text = "Done", callback = function ()
        editor:changeSize(self.columnsTicker:value(), self.rowsTicker:value())
    end})
end

function config:draw()
    love.graphics.setColor(colors.popupShadow)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())

    love.graphics.setColor(colors.background)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 2, 2)

    love.graphics.setColor(colors.user_interface)
    love.graphics.printf("Map Size", fonts.menu, self.x, self.y + self.height * 0.02, self.width, "center")

    self.columnsTicker:draw()
    self.rowsTicker:draw()
    self.doneButton:draw()
end

function config:touchpressed(x, y)
    self.columnsTicker:touchpressed(x, y)
    self.rowsTicker:touchpressed(x, y)
    self.doneButton:touchpressed(x, y)
end

return config
