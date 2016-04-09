function editor_load(reload)
	hasedited = false
	love.audio.stop(bgm)
	love.graphics.setBackgroundColor(255, 255, 255)
	gamestate = "editor"

	editormusic = sound("", "editor.ogg", "stream")

	if audioon then
		editormusic:setLooping(true)
		love.audio.play(editormusic)
	end

	hardmode = false
	objectholdimg = image("editor/", "objectholder.png")
	objectsimg = image("editor/", "objects.png")
	rightarrow = image("editor/", "rightarrow.png")
	returnarrow = image("editor/", "returnarrow.png")
	toolsmenu = image("editor/", "toolsmenu.png")

	objectquads = {}
	for i = 1, 7 do
		objectquads[i] = love.graphics.newQuad((i-1)*17, 0, 16, 16, objectsimg:getWidth(), objectsimg:getHeight())
	end
	objecti = 1

	objectselectx = 48.5*scale 
	nums = {"1", "2", "3", "4", "5", "6", "7"}

	objectsvisibletimer = 1
	objectgraphicimgy = 22*scale
	editorselectionarrowy = 45*scale
	guiopening = false

	map = {}
	for x = 1, 12 do
		map[x] = {}
		for y = 1, 9 do
			map[x][y] = 0
		end
	end

	properx, propery = love.mouse.getX(), love.mouse.getY()
	clickx = math.floor(properx/(16*scale))+1
	clicky = math.floor(propery/(16*scale))+1
	mapx, mapy = 16*scale, 16*scale
	toolsstate = false
	defaultmapname = " .png"
	defaultpackname = "Custom mappack"
	defaultmapnum = 1
	toolsi = 1
	mappacki = 1
	toolstable = {"Map Name:", "mappack name:", defaultpackname, "save map", "load map: " .. defaultmapnum .. ".png", mappackstable[mappacki], "test map", "exit editor"}
	underscoretimer = 0
	drawscore = true
	underscorex = 123
	underscorey = 66*scale
	keyfocus = false
	keyfocustimer = .3
	stringstart = 25
	mapwidth = #map 
	mapheight = #map[1]
	cancompilemap = true
	errorimg = image("editor/", "compileerror.png")
	errorquads = {}
	for i = 1, 2 do
		errorquads[i] = love.graphics.newQuad((i-1)*106, 0, 105, 27, errorimg:getWidth(), errorimg:getHeight())
	end
	errortimer = 0
	errorquadno = 1
	errorprompt = false
	mappack = defaultpackname
	errors = {}
	table.insert(errors, "Editor loaded!")
	objdisplaymode = "nums"
	objdisplayswitched = false 

	if objdisplaymode == "nums" then
		drawbacky = -60
	else 
		drawbacky = -25
	end

	if reload then
		editor_loadmap(reload)
	end
end

function maphasSpawn()
	for x = 1, mapwidth do
		for y = 1, mapheight do
			if map[x][y] == 7 then
				return true
			end
		end
	end
	table.insert(errors, "No player Spawn!")
	return false
end

function maphasPegs()
	local square = 0
	local circle = 0
	local triangle = 0
	local plus = 0

	for x = 1, mapwidth do
		for y = 1, mapheight do
			if map[x][y] == 3 then
				square = square + 1 
			end
			if map[x][y] == 4 then
				triangle = triangle + 1 
			end
			if map[x][y] == 5 then
				circle = circle + 1
			end
			if map[x][y] == 6 then
				plus = plus + 1
			end
		end
	end

	local existingblocks = {}

	if square%2 == 0 then
		table.insert(existingblocks, "square")
	end

	if triangle%2 == 0 then
		table.insert(existingblocks, "triangle")
	end
	
	if circle%2 == 0 then
		table.insert(existingblocks, "circle")
	end
	
	if plus%2 == 0 then
		table.insert(existingblocks, "plus")
	end

	if #existingblocks ~= 4 then
		table.insert(errors, "Pegs in map")
		table.insert(errors, "have no pairs!")
	end
	
	if square == 0 and triangle == 0 and circle == 0 and plus == 0 then
		table.insert(errors, "No pegs in map!")
		return false
	end

	return #existingblocks==4
end

function errorscreendraw()
	if errorstate then 
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 4*scale, 4*scale, love.window.getWidth()-8*scale, love.window.getHeight()-8*scale)
		love.graphics.setColor(255, 255, 255)
		gameprint(gamestring("Editor Console"), 6, 5*scale)
		for i = 1, #errors do
			gameprint(gamestring("> " .. errors[i]), 4, 15*scale+(i-1)*10*scale)
		end
		love.graphics.setColor(255, 255, 255)
	end
end

function toolsmenudraw()
	if toolsstate then
		guiopening = false 
		love.graphics.draw(toolsmenu, 4*scale, 4*scale, 0, scale, scale)
		--love.graphics.setColor(255, 255, 255)
		for i = 1, #toolstable do
			if i == toolsi then
				love.graphics.setColor(255, 0, 0)
				if (i == 2 or i == 6 or i == 7) and keyfocus then 
					love.graphics.setColor(0, 0, 255)
				end
			else 
				love.graphics.setColor(255, 255, 255)
			end
			gameprint(gamestring(toolstable[i]), 6, (stringstart*scale+(i-1)*20*scale))
		end
		love.graphics.setColor(255, 255, 255)
		if stringstart == 25 then
			gameprint(gamestring("Tools"), 76, 6*scale)
			if defaultmapnum > 1 then
				love.graphics.draw(rightarrow, 99*scale, 26*scale, 0, -scale, scale)
				love.graphics.draw(rightarrow, (149.5*scale)+(string.len(defaultmapnum)-1)*9*scale, 26*scale, 0, scale, scale)
			else 
				love.graphics.draw(rightarrow, 149.5*scale, 26*scale, 0, scale, scale)
			end
			gameprint(gamestring(tostring(defaultmapnum)), 104, 25*scale)
			gameprint(gamestring(defaultmapname), (104)+(string.len(defaultmapnum)-1)*9, 25*scale)
			love.graphics.draw(returnarrow, 134*scale, 45*scale, 0, scale, scale)
			if drawscore then
				gameprint(gamestring("_"), underscorex, underscorey)
			end
		end
	end
end

function editor_draw()
	toolsmenudraw()
	errorscreendraw()

	love.graphics.translate(-mapx, -mapy)

	if not toolsstate and not errorstate then
		for x = 1, #map do
			for y = 1, #map[1] do
				if map[x][y] ~= 0 and map[x][y] ~= nil then
					love.graphics.draw(objectsimg, objectquads[map[x][y]], (x*16*scale), (y*16*scale), 0, scale, scale)
				end
			end
		end
	end

	if not toolsstate and not errorstate then 
		for i = 1, 7 do
			love.graphics.draw(objectholdimg, 37.5*scale+(i-1)*22*scale, objectgraphicimgy, 0, scale, scale)
			love.graphics.draw(objectsimg, objectquads[i], 37.5*scale+(i-1)*22*scale, objectgraphicimgy, 0, scale, scale)
		end

		love.graphics.setColor(0, 0, 0)
		if objdisplaymode == "advanced" then 
			love.graphics.draw(passcodearrowimg, objectselectx, editorselectionarrowy, math.pi, scale, -scale)
		else 
			for i = 1, 7 do
				gameprint(gamestring(tostring(i)), 42+(i-1)*22, (objectgraphicimgy+85))
			end
		end
		love.graphics.setColor(255, 255, 255)

		love.graphics.draw(objectsimg, objectquads[objecti], (clickx * (16*scale)), (clicky * (16*scale)), 0, scale, scale)
	end 

	if cancompilemap == false then
		love.graphics.draw(errorimg, errorquads[errorquadno], 16*scale, 16*scale, 0, scale, scale)
	end
end

function place_tile(x, y)
	map[x][y] = objecti
end

function erase_tile(x, y)
	map[x][y] = 0
end

function editor_update(dt)
	if #errors > 7 then
		errors = {}
	end
	
	if not objdisplayswitched then
		objdisplaymode = "nums"
	else 
		objdisplaymode = "advanced"
	end
	
	if objdisplaymode == "nums" then
		drawbacky = -60
	else 
		drawbacky = -50
	end

	properx, propery = love.mouse.getX()+mapx, love.mouse.getY()+mapy
	clickx = math.floor(properx/(16*scale))
	clicky = math.floor(propery/(16*scale))

	if not errorstate and not toolsstate then 
		if love.mouse.isDown("l") then
			place_tile(clickx, clicky)	
		elseif love.mouse.isDown("r") then
			erase_tile(clickx, clicky)
		end
	end
	
	if toolsstate then
		if toolsi == 2 and keyfocus then
			underscoretimer = underscoretimer + dt 

			local t = math.floor(underscoretimer)

			if t%2 == 0 then
				drawscore = false 
			else 
				drawscore = true 
			end
		else 
			drawscore = false
		end

		toolstable[3] = defaultpackname
		toolstable[6] = mappackstable[mappacki]
	end

	if keyfocus and toolsi ~= 2 then
		if keyfocustimer > 0 then 
			keyfocustimer = keyfocustimer - dt
		else 
			keyfocustimer = .3
			keyfocus = false
		end
	end

	objectselectx = 48.5*scale+(objecti-1)*22*scale

	if not guiopening then 
		if objectsvisibletimer <= 0 then
			objectsvisibletimer = 0
			if objectgraphicimgy > drawbacky then
				objectgraphicimgy = objectgraphicimgy - 70*dt
				editorselectionarrowy = editorselectionarrowy - 70*dt
			end
		end
	else
		if objectgraphicimgy < 22*scale then
			objectsvisibletimer = 1.5
			objectgraphicimgy = objectgraphicimgy + 70*dt
			editorselectionarrowy = editorselectionarrowy + 70*dt
		end
	end

	if objectsvisibletimer > 0 then
		objectsvisibletimer = objectsvisibletimer - dt 
	elseif objectsvisibletimer < 0 then
		if guiopening then
			guiopening = false
		end
	end

	editor_updatemap()

	if not cancompilemap then
		errortimer = math.min(errortimer+8*dt)
		errorquadno = math.floor(errortimer%2)+1
	end

	if errortimer > 20 then
		cancompilemap = true
		errortimer = 0
	end
end

function editor_test()
	hasedited = true
	love.audio.stop(editormusic)
	game_load(tostring(defaultmapnum))
end

function editor_save()
	if not love.filesystem.exists("maps/" .. defaultpackname) then
		love.filesystem.createDirectory("maps/" .. defaultpackname)
	end

	local newmap = love.image.newImageData(#map , #map[1])
	local encodedmap = {}

	for x = 1, #map do --RESET THE MAP TO BE COMPLETELY BLANK
		for y = 1, #map[1] do
			newmap:setPixel(x-1,y-1,255,255,255,0)
		end
	end

	for x = 1, #map do --LET'S PLACE PIXELS
		for y = 1, #map[1] do
			if map[x][y] == 1 then 
				newmap:setPixel(x-1, y-1,255,255,255,255)
			end
			if map[x][y] == 2 then 
				newmap:setPixel(x-1, y-1, 0, 0, 0, 255)
			end
			if map[x][y] == 3 then 
				newmap:setPixel(x-1, y-1, 255, 106, 0, 255)
			end
			if map[x][y] == 4 then 
				newmap:setPixel(x-1, y-1, 255, 216, 0, 255)
			end
			if map[x][y] == 5 then 
				newmap:setPixel(x-1, y-1, 0, 255, 0, 255)
			end
			if map[x][y] == 6 then 
				newmap:setPixel(x-1, y-1, 0, 0, 255, 255)
			end
			if map[x][y] == 7 then 
				newmap:setPixel(x-1, y-1, 255, 0, 0, 255)
			end
		end
	end

	mappack = defaultpackname
	newmap:encode(defaultmapnum .. ".png", "png")
	local imagedata = love.filesystem.read(defaultmapnum .. ".png")
	love.filesystem.write("maps/" .. defaultpackname .. "/" .. defaultmapnum .. ".png", imagedata)
	love.filesystem.remove(defaultmapnum .. ".png")

	print("Map " .. defaultmapnum .. ".png" .. " saved successfully!")
end

function editor_loadmap(n)

	if n then
		defaultmapnum = n
	end
	--table[index] of mappacks to show, mappacks[mappacki]
	--level to load is based on the selection from toolsi == 1
	local maptoload = "maps/" .. mappackstable[mappacki] .. "/" .. defaultmapnum .. ".png"
	local mapimage = love.image.newImageData(maptoload)
	mapwidth = mapimage:getWidth()
	mapheight = mapimage:getHeight()

		for x = 1, mapwidth do
			map[x] = {}
			for y = 1, mapheight do
				map[x][y] = 0
				local r, g, b, a = mapimage:getPixel(x-1, y-1)
				if r == 255 and g == 255 and b == 255 and a == 255 then
					map[x][y] = 1
				end
				if r == 0 and g == 0 and b == 0 and a == 255 then
					map[x][y] = 2
				end
				if r == 255 and g == 0 and b == 0 then
					map[x][y] = 7
				end
				if r == 255 and g == 106 and b == 0 and a == 255 then
					map[x][y] = 3
				end
				if r == 255 and g == 216 and b == 0 and a == 255 then
					map[x][y] = 4
				end
				if r == 0 and g == 255 and b == 0 and a == 255 then
					map[x][y] = 5
				end
				if r == 0 and g == 0 and b == 255 and a == 255 then
					map[x][y] = 6
				end
			end
		end
	mappack = mappackstable[mappacki]
end

function editor_exit()
	love.audio.stop(editormusic)
	menu_load()
end

function editor_updatemap()
	if mapwidth ~= #map or mapheight ~= #map[1]then
		if #map > mapwidth then
			for x = #map, mapwidth,  -1 do
				table.remove(map, x)
			end
		end        
		for x = 1, mapwidth do
			--Only make a new block if one doesnt exist.
			if not map[x] then
				map[x] = {}
			end
			for y = 1, mapheight do
				if not map[x][y] then
					map[x][y] = 0
				end
			end
		end
	end
end

function editor_keypressed(k, u)
	for i = 1, #nums do
		if k == nums[i] then
			objecti = tonumber(nums[i])
			if not guiopening then 
				guiopening = true
			end
		end
	end

	if k == "q" then
		toolsstate = not toolsstate
	end

	if not toolsstate then 
		if k == "lctrl" then
			objdisplayswitched = not objdisplayswitched
		end
	end
	
	if k == " " then
		if toolsstate then
			if toolsi == 2 or i == 7 then
				keyfocus = not keyfocus
			end
			if toolsi == 4 then
				if maphasSpawn() and maphasPegs() then
					editor_save()
				else 
					cancompilemap = false
				end
			end
			if toolsi == 5 then
				editor_loadmap()
			end
			if toolsi == 7 then
				editor_test()
			end
			if toolsi == 8 then
				editor_exit()
			end
		end
	end

	if k == "`" then
		errorstate = not errorstate	
	end

	if toolsstate then
		if not keyfocus then 
			if k == "right" or k == "d" then
				if toolsi == 1 then
					defaultmapnum = defaultmapnum + 1
				end
				if toolsi == 6 then
					if mappacki < #mappackstable then
						mappacki = mappacki + 1
					end
				end
			end
			if k == "left" or k == "a" then
				if toolsi == 1 then
					if defaultmapnum > 1 then 
						defaultmapnum = defaultmapnum - 1
					end
				end
				if toolsi == 6 then
					if mappacki > 1 then
						mappacki = mappacki - 1
					end
				end
			end
			if k == "down" or k == "s" then
				if toolsi < #toolstable then
					toolsi = toolsi + 1
					if toolsi == 3 then
						toolsi = 4
					end
					if toolsi%6 == 1 and stringstart == 25 then
						stringstart = stringstart - 135
					end
				end
			end
			if k == "up" or k == "w" then
				if toolsi > 1 then
					toolsi = toolsi - 1
					if toolsi == 3 then
						toolsi = 2
					end
					if toolsi == 6 and stringstart == -110 then
						stringstart = stringstart + 135
						toolsi = 6
					end
				end
			end
		end
		if k == "backspace" then
			if toolsi == 2 and keyfocus then
				if string.len(defaultpackname) > 0 then 
					defaultpackname = string.sub(defaultpackname, 1, -2)
				end
				if string.len(defaultpackname) > 0 then
					underscorex = underscorex - 9
				end
			end
		end
	end
end

function editor_textinput(t)
	if toolsi == 2 and keyfocus then
		if string.len(defaultpackname) < 18 then
			if tablecontains(alphabetstringtable, string.upper(t)) then
				defaultpackname = defaultpackname .. t
				underscorex = underscorex + 9
			end
		end
	end
end