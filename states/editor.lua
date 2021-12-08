local editor = class()

local menubar = require("classes.editor.menubar")
local colors  = require("data.colors")

local vector = require("libraries.vector")

local textures = require("data.textures")
local quads    = require("data.quads")

function editor:enter()
    self.menubar = menubar()

    self.width = love.graphics.getWidth("top") / 16
    self.height = love.graphics.getHeight() / 16

    self.grid = {}
    for y = 1, self.height do
        self.grid[y] = {}
        for x = 1, self.width do
            self.grid[y][x] = 0
        end
    end

    self.canvas = love.graphics.newCanvas(400, 240)
    self:updateGrid()

    self.camera = vector(0, 0)
    self.cursor = vector(0, 0)

    self._player = vector(-1, -1)
end

function editor:eraseGridSpot(x, y)
    if not x or not y then
        return
    end
    self.grid[y][x] = 0
end

function editor:updateGrid(x, y)
    if x and y and self.menubar:selection() then
        self.grid[y][x] = self.menubar:selection()
    end

    self.canvas:renderTo(function()
        love.graphics.clear(0, 0, 0, 0)

        love.graphics.setColor(colors.selection)

        for y = 1, self.height do
            for x = 1, self.width do
                love.graphics.rectangle("line", (x - 1) * 16, (y - 1) * 16, 16, 16)

                local value = self.grid[y][x]

                if value > 0 then
                    love.graphics.setColor(colors.user_interface)
                    love.graphics.draw(textures.objects, quads.objects[value], (x - 1) * 16, (y - 1) * 16)
                end
            end
        end
    end)
end

function editor:update(dt)

end

function editor:drawTop(depth)
    love.graphics.translate(self.camera:unpack())

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.canvas)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("line", 0, 0, 256, love.graphics.getHeight())
end

function editor:drawBottom()
    love.graphics.push()
    love.graphics.translate(self.camera:unpack())

    local width, height = self.menubar:size()
    love.graphics.setScissor(32, height, width - 64, love.graphics.getHeight() - height)

    love.graphics.draw(self.canvas, 32, height)

    love.graphics.setScissor()
    love.graphics.pop()

    self.menubar:draw()
end

function editor:gamepadpressed(button)

end

function editor:touchpressed(x, y)
    self.menubar:touchpressed(x, y)

    local width, height = self.menubar:size()
    if x > 32 and x < width - 32 and y > height then
        local cursor_x, cursor_y = math.max(math.ceil((x - 32) / 16), 0), math.max(math.ceil((y - height) / 16), 0)

        if self.menubar:selection() == 1 then
            if self._player ~= vector(-1, -1) then
                local player_x, player_y = self._player:unpack()
                self:eraseGridSpot(player_x, player_y)
            end
            self._player = vector(cursor_x, cursor_y)
        end

        self.cursor = vector(cursor_x, cursor_y)

        self:updateGrid(self.cursor:unpack())
    end
end

return editor
