notice = class("notice")

function notice:init(text, warning, onEnd)
	self.x = 0
	self.y = util.getHeight()

	self.width = mainFont:getWidth(text) + 2
	self.height = mainFont:getHeight()

	self.text = text

	local color = Color.white

	if warning then
		color = Color.red
	end
	self.color = color

	self.lifeTime = 2

	self.onEnd = onEnd
end

function notice:update(dt)
	if not self.goAway then
		if self.y > util.getHeight() - self.height then
			self.y = math.max(self.y - 60 * dt, util.getHeight() - self.height)
		else
			if self.lifeTime > 0 then
				self.lifeTime = self.lifeTime - dt
			else
				self.goAway = true
			end
		end
	else
		if self.y < util.getHeight() then
			self.y = math.min(self.y + 60 * dt, util.getHeight())
		else
			if self.onEnd then
				self.onEnd()
			end
			self.remove = true
		end
	end
end

function notice:draw()
	love.graphics.setColor(unpack(Color.black))
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

	love.graphics.setColor(unpack(self.color))
	love.graphics.print(self.text, self.x + 1, self.y + 2)

	love.graphics.setColor(unpack(Color.white))
end