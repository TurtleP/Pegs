peg = class("peg")

function peg:init(x, y, t)
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
		--["player"] = true,
		["peg"] = true
	}

	if t ~= "hole" and t ~= "block" then
		gameAddPegCount(1)
	end

	self.t = t

	self.targets = {false, false}

	self.canMove = true

	self.quadi = 2 + self:getQuadi(t)
end

function peg:update(dt)
	if self.targets[1] and self.targets[2] then
		if util.dist(self.x, self.y, self.targets[1], self.targets[2]) == 0 then
			self.speedx = 0
			self.speedy = 0

			self.targets = {false, false}
		end
	end
end

function peg:draw()
	love.graphics.draw(objectImage, objectQuads[self.quadi], self.x, self.y)
end

function peg:getQuadi(t)
	if t == "square" then
		return 1
	elseif t == "triangle" then
		return 2
	elseif t == "circle" then
		return 3
	elseif t == "cross" then
		return 4
	elseif t == "hole" then
		return 5
	else
		return 0
	end
end

function peg:setType(i)
	if i == 3 then
		self.t = "square"
	elseif i == 4 then
		self.t = "triangle"
	elseif t == 5 then
		self.t = "circle"
	elseif t == 6 then
		self.t = "cross"
	end
end

function peg:move(x, y)
	local coll = checkrectangle(self.x + x, self.y + y, self.width, self.height, {"peg"})

	if #coll > 0 then
		if coll[1][2].t == "block" then
			return false
		elseif coll[1][2].t ~= "hole" and coll[1][2].t ~= self.t then
			gameOver()
			return false
		end
	end

	self.speedx = x
	self.speedy = y

	self.targets = {self.x + x, self.y + y}

	return true
end

function peg:passiveCollide(name, data)
	if self ~= data and data.t == "hole" then
		local fakeRemove = false
		if self.t ~= "square" then
			fakeRemove = true
		end
		self:collideRemove(data, fakeRemove)
	end
end

function peg:rightCollide(name, data)
	self:collideDetection(name, data)
end

function peg:leftCollide(name, data)
	self:collideDetection(name, data)
end

function peg:upCollide(name, data)
	self:collideDetection(name, data)
end

function peg:downCollide(name, data)
	self:collideDetection(name, data)
end

function peg:collideDetection(name, data)
	if name ~= "player" and data.t ~= "block" then
		if data.t == self.t then
			self:collideRemove(data)
		else
			if self.t == "square" and data.t == "hole" then
				self:collideRemove(data)
			else
				if data.t == "hole" then
					self:collideRemove(data, true)
				else
					gameOver()
				end
			end
		end
	end
end

function peg:change(dir)
	local maths, max = math.min, 6
	if dir < 0 then
		maths, max = math.max, 3
	end

	self.quadi = maths(self.quadi + dir, max)

	self:setType(self.quadi)
end

function peg:collideRemove(data, fakeRemove)
	if self.t == "triangle" and data.t == "triangle" then
		table.insert(objects["peg"], peg:new(data.x, data.y, "block"))
	elseif self.t == "cross" and data.t == "cross" then
		fakeRemove = true

		if objects["player"][1] then
			objects["player"][1]:setPeg(data)
		end
	end

	self.passive = true

	if not fakeRemove then
		data.remove = true
		data.passive = true
	end

	self.remove = true
end

function peg:getType()
	return self.t
end