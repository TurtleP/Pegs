player = class:new()

function player:init(x, y)
	self.x = x
	self.y = y 
	self.rightkey = false 
	self.leftkey = false 
	self.upkey = false 
	self.downkey = false 
	self.keysdown = 0
	self.movementcallback = "none"
	print(self.x/32, self.y/32)
	self.graphic = playerimg
	self.width = 16*scale 
	self.height = 16*scale 
	self.canmove = true 

	self.active = true 
	self.type = "player"

	self.xSpeed = 0
	self.ySpeed = 0

	self.startx = x
	self.starty = y
	self.dead = false 

	self.dummyquad = 4
	self.changescreen = false
	print(mapwidth, mapheight)
end

function player:update(dt)
	if self.keysdown > 1 then
		if self.movementcallback == "up" then
			self.upkey = false
		elseif self.movementcallback == "right" then
			self.rightkey = false
		elseif self.movementcallback == "down" then
			self.downkey = false 
		elseif self.movementcallback == "left" then
			self.leftkey = false
		end
	end

	local x, y = math.floor(self.x/(16*scale)), math.floor(self.y/(16*scale))

	self:checkCamera()
end

function player:draw()
	if self.graphic then 
		love.graphics.draw(playerimg, self.x, self.y, 0, scale, scale)
	end
	if self.selection then
		local x, y = self:placePeg(self.movementcallback)
		love.graphics.draw(pegsimg, pegsquads[self.dummyquad], x, y, 0, scale, scale)
	end
end

function player:downcollide(v, name)
	if name == "block" then
		if v.passive then
			self:die("pit")
		end
	end
end

function player:die(how)
	print("player died from: " .. how)

	self.graphic = nil
	self.canmove = false

	if not self.dead then
		minusLife()
	end
	
	self.dead = true 
	levelstat = "pitdeath"
end

function player:pushpeg(dir, peg)
	local x, y = math.floor(self.x/(16*scale)), math.floor(self.y/(16*scale))

	if dir == "right" then
		if map[x+2][y] ~= 1 then 
			peg.x = peg.x + 16*scale 
		end
	elseif dir == "left" then
		if map[x-2][y] ~= 1 then 
			peg.x = peg.x - 16*scale 
		end
	elseif dir == "up" then
		if map[x][y-2] ~= 1 then 
			peg.y = peg.y - 16*scale
		end
	elseif dir == "down" then
		if map[x][y+2] ~= 1 then 
			peg.y = peg.y + 16*scale
		end
	end
end

function player:keypressed(k, u)

	local x, y = math.floor(self.x/(16*scale)), math.floor(self.y/(16*scale))
	
	if self.canmove then 
		if k == playercontrols.up then
			self.upkey = true 
			self.keysdown = self.keysdown + 1
			self.movementcallback = "up"

			self.y = self.y - 16*scale

			if y > 0 then
				if self.y%gameyscroll == 0 then
					self:movecamera("up")	
				end
			end
		elseif k == playercontrols.right then
			self.rightkey = true 
			self.keysdown = self.keysdown + 1
			self.movementcallback = "right"

			self.x = self.x + 16*scale

			if self.x%love.graphics.getWidth() == 0 then
				self:movecamera("right")	
			end
		elseif k == playercontrols.down then
			self.downkey = true 
			self.keysdown = self.keysdown + 1
			self.movementcallback = "down"

			self.y = self.y + 16*scale

			if self.y%gameyscroll == 0 then
				self:movecamera("down")	
			end
		elseif k == playercontrols.left then
			self.leftkey = true
			self.keysdown = self.keysdown + 1
			self.movementcallback = "left"

			
			if x > 0 then 
				if self.x%gamexscroll == 0 then
					self:movecamera("left")	
				end
			end
			
			
			self.x = self.x - 16*scale
		end
	end

	if k == " " then
		if self.dead or levelstat == "mismatch" or levelstat == "lose" then
			self:respawn()
		end
		if self.selection then 
			objects["player"][1].canmove = true
			local x, y = self:placePeg(self.movementcallback)
			table.insert(pegs[self:setShape(self.dummyquad)], peg:new(x, y, self:setShape(self.dummyquad)))
			self.selection = false
		end
	end

	print(self.movementcallback)

	if self.selection then 
		if k == playercontrols.right then
			if self.dummyquad < 4 then 
				self.dummyquad = self.dummyquad + 1
			end
		elseif k == playercontrols.left then 
			if self.dummyquad > 1 then  
				self.dummyquad = self.dummyquad - 1
			end
		end
	end
end

function player:placePeg(dir)
	if dir == "right" then
		return self.x+16*scale, self.y
	elseif dir == "left" then
		return self.x-16*scale , self.y
	elseif dir == "up" then
		return self.x, self.y-16*scale
	elseif dir == "down" then
		return self.x, self.y+16*scale
	end
end

function player:setShape(quad)
	if quad == 1 then
		return "square"
	elseif quad == 2 then
		return "triangle"
	elseif quad == 3 then
		return "circle"
	else
		return "plus"
	end
end

function player:keyreleased(k, u)
	if k == playercontrols.up then
		self.upkey = false  
		self.keysdown = self.keysdown - 1
	elseif k == playercontrols.right then
		self.rightkey = false 
		self.keysdown = self.keysdown - 1
	elseif k == playercontrols.down then
		self.downkey = false 
		self.keysdown = self.keysdown - 1
	elseif k == playercontrols.left then
		self.leftkey = false
		self.keysdown = self.keysdown - 1
	end
end

function player:checkCamera()
	if gamexscroll + love.window.getWidth() >= (#map)*16*scale then
		gamexscroll = (#map)*16*scale - love.window.getWidth()
	end
	if gamexscroll < 16*scale then
		gamexscroll = 16*scale
	end

	if gameyscroll + love.window.getHeight() >= (#map[1])*16*scale then
		gameyscroll = (#map[1])*16*scale - love.window.getHeight()
	end
	if gameyscroll < 16*scale then
		gameyscroll = 16*scale
	end
end

function player:movecamera(dir)
	local x, y = math.floor(self.x/(16*scale)), math.floor(self.y/(16*scale))

	if mapwidth > 12 then
		if dir == "right" then
			if x%12 == 0 then
				gamexscroll = math.floor(gamexscroll + 12*16*scale)
			end
		elseif dir == "left" then
			if x%12 == 0 then
				gamexscroll = math.floor(gamexscroll - 12*16*scale)
			end
		end
	end
	if mapheight > 9 then
		if dir == "down" then
			if y%9 == 0 then
				gameyscroll = math.floor(gameyscroll + 9*16*scale)
			end
		elseif dir == "up" then
			if y%9 == 0 then
				gameyscroll = math.floor(gameyscroll - 9*16*scale)
			end
		end
	end
end

function player:respawn()
	levelstat = ""
	deaths[currentlevel] = deaths[currentlevel] + 1
	game_load(currentlevel)
end