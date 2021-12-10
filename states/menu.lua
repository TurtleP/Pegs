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
        end },
        { text = strings.levelEditor, func = function()
            state.switch("editor", self.mappacks[self.packSelection])
        end}
    }

    love.filesystem.createDirectory("maps")

    self.mappacks = {}
    local items = love.filesystem.getDirectoryItems("maps")

    for index = 1, #items do
        self.mappacks[index] = mappack(index, "maps." .. items[index])
    end
    table.insert(self.mappacks, mappack(#items + 1, {name = "New Puzzle Pack", author = "You"}))

    self.menuSelection = 1

    self.packSelection = 1
    self.mappacks[self.packSelection]:select(true)

    self.scrollbar = scrollbar(love.graphics.getWidth("bottom"), 15, 204, #self.mappacks)

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
    love.graphics.draw(textures.logo, x, y)

    love.graphics.setColor(colors.user_interface)
    love.graphics.printf(strings.subtitle, fonts.menu, textures.logo:getWidth() * 0.32, textures.logo:getHeight() * 0.125, 300, "center")

    love.graphics.print(strings.copyright, fonts.menu_small, 0, love.graphics.getHeight() - fonts.menu_small:getHeight() + 4)
    love.graphics.print(strings.version, fonts.menu_small, love.graphics.getWidth() - fonts.menu_small:getWidth(strings.version), love.graphics.getHeight() - fonts.menu_small:getHeight() + 4)
end

function menu:draw_main()
    for index = 1, #self.selections do
        local value = self.selections[index]

        local color = colors.user_interface
        if self.menuSelection == index then
            color = colors.selection
        end

        love.graphics.setColor(color)
        love.graphics.print(value.text, fonts.menu_big, (love.graphics.getWidth() - fonts.menu_big:getWidth(value.text)) * 0.5, 40 + (index - 1) * 44)
    end
end

function menu:draw_puzzles()
    love.graphics.setScissor(0, 15, love.graphics.getWidth(), love.graphics.getHeight() - fonts.menu:getHeight() - 15)

    love.graphics.push()

    love.graphics.translate(0, -self.scrollbar:getScrollValue())

    for _, v in ipairs(self.mappacks) do
        v:draw()
    end

    love.graphics.pop()

    self.scrollbar:draw()

    love.graphics.setScissor()

    local x = (love.graphics.getWidth() - fonts.menu_medium:getWidth(strings.returnToMenu)) * 0.5
    local y = (love.graphics.getHeight() - fonts.menu_medium:getHeight())

    love.graphics.setColor(colors.user_interface)
    love.graphics.print(strings.returnToMenu, fonts.menu_medium, x, y)
end

function menu:draw_instructions()
    love.graphics.setColor(colors.user_interface)
    love.graphics.printf(strings.helpText, fonts.menu_medium, 2, 15, love.graphics.getWidth() - 4, "center")
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
                if self.packSelection % 5 == 0 then
                    self.scrollbar:scroll(1)
                end
            end)
        elseif button == "dpup" then
            self:updateMappackSelection(function()
                self.packSelection = math.max(self.packSelection - 1, 1)
                if self.packSelection % 4 == 0 then
                    self.scrollbar:scroll(-1)
                end
            end)
        elseif button == "a" then
            self.state = "main"
        end
    end

    if button == "b" then
        if self.state ~= "main" then
            self.state = "main"
        end
    end
end

function menu:exit()
    audio.menu:stop()
end

return menu
