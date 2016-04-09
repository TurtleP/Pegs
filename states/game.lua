function game_load(level, folder)
	gamestate = "game"

	game_Setup(level, folder)

	if suspended then
		love.filesystem.remove("suspend-" .. mappack .. "-" .. suspendid .. ".png")
	end
end

function game_Setup(level, folder)
	game_maketables()

	gamexscroll = 16*scale
	gameyscroll = 16*scale

	blockBatch = love.graphics.newSpriteBatch(tilesetimg, 1000)

	mapwidth = 0
	mapheight = 0
	pauseprompt = false 
	pauseoptions = {"resume", "suspend", "restart", "menu"}
	levelstat = ""
	pausei = 1
	selectionx = 128*scale+32
	selectiony = 58*scale+32

	local num = level
	if suspendid then
		num = suspendid
	end

	currentlevel = tonumber(num)
	game_formmap(level .. ".png", folder)

	playsound(bgm)bgm:setLooping(true)
	love.graphics.setLineStyle("rough")
end

function game_saveRecords()
	local f = love.filesystem.newFile("records/" .. mappack .. "_records.txt")
	local o = f:open("w")
	for i = 1, maxmappacklevels do
		f:write("deaths:" .. tostring(deaths[i]) .. ";")
		f:write("time:" .. tostring(time[i]) .. ";\n")
	end
end

function gameprint(tableau, x, y, scalar, color) --dat table
	local s 
	if scalar then 
		s = (scale + scalar)
	else 
		s = scale
	end
	
	if type(tableau) == "table" then
		for i = 1, #tableau do
			love.graphics.draw(alphaglyphs, alphaquads[tableau[i]], x*scale+(i-1)*9*s, y, 0, s, s)
		end
	else
		print("Go fuck yourself")
	end
end	

function game_suspend()
	local newmap = love.image.newImageData(mapwidth , mapheight)
	local encodedmap = {}

	for x = 1, mapwidth do --RESET THE MAP TO BE COMPLETELY BLANK
		for y = 1, mapheight do
			newmap:setPixel(x-1,y-1,255,255,255,0)
		end
	end

	for x = 1, mapwidth do --LET'S PLACE PIXELS
		for y = 1, mapheight do
			for i, v in pairs(objects["block"]) do
				if math.floor(v.x/(16*scale)) == x and math.floor(v.y/(16*scale)) == y then
					if v.passive == false then
						newmap:setPixel(x-1, y-1,255,255,255,255)
					else 
						newmap:setPixel(x-1, y-1, 0, 0, 0, 255)
					end
				end
			end
			if math.floor(objects["player"][1].x/(16*scale)) == x and math.floor(objects["player"][1].y/(16*scale)) == y then 
				newmap:setPixel(x-1, y-1, 255, 0, 0, 255)
			end
			for i, v in pairs(pegs["square"]) do
				if math.floor(v.x/(16*scale)) == x and math.floor(v.y/(16*scale)) == y then
					newmap:setPixel(x-1, y-1, 255, 106, 0, 255)
				end
			end
			for i, v in pairs(pegs["triangle"]) do
				if math.floor(v.x/(16*scale)) == x and math.floor(v.y/(16*scale)) == y then
					newmap:setPixel(x-1, y-1, 255, 216, 0, 255)
				end
			end
			for i, v in pairs(pegs["circle"]) do
				if math.floor(v.x/(16*scale)) == x and math.floor(v.y/(16*scale)) == y then
					newmap:setPixel(x-1, y-1, 0, 255, 0, 255)
				end
			end
			for i, v in pairs(pegs["plus"]) do
				if math.floor(v.x/(16*scale)) == x and math.floor(v.y/(16*scale)) == y then
					newmap:setPixel(x-1, y-1, 0, 0, 255, 255)
				end
			end
		end
	end

	newmap:encode("suspend-" .. mappack .. "-" .. currentlevel .. ".png", "png")

	print("Map has been saved!")
	love.audio.stop(bgm)
	menu_load(false)
end

function inMap(x, y)
	if map[x][y] ~= nil and type(map[x][y]) == "string" and map[x][y] ~= "" and map[x][y] then
		return true 
	else 
		print("NOPES")
	end
end

function inMapBlocks(x, y)
	if map[x][y] ~= nil and map[x][y] ~= 0 then
		return true 
	else 
		return
	end
end

function minusLife()
	if not hardmode then
		return 
	end

	if lives > 0 then
		lives = math.max(lives - 1, 0)
	else 
		levelscreen_load("gameover")
	end
end

function game_update(dt)
	if not pauseprompt then 
		objects["player"][1]:update(dt)

		for i, v in pairs(objects["block"]) do
			v:update(dt)
		end

		for i, v in pairs(pegs) do
			for j, w in pairs(v) do
				w:update(dt)
			end
		end

		physicsupdate(dt)

		game_remove_objects()
	end


	if pausei == 1 then
		selectionx = 128*scale+32
		selectiony = 58*scale+32
		selectionx2 = selectionx - 60*scale
	elseif pausei == 2 then
		selectionx = 124*scale+32
		selectiony = 76.5*scale+32
		selectionx2 = selectionx - 52*scale
	elseif pausei == 3 then 
		selectionx = 135.5*scale+32
		selectiony = 94.5*scale+32
		selectionx2 = selectionx - 76.5*scale
	else 
		selectionx = 134*scale+32
		selectiony = 113.5*scale+32
		selectionx2 = selectionx - 72*scale
	end

	totalpegs = #pegs["square"] + #pegs["circle"] + #pegs["triangle"] + #pegs["plus"]

	if levelstat ~= "win" then --absurdity
		time[currentlevel] = time[currentlevel] + dt
	else 
		time[currentlevel] = string.sub(time[currentlevel], 1, 5)
	end

	if not objects["player"][1].selection then
		if totalpegs == 0 then
			levelstat = "win"
			objects["player"][1].canmove = false
		end
	end
end

function game_remove_objects()
	for i = #objects["block"], 1, -1 do
		if objects["block"][i].remove == true then
			table.remove(objects["block"], i)
		end
	end

	for i = #pegs["square"], 1, -1 do
		if pegs["square"][i].remove == true then
			table.remove(pegs["square"], i)
		end
	end

	for i = #pegs["plus"], 1, -1 do
		if pegs["plus"][i].remove == true then
			table.remove(pegs["plus"], i)
		end
	end

	for i = #pegs["circle"], 1, -1 do
		if pegs["circle"][i].remove == true then
			table.remove(pegs["circle"], i)
		end
	end

	for i = #pegs["triangle"], 1, -1 do
		if pegs["triangle"][i].remove == true then
			table.remove(pegs["triangle"], i)
		end
	end
end

function game_draw_status()
	if levelstatus[levelstat] then
		drawimage(levelstatus[levelstat], 0*scale, love.window.getHeight()-levelstatus[levelstat]:getHeight()*scale, 0, scale, scale)
	end
end

function game_draw()
	love.graphics.push()
	love.graphics.translate(-gamexscroll, -gameyscroll)

	for i, v in pairs(objects["player"]) do
		v:draw()
	end 

	for i, v in pairs(objects["block"]) do
		v:draw()
	end 

	for i, v in pairs(pegs) do
		for j, w in pairs(v) do
			w:draw()
		end
	end

	love.graphics.pop()

	game_draw_status()

	if hardmode then
		for k = 1, lives do
			love.graphics.draw(hitpoint, (love.window.getWidth()-45*scale)+(k-1)*16*scale, 3*scale, 0, scale, scale)
		end
	end
	
	if pauseprompt then
		love.graphics.draw(pausemenu, love.window.getWidth()/2-(pausemenu:getWidth()*scale)/2, love.window.getHeight()/2-(pausemenu:getHeight()*scale)/2, 0, scale, scale)

		local x, y = love.window.getWidth()/2-(pausemenu:getWidth()*scale)/2, love.window.getHeight()/2-(pausemenu:getHeight()*scale)/2

		if pausei == 1 then
			love.graphics.rectangle("line", x+(16*scale), y+(29*scale), 52*scale, 1)
		elseif pausei == 2 then
			love.graphics.rectangle("line", x+(20*scale), y+(47*scale), 46*scale, 1)
		elseif pausei == 3 then
			love.graphics.rectangle("line", x+(6*scale), y+(65*scale), 73*scale, 1)
		elseif pausei == 4 then
			love.graphics.rectangle("line", x+(12*scale), y+(83*scale), 62*scale, 1)
		end

		if mappack == "Pegs Classic Levels" then
			--love.graphics.draw(levelpassword, love.window.getWidth()/2-(levelpassword:getWidth()*scale)/2, love.window.getHeight()/2+(pausemenu:getHeight()*scale)/2+4*scale, 0, scale, scale)
		
			love.graphics.setColor(0, 0, 0)
			love.graphics.rectangle("fill", love.window.getWidth()/2-(90*scale)/2, love.window.getHeight()/2+(pausemenu:getHeight()*scale)/2+4*scale, 90*scale, 13*scale)
			love.graphics.setColor(255, 255, 255)
			gameprint(gamestring("Pass: " .. passwords[currentlevel]), (love.window.getWidth()/2-(86*scale)/2)/scale, love.window.getHeight()/2+(pausemenu:getHeight()*scale)/2+6*scale)
		end
	end
end

function game_maketables()
	objects = {}

	objects["block"] = {}
	objects["player"] = {}
	objects["barrier"] = {}	

	pegs = {}
	pegs["square"] = {}
	pegs["circle"] = {}
	pegs["triangle"] = {}
	pegs["plus"] = {}
end

function game_formmap(level, folder)
	local temp = level
	if string.sub(temp, -4, -1) == ".png" then
		print("MY GOD! IT'S WORKING!")
		game_level = love.image.newImageData("maps/" .. mappack .. "/" .. level)

		map = {} 

		mapwidth = game_level:getWidth()
		mapheight = game_level:getHeight()

		for x = 1, game_level:getWidth() do
			map[x] = {}
			for y = 1, game_level:getHeight() do
				map[x][y] = 0
				local r, g, b, a = game_level:getPixel(x-1, y-1)
				if r == 255 and g == 255 and b == 255 and a == 255 then
					map[x][y] = 1
					table.insert(objects["block"], block:new(x*(16*scale), y*(16*scale), false, "solid"))
				end
				if r == 0 and g == 0 and b == 0 and a == 255 then
					map[x][y] = 2
					table.insert(objects["block"], block:new(x*(16*scale), y*(16*scale), true, "pass"))
				end
				if r == 255 and g == 0 and b == 0 then
					startx = x*16*scale
					starty = y*16*scale 
					objects["player"][1] = player:new(startx, starty)
				end
				if r == 255 and g == 106 and b == 0 and a == 255 then
					map[x][y] = 3
					table.insert(pegs["square"], peg:new(x*16*scale, y*16*scale, "square"))
				end
				if r == 255 and g == 216 and b == 0 and a == 255 then
					map[x][y] = 4
					table.insert(pegs["triangle"], peg:new(x*16*scale, y*16*scale, "triangle"))
				end
				if r == 0 and g == 255 and b == 0 and a == 255 then
					map[x][y] = 5
					table.insert(pegs["circle"], peg:new(x*16*scale, y*16*scale, "circle"))
					end
				if r == 0 and g == 0 and b == 255 and a == 255 then
					map[x][y] = 6
					table.insert(pegs["plus"], peg:new(x*16*scale, y*16*scale, "plus"))
				end
			end
		end

		objects["barrier"][1] = barrier:new(-(8*scale), 0, "ver")
		objects["barrier"][2] = barrier:new((game_level:getWidth()+1)*16*scale, 0, "ver")

		objects["barrier"][3] = barrier:new(0, -(8*scale), "hor")
		objects["barrier"][4] = barrier:new(0, (game_level:getHeight()+1)*16*scale, "hor")
	end
end

function game_nextlevel()
	if not hasedited then 
		if currentlevel < maxmappacklevels then 
			currentlevel = currentlevel + 1
			love.audio.stop(bgm);bgm:setLooping(false)
			print("THE FUCK WHY DO YOU CALL ME?")
			game_saveRecords()
			game_load(currentlevel)
		elseif currentlevel >= maxmappacklevels then
			love.audio.stop(bgm);bgm:setLooping(false)
			game_saveRecords()
			options_save()
			levelscreen_load("win")
		end
	else 
		editor_load()
	end
end

function game_keypressed(k, u)
	if not pauseprompt then 
		objects["player"][1]:keypressed(k, u)
	end

	if levelstat == "win" then
		if k == " " then
			game_nextlevel()
			levelstat = ""
		end
	end

	if k == "escape" and levelstat == "" then
		if not hasedited then 
			pauseprompt = not pauseprompt
		else 
			editor_load(currentlevel)
		end
	end

	if pauseprompt then
		love.audio.pause(bgm)
	else 
		love.audio.resume(bgm)
	end
	
	if pauseprompt then
		if k == "s" or k == "down" then
			if pausei < #pauseoptions then 
				playsound(guihover)
				pausei = pausei + 1
			end 
		end
		if k == "w" or k == "up" then
			if pausei > 1 then 
				playsound(guihover)
				pausei = pausei - 1
			end 
		end
		if k == " " then
			if pausei == 1 then 
				pauseprompt = false 
			end
			if pausei == 2 then 
				game_suspend()
			end
			if pausei == 3 then
				love.audio.stop(bgm);bgm:setLooping(false)
				game_load(currentlevel)
			end
			if pausei == 4 then
				menu_load(false)
			end
		end 
	end
end

function game_keyreleased(k, u)
	objects["player"][1]:keyreleased(k, u)
end