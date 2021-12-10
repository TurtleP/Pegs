local notification = class()

local tween  = require("libraries.tween")
local fonts  = require("data.fonts")
local colors = require("data.colors")

function notification:new(avoidScreen, time, message)
    self.screen = avoidScreen
    self.timer = timer(time, nil, nil)
    self.message = message

    self.width  = fonts.menu_medium:getWidth(message) + 8
    self.height = fonts.menu_medium:getHeight()

    local width_screen = "bottom"
    if avoidScreen == "bottom" then
        width_screen = "top"
    end

    self.x = (love.graphics.getWidth(width_screen) - self.width) * 0.5
    self.y = love.graphics.getHeight()

    self.tween = tween.new(0.3, self, {y = love.graphics.getHeight() + -(self.height + 2)}, "linear")
end

function notification:update(dt)
    if not self.timer:expired() then
        if self.tween:update(dt) then
            self.timer:update(dt)
        end
    else
        self.tween:update(-dt)
        if self.y == love.graphics.getHeight() then
            return true
        end
    end
end

function notification:draw(screen)
    if self.screen == screen then
        return
    end

    love.graphics.setColor(colors.user_interface)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 2, 2)

    love.graphics.setColor(colors.background)
    love.graphics.printf(self.message, fonts.menu_medium, self.x, self.y + (self.height - fonts.menu_medium:getHeight() + 3) * 0.5, self.width, "center")
end

notification.messages = {}
function spawnNotification(time, message, avoidScreen)
    if not avoidScreen then
        avoidScreen = "bottom"
    end

    table.insert(notification.messages, notification(avoidScreen, time, message))
end

function updateNotifications(dt)
    local current = notification.messages[1]

    if current and current:update(dt) then
        table.remove(notification.messages, 1)
    end
end

function drawNotifications(screen)
    local current = notification.messages[1]

    if current then
        current:draw(screen)
    end
end
