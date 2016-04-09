barrier = class:new()

function barrier:init(x, y, t)
	self.x = x 
	self.y = y 
	
	self.t = t

	if self.t == "ver" then
		self.height = love.window.getHeight()
		self.width = 16*scale 
	else 
		self.width = love.window.getWidth()
		self.height = 16*scale
	end
end