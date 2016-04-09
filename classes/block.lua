block = class:new()

function block:init(x, y, passive, type)
	self.x = x 
	self.y = y
	self.width = 16*scale 
	self.height = 16*scale 
	
	self.passive = passive 

	if not passive then
		self.quad = 1
	else
		self.quad = 2
	end
	self.graphic = tilesetimg
	self.remove = false
end

function block:update(dt)
	if self.passive == false then
		self.quad = 1
		--self.active = true 
		self.mask = {"all"}
	else 
		self.quad = 2
		self.active = false
		self.mask = {}
	end
end

function block:draw()
	if self.graphic then 
		love.graphics.draw(self.graphic, blocks[self.quad], self.x, self.y, 0, scale, scale)
	end
end