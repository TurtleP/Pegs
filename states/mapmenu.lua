function mapsmenu_load()
	gamestate = "mapsmenu"
	currentpacki = 1

	mappackicon = {}

	for i = 1, #mappackstable do
		if love.filesystem.exists( "maps/" .. mappackstable[i] .. "/icon.png" ) then
			mappackicon[i] = love.graphics.newImage("maps/" .. mappackstable[i] .. "/icon.png")
		else
			mappackicon[i] = nil
		end
	end

	if mappackstable[currentpack] ~= mappack then
		--Well, this mappack isn't the one that's selected!
		for i = 1, #mappackstable do
			if mappackstable[i] == mappack then
				currentpacki = i
			else 
				currentpacki = 1 --because it might not exist if we delete it
			end
		end
	end
end

function mapsmenu_update(dt)

end

function mapsmenu_draw()
	love.graphics.draw(mapsborder, 0, 0, 0, scale, scale)
	love.graphics.setColor(0, 0, 0)

	if string.len(mappackstable[currentpacki]) < 16 then 
		gameprint(gamestring(mappackstable[currentpacki]), 24, 28*scale) --draw the mappack name!
	else 
		local temp = string.sub(mappackstable[currentpacki], 1, 13)
		temp = temp .. "..."
		gameprint(gamestring(temp), 24, 28*scale)
	end

	love.graphics.setColor(255, 255, 255)
	if currentpacki > 1 then 
		love.graphics.draw(mappackarrow, 65*scale, 115*scale, 0, scale, scale)
	end 
	if currentpacki < #mappackstable then
		love.graphics.draw(mappackarrow, 125*scale, 115*scale, 0, -scale, scale)
	end

	if mappackicon[currentpacki] ~= nil then
		if mappackicon[currentpacki]:getWidth() > 142 and mappackicon[currentpacki]:getWidth() > 73 then
			love.graphics.draw(mappacknoicon, 22.5*scale, 38*scale, 0, scale, scale)
		else
			love.graphics.draw(mappackicon[currentpacki], 23*scale, 38*scale, 0, scale, scale)
		end
	else
		love.graphics.draw(mappacknoicon, 22.5*scale, 38*scale, 0, scale, scale)
	end
end

function mapsmenu_keypressed(k, u)
	if k == "right" or k == "d" then
		if currentpacki < #mappackstable then
			playsound(guihover)
			currentpacki = currentpacki + 1
		end
	end

	if k == "left" or k == "a" then
		if currentpacki > 1 then
			playsound(guihover)
			currentpacki = currentpacki - 1
		end
	end

	if k == " " then
		mappack = mappackstable[currentpacki]
		options_save()
		menu_load(true)
	end
end