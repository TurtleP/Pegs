local editor = class()

local menubar    = require("classes.editor.menubar")
local icon       = require("classes.editor.icon")
local config     = require("classes.editor.config")
local iconbutton = require("classes.editor.iconbutton")

local utility    = require("data.utility")

local vector = require("libraries.vector")
local camera = require("libraries.camera")

local colors   = require("data.colors")
local textures = require("data.textures")
local quads    = require("data.quads")


local CELL_SIZE = 16

function editor:enter(puzzlePack)
    self.menubar = menubar()

    self.width = 13
    self.height = 8

    self.levels = puzzlePack:getLevels()
    self:newLevel()

    if puzzlePack:levelCount() > 0 then
        self.grid = self.levels[self.menubar:level() .. ".lua"]
        self:updateGrid()
    end

    self.target = vector(0, 0)
    self.camera = camera(0, 0, 2)

    self._player = vector(-1, -1)
    love.graphics.setLineWidth(1)

    self._mappackName = nil
    self._authorName = nil

    self._trashIcon = icon(textures.trash, nil, (love.graphics.getWidth() - 32) + (32 - 16) * 0.5, love.graphics.getHeight() - 24)

    self.panning = {horizontal = 0, vertical = 0}

    self.user_interface = {}

    local _, height = self.menubar:size()

    self._config = config(self)
    local x = (love.graphics.getWidth() - 32) + (32 - 24) * 0.5

    self.user_interface.conifg = iconbutton(x, height + 8, {background = colors.background, icon = textures.config, callback = function(button)
        self._showConfig = true
    end})

    self.user_interface.eraser = iconbutton(x, love.graphics.getHeight() - 32, {background = colors.background, icon = textures.trash, callback = function(button)
        if button:selected() then
            button:unselect()
            self._mode = "edit"
            return
        end
        button:select()
        self.menubar:unselect()
        self._mode = "erase"
    end})

    self.user_interface.levelIncrease = iconbutton(x, height + 40, {background = colors.background, icon = textures.nextLevel, callback = function()
        self.menubar:setLevel(self, 1)
    end})

    self.user_interface.levelDecrease = iconbutton(x, height + 72, {background = colors.background, icon = textures.prevLevel, callback = function()
        self.menubar:setLevel(self, -1)
    end})

    self.user_interface.mappackName = iconbutton(x, height + 104, {background = colors.background, icon = textures.mappackName, callback = function()
        self:nameMappack()
    end})

    self.user_interface.authorName = iconbutton(x, height + 136, {background = colors.background, icon = textures.authorName, callback = function()
        self:nameAuthor()
    end})

    self._mode = "edit"
end

function editor:size()
    return self.width, self.height
end

function editor:newLevel()
    self.grid = {}
    for y = 1, self.height do
        self.grid[y] = {}
        for x = 1, self.width do
            self.grid[y][x] = 0
        end
    end

    self.canvas = love.graphics.newCanvas(400, 240)

    self:updateGrid()
end

function editor:changeLevel(index)
    if not self.levels[index .. ".lua"] then
        return self:newLevel()
    end

    self.grid = self.levels[index .. ".lua"]
    self:updateGrid()
end

function editor:changeSize(x, y)
    local old_width, old_height = self.width, self.height
    local truncate_x, truncate_y = x < old_width, y < old_height

    self.width  = x
    self.height = y

    if not truncate_x and not truncate_y then
        for row = 1, y do
            if not self.grid[row] then
                self.grid[row] = {}
            end

            for column = 1, x do
                if not self.grid[row][column] then
                    self.grid[row][column] = 0
                end
            end
        end
    else
        for row = old_height, y + 1, -1 do
            for column = old_width, x + 1, -1 do
                if truncate_x then
                    self.grid[row][column] = 0
                    table.remove(self.grid[row], column)
                end
            end

            if truncate_y then
                table.remove(self.grid, row)
            end
        end
    end

    local canvas_width, canvas_height = math.max(self.width * 16, 400), math.max(self.height * 16, 240)
    self.canvas = love.graphics.newCanvas(canvas_width, canvas_height)

    self:updateGrid()
    self._showConfig = false
end

function editor:eraseGridSpot(x, y)
    if not x or not y then
        return
    end
    self.grid[y][x] = 0
end

function editor:updateGrid(x, y, value)
    if x and y then
        if value then
            self.grid[y][x] = value
        else
            if self.menubar:selection() then
                self.grid[y][x] = self.menubar:selection()
            end
        end
    end

    self.canvas:renderTo(function()
        love.graphics.clear(0, 0, 0, 0)

        for row = 1, self.height do
            for column = 1, self.width do
                love.graphics.setColor(colors.selection)
                love.graphics.rectangle("line", (column - 1) * CELL_SIZE, (row - 1) * CELL_SIZE, CELL_SIZE, CELL_SIZE)

                local value = self.grid[row][column]

                if value > 0 then
                    love.graphics.setColor(colors.user_interface)
                    love.graphics.draw(textures.objects, quads.objects[value], (column - 1) * CELL_SIZE, (row - 1) * CELL_SIZE)
                end
            end
        end
    end)
end

function editor:updateCamera(width)
    local dx, dy = self.target.x - self.camera.x, self.target.y - self.camera.y

    local height = (width == 400 and 240) or 205

    local window_view_width  = width  / (2 * self.camera.scale)
    local window_view_height = height / (2 * self.camera.scale)

    self.camera.x = math.clamp(self.camera.x + dx / 2, window_view_width,  (self.width * 16)  - window_view_width)
    self.camera.y = math.clamp(self.camera.y + dy / 2, window_view_height, (self.height * 16) - window_view_height)
end

function editor:update(dt)
    if self.panning.horizontal then
        self.target.x = math.clamp(self.target.x + self.panning.horizontal * dt, 0, self.width * 16)
    end

    if self.panning.vertical then
        self.target.y = math.clamp(self.target.y + self.panning.vertical * dt, 0, self.height * 16)
    end
end

function editor:gamepadaxis(axis, value)
    if axis == "leftx" then
        if value > 0.2 or value < -0.2 then
            if value > 0.2 then
                self.panning.horizontal = 120
            elseif value < -0.2 then
                self.panning.horizontal = -120
            end
        else
            self.panning.horizontal = 0
        end
    end

    if axis == "lefty" then
        if value > 0.5 or value < -0.5 then
            if value > 0.5 then
                self.panning.vertical = 60
            elseif value < -0.5 then
                self.panning.vertical = -60
            end
        else
            self.panning.vertical = 0
        end
    end
end

function editor:drawTop(depth)
    self:updateCamera(400)

    self.camera:attach()

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.canvas)

    self.camera:detach()
end

function editor:drawBottom()
    local width, height = self.menubar:size()

    self:updateCamera(256)

    self.camera:attach(32, height, width - 64, love.graphics.getHeight() - height)

    love.graphics.draw(self.canvas)

    self.camera:detach()

    self.menubar:draw()

    love.graphics.setColor(colors.shadow)

    love.graphics.rectangle("fill", 32, height, 3, 180)
    love.graphics.rectangle("fill", love.graphics.getWidth() - 35, height, 3, love.graphics.getHeight() - height)

    love.graphics.setColor(colors.selection)

    love.graphics.rectangle("fill", 0, height, 32, love.graphics.getHeight() - height)
    love.graphics.rectangle("fill", love.graphics.getWidth() - 32, height, 32, love.graphics.getHeight() - height)

    love.graphics.setColor(colors.user_interface)

    for _, value in pairs(self.user_interface) do
        value:draw()
    end

    if self._showConfig then
        self._config:draw()
    end
end

function editor:textinput(text)
    if self._mode == "mappackName" then
        self._mappackName = text
    elseif self._mode == "authorName" then
        self._authorName = text
    end
    self._mode = "edit"
end

function editor:nameMappack()
    if not self._mappackName then
        self._mode = "mappackName"
        love.keyboard.setTextInput({hint = "Name your Puzzle Pack"})
    end
end

function editor:nameAuthor()
    if not self._authorName then
        self._mode = "authorName"
        love.keyboard.setTextInput({hint = "Enter Puzzle Pack author"})
    end
end

function editor:exportMap()
    self:nameMappack()
    self:nameAuthor()

    love.filesystem.createDirectory("maps/" .. tostring(self._mappackName))

    local filepath_format = "maps/%s/%s.lua"
    local filepath = filepath_format:format(tostring(self._mappackName), self.menubar:level())

    local file, error = love.filesystem.newFile(filepath, "w")

    local buffer = "return\n{\n"
    for y = 1, self.height do
        local strformat = "    {%s}%s"
        local row = table.concat(self.grid[y], ", ")

        if y == self.height then
            buffer = buffer .. strformat:format(row, "")
            break
        end
        buffer = buffer .. strformat:format(row, ",\n")
    end
    buffer = buffer .. "\n}"

    if not error then
        file:write(buffer)
    else
        local error_notification = "Failed to save map: %s."
        local reason = error:match("%b()")

        return spawnNotification(2, error_notification:format(reason))
    end

    local message = "Map saved to %s"
    spawnNotification(1, message:format(filepath))

    local require_path = filepath:gsub(".lua", "")
    local _, _, name = file:getFilename():find("/(%d+.lua)")

    self.levels[name] = require(require_path:gsub("/", "."))

    local info_filepath = filepath_format:format(self._mappackName, "info")
    local exists = love.filesystem.getInfo(info_filepath)

    if not exists then
        local info_format = "return { name = %s, author = %s }"
        love.filesystem.write(info_filepath, info_format:format(self._mappackName, self._authorName))
    end
end

function editor:getGridCursor(x, y)
    local width, height = self.menubar:size()

    if x > 32 and x < width - 32 and y > height then
        local camera_x, camera_y = self.camera:worldCoords(x, y, 0, 0, 256)

        local cursor_x = math.max(math.floor(camera_x / 16), 1)
        local cursor_y = math.max(math.round(camera_y / 16), 1)

        if cursor_x > self.width or cursor_y > self.height then
            return
        end

        return cursor_x, cursor_y
    end
end

function editor:placeObject(x, y)
    if (not x and not y) then
        return false
    end

    if self._mode == "erase" then
        return self:updateGrid(x, y, 0)
    end

    if self.menubar:selection() == 1 then
        if self._player ~= vector(-1, -1) then
            local player_x, player_y = self._player:unpack()
            self:eraseGridSpot(player_x, player_y)
        end
        self._player = vector(x, y)
    end

    self:updateGrid(x, y)
end

function editor:mode()
    return self._mode
end

function editor:setMode(mode)
    if not utility.any({"edit", "erase"}, mode) then
        return
    end

    if mode == "edit" then
        self.user_interface.eraser:unselect()
    end

    self._mode = mode
end

function editor:touchpressed(x, y)
    if self._showConfig then
        return self._config:touchpressed(x, y)
    end

    for _, value in pairs(self.user_interface) do
        value:touchpressed(x, y)
    end

    self.menubar:touchpressed(editor, x, y)

    local cursor_x, cursor_y = self:getGridCursor(x, y)
    self:placeObject(cursor_x, cursor_y)
end

function editor:touchmoved(x, y)
    local cursor_x, cursor_y = self:getGridCursor(x, y)
    self:placeObject(cursor_x, cursor_y)
end

return editor
