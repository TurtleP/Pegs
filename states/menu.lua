local menu = class("menu")

local audio    = require("data.audio")
local colors   = require("data.colors")
local fonts    = require("data.fonts")
local strings  = require("data.strings")
local textures = require("data.textures")

local mappack   = require("classes.menu.mappack")
local scrollbar = require("classes.menu.scrollbar")

local state = require("states")

function menu:enter()
    audio:play("menu")

    self.selections =
    {
        { text = strings.playGame, func = function()
            state.switch("game", self.mappacks[self.packSelection]:getLevels())
        end },
        { text = strings.selectMappack, func = function()
            self.state = "puzzles"
        end },
        { text = strings.instructions, func = function()
            self.state = "instructions"
        end }
    }

    love.filesystem.createDirectory("maps")
    self:loadPuzzlePacks()

    self.menuSelection = 1

    self.scrollbar = scrollbar(love.graphics.getWidth("bottom"), 16, 224, #self.mappacks)

    self.state = "main"
end

function menu:update(dt)
    if self.state == "puzzles" then
        for _, v in ipairs(self.mappacks) do
            v:update(dt)
        end
    end
end

function menu:drawTop(depth)
    local x, y = textures:centered("top", "logo")
    love.graphics.draw(textures.logo, math.round(x), math.round(y))

    love.graphics.setColor(colors.user_interface)
    fonts.print(strings.subtitle, love.graphics.getWidth() * 0.45, love.graphics.getHeight() * 0.125, 2, 2)

    fonts.print(strings.copyright, 0, love.graphics.getHeight() - fonts.height(" ", 1), 1)
    fonts.print(strings.version, love.graphics.getWidth() - fonts.width(strings.version, 1), love.graphics.getHeight() - fonts.height(" ", 1), 1, 1)
end

function menu:draw_main()
    for index = 1, #self.selections do
        local value = self.selections[index]

        local color = colors.user_interface
        if self.menuSelection == index then
            color = colors.selection
        end

        love.graphics.setColor(color)
        fonts.print(value.text, (love.graphics.getWidth() - fonts.width(value.text, 3)) * 0.5, 64 + (index - 1) * 48, 3, 3)
    end
end

function menu:loadPuzzlePacks()
    self.mappacks = {}
    local items = love.filesystem.getDirectoryItems("maps")

    for index = 1, #items do
        self.mappacks[index] = mappack(index, "maps." .. items[index])
    end

    self.packSelection = 1
    self.mappacks[self.packSelection]:select(true)
end

function menu:defaultPuzzlePacks()
    if #self.mappacks <= 1 then
        return
    end

    local function delete(directory)
        local items = love.filesystem.getDirectoryItems(directory)
        for _, value in ipairs(items) do
            local filepath = directory .. "/" .. value
            if love.filesystem.getInfo(filepath, "directory") then
                delete(filepath)
                love.filesystem.remove(filepath)
            else
                love.filesystem.remove(filepath)
            end
        end
    end

    delete("maps")
    self:loadPuzzlePacks()

    spawnNotification(2, "Puzzle Packs Reset")
end

function menu:draw_puzzles()
    love.graphics.setScissor(0, 8, love.graphics.getWidth(), love.graphics.getHeight() - 24)

    love.graphics.push()

    love.graphics.translate(0, -self.scrollbar:getScrollValue() * 48)

    for _, v in ipairs(self.mappacks) do
        v:draw()
    end

    love.graphics.pop()

    self.scrollbar:draw()

    love.graphics.setScissor()

    if #self.mappacks > 1 then
        local x = (love.graphics.getWidth() - fonts.width(strings.resetPacks, 2)) * 0.5
        local y = (love.graphics.getHeight() - fonts.height())

        love.graphics.setColor(colors.user_interface)
        fonts.print(strings.resetPacks, x, y, 2, 2)
    end
end

function menu:draw_instructions()
    love.graphics.setColor(colors.user_interface)
    fonts.print(strings.info, 0, 0)
end

function menu:drawBottom()
    self["draw_" .. self.state](self)
end

function menu:updateMappackSelection(cursorFunction)
    if self.mappacks[self.packSelection] then
        self.mappacks[self.packSelection]:select(false)
        cursorFunction()
        self.mappacks[self.packSelection]:select(true)
    end
end

function menu:gamepadpressed(button)
    if self.state == "main" then
        if button == "dpdown" then
            self.menuSelection = math.min(self.menuSelection + 1, #self.selections)
        elseif button == "dpup" then
            self.menuSelection = math.max(self.menuSelection - 1, 1)
        elseif button == "a" then
            self.selections[self.menuSelection].func()
        end
    elseif self.state == "puzzles" then
        if button == "dpdown" then
            self:updateMappackSelection(function()
                self.packSelection = math.min(self.packSelection + 1, #self.mappacks)
                print(self.packSelection, #self.mappacks)
                self.scrollbar:scroll(1)
            end)
        elseif button == "dpup" then
            self:updateMappackSelection(function()
                self.packSelection = math.max(self.packSelection - 1, 1)
                self.scrollbar:scroll(-1)
            end)
        elseif button == "a" then
            self.state = "main"
        elseif button == "x" then
            self:defaultPuzzlePacks()
        end
    elseif self.state == "instructions" then
        if button == "b" then
            self.state = "main"
        end
    end
end

function menu:exit()
    audio.menu:stop()
end

return menu
