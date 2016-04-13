delayer = class("delayer")

function delayer:init()
	self.x = 0
	self.y = 0

	self.time = 10

	self.timer = 0
end

function delayer:add()
	self.time = self.time + 10
	self.timer = math.clamp(self.timer - love.math.random(5, 10), 0, self.time)
end

function delayer:update(dt)
	if notices[1] then
		return
	end

	self.quadi = math.floor( (self.timer / self.time) * (#delayerQuads - 1) ) + 1
	if self.timer < self.time then
		self.timer = self.timer + dt
	else
		newNotice("Time ran out!", true, function()
			util.changeState("title")
		end)
	end
end

function delayer:draw()
	love.graphics.setColor(255, 255, 255, 180)
	love.graphics.draw(delayerImage, delayerQuads[self.quadi], self.x, self.y)
	love.graphics.setColor(255, 255, 255, 255)
end