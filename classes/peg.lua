peg = class:new()

function peg:init(x, y, shape)
	self.x = x
	self.y = y
	self.shape = shape 

	self.width = 16*scale 
	self.height = 16*scale 
	self.mask = {"all"}

	self.oldx = x
	self.oldy = y 

	self.active = true 
	self.xSpeed = 0
	self.ySpeed = 0
	
	if self.shape == "square" then
		self.quad = 1
	elseif self.shape == "triangle" then
		self.quad = 2
	elseif self.shape == "circle" then
		self.quad = 3 
	elseif self.shape == "plus" then
		self.quad = 4
	end

	self.remove = false
	self.transformed = false
	self.selection = false
end

function peg:update(dt)
	--im a shaaape!


	local x, y = math.floor(self.x/(16*scale)), math.floor(self.y/(16*scale))

	if self.shape == "square" then
		for i, v in pairs(objects["block"]) do
			if v.passive == true then 
				if x*16*scale == v.x and y*16*scale == v.y then 
					map[x][y] = 1
					v.remove = true 
					self.remove = true 
				end
			end
		end
	elseif map[x][y] == 2 then
		if self.shape ~= "square" then
			for i, v in pairs(objects["block"]) do
				if self.x == v.x and self.y == v.y then 
					self.remove = true 
				end
			end
		end
	end 

	if map[x][y] ~= 2 then 
		map[x][y] = self.shape
	end

	if self.shape == "plus" then
		for i, v in pairs(pegs["plus"]) do
			if (v ~= self) and self.x == v.x and self.y == v.y then
				if not self.selection and not self.transformed then 
					self.selection = true 
					objects["player"][1].canmove = false
					objects["player"][1].selection = true
					self.remove = true
				end
			end
		end
	end

	if self.shape == "square" then
		for i, v in pairs(pegs["square"]) do
			if (v ~= self) and self.x == v.x and self.y == v.y then
				self.remove = true
			end
		end
	end

	if self.shape == "circle" then
		for i, v in pairs(pegs["circle"]) do
			if (v ~= self) and self.x == v.x and self.y == v.y then
				self.remove = true
				--print(v.x, v.y, self.x, self.y)
			end
		end
	end

	if self.shape == "triangle" then
		for i, v in pairs(pegs["triangle"]) do
			if (v ~= self) and self.x == v.x and self.y == v.y then
				self.remove = true
				table.insert(objects["block"], block:new(self.x, self.y, false, "solid"))
			end
		end
	end

	for i, v in pairs(pegs) do
		for j, w in pairs(v) do
			if (w ~= self) and self.x == w.x and self.y == w.y then
				print("!", self.shape)
				if not w.selection then 
					if w.shape ~= self.shape then
						self.remove = true 
						levelstat = "mismatch"	
						objects["player"][1].canmove = false
						minusLife()
					end
				end
			end
		end
	end
end

function peg:draw()
	love.graphics.draw(pegsimg, pegsquads[self.quad], self.x, self.y, 0, scale, scale)
end

function peg:Push(callBack, ply)
	self.movementcallback = callBack

	for k, v in pairs(objects["block"]) do
		if not v.passive then
			pegCheck(self, v, ply)
		end
	end

	for k, v in pairs(objects["barrier"]) do
		pegCheck(self, v, ply)
	end
end