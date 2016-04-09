function intro_load()
	gamestate = "intro"

	introtimer = 5
	introimg = love.graphics.newImage("graphics/intro/introframe.png")
	introimgquads = {}
	for i = 1, 2 do
		introimgquads[i] = love.graphics.newQuad((i-1)*49, 0, 48, 80, introimg:getWidth(), introimg:getHeight())
	end

	introquadno = 1
	introanimtimer = 0
end

function intro_update(dt)

	if introtimer > 0 then
		introtimer = introtimer - dt 
	end

	introanimtimer = math.min(introanimtimer + 3*dt) 
	introquadno = math.floor(introanimtimer%2)+1

	if introtimer <= 0 then
		menu_load()
	end
end

function intro_draw()
	love.graphics.draw(introbg, 0, 0, 0, scale, scale)
	love.graphics.draw(introimg, introimgquads[introquadno], 72*scale, 60*scale, 0, scale, scale)
end

function intro_keypressed(k, u)
	introtimer = 0
end

function intro_mousepressed(x, y, b)
	introtimer =0 
end