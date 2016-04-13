player = class("player")

function player:init(x, y)
	self.x = x
	self.y = y

	self.width = 16
	self.height = 16

	self.active = true

	self.gravity = 0

	self.speedx = 0
	self.speedy = 0

	self.mask =
	{
		["peg"] = true
	}

	self.canMove = true

	self.peg = nil
end

function player:update(dt)
	local speedx, speedy = 0, 0

	if self.canMove then
		if self.rightKey then
			speedx = 16
		elseif self.leftKey then
			speedx = -16
		end

		if self.upKey then
			speedy = -16
		elseif self.downKey then
			speedy = 16
		end
	else
		if self.peg then
			if self.rightKey then
				self.peg:change(1)
				self.rightKey = false
			elseif self.leftKey then
				self.peg:change(-1)
				self.leftKey = false
			end
		end
	end

	if self.rightKey or self.leftKey or self.upKey or self.downKey then
		self.canMove = false
	else
		self.canMove = true
	end

	if self.peg then
		return
	end
	self.speedx = speedx
	self.speedy = speedy
end

function player:draw()
	love.graphics.draw(objectImage, objectQuads[1], self.x, self.y)
end

function player:moveRight(move)
	self.rightKey = move
end

function player:moveUp(move)
	self.upKey = move
end

function player:moveLeft(move)
	self.leftKey = move
end

function player:moveDown(move)
	self.downKey = move
end

function player:setPeg(peg)
	if peg then
		self.canMove = false
	else
		self.canMove = true
	end

	self.peg = peg
end

function player:passiveCollide(name, data)
	if data.t == "hole" then
		newNotice("You fell and died.", false, function() gameLoadMap(currentLevel) end)

		deathSounds[love.math.random(#deathSounds)]:play()
		
		self.remove = true
	end
end

function player:rightCollide(name, data)
	if data.t ~= "block" then
		if data:move(self.speedx, self.speedy) then
			return false
		end
	end
end

function player:leftCollide(name, data)
	if data.t ~= "block" then
		if data:move(self.speedx, self.speedy) then
			return false
		end
	end
end

function player:upCollide(name, data)
	if data.t ~= "block" then
		if data:move(self.speedx, self.speedy) then
			return false
		end
	end
end

function player:downCollide(name, data)
	if data.t ~= "block" then
		if data:move(self.speedx, self.speedy) then
			return false
		end
	end
end