local menu = class("menu")

local textures = require("data.textures")
local fonts = require("data.fonts")
local colors = require("data.colors")
local audio = require("data.audio")

function menu:enter()
    audio.menu:play()

    self.selections =
    {
        { text = "NEW GAME", func = function() end },
        { text = "SELECT PACK", func = function() end },
        { text = "???? ??????", func = function() end},
        { text = "EXIT GAME", func = function() end }
    }

    self.currentSelection = 1
end

function menu:update(dt)

end

function menu:drawTop(depth)
    local x, y = textures:centered("top", "logo")
    love.graphics.draw(textures.logo, x, y)

    love.graphics.setColor(colors.user_interface)
    love.graphics.printf("A Game of Object Elimination", fonts.menu, textures.logo:getWidth() * 0.32, textures.logo:getHeight() * 0.125, 300, "center")

    love.graphics.print("© 2021 TurtleP", fonts.menu_small, 0, love.graphics.getHeight() - fonts.menu_small:getHeight() + 4)
end

function menu:drawBottom()
    for index = 1, #self.selections do
        local value = self.selections[index]

        local color = colors.user_interface
        if self.currentSelection == index then
            color = colors.selection
        end

        love.graphics.setColor(color)
        love.graphics.print(value.text, fonts.menu_big, (love.graphics.getWidth() - fonts.menu_big:getWidth(value.text)) * 0.5, 40 + (index - 1) * 44)
    end
end

function menu:exit()
    audio.menu:stop()
end

return menu
