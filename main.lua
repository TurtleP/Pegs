function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	gamestate = "menu"

	
	currentlevel = 1
	defaultmappack = "Pegs Classic Levels"

	if love.filesystem.exists("options.txt") then
		loadconfig()
	else 
		mappack = defaultmappack
		scale = 2
		audioon = true
		maxmappacklevels = calculateMappackLevs(mappack)
	end

	versionstring = "1.1"

	changescale(scale)

	require 'states.menu'
	require 'states.game'
	require 'states.mapmenu'
	require 'states.options'
	require 'states.levelscreen'
	require 'states.editor'
	require 'states.intro'
	require 'states.credits'

	require 'classes.class'
	require 'classes.block'
	require 'classes.player'
	require 'classes.quad'
	require 'classes.peg'
	require 'classes.barrier'

	require 'values'
	require 'physics'
	require 'specialfuncs'

	mappackstable = love.filesystem.getDirectoryItems("maps/")

	--maxmappacklevels = 1

	--table.sort(mappacklevels, function(a,b) return a<b end)

	if love._version_major == nil then error("You have an outdated version of Love! Get 0.8.0 or higher and retry.") end
	
	titlescreen = image("title/", "title.png") --already calls the 'graphics/' folder 
	iconimg = love.image.newImageData("graphics/icon.png")
	buttonsimg = image("title/", "buttons.png")
	buttonhighlight = image("title/", "select.png")
	introbg = image("title/", "intro.png")
	helpimg = image("title/", "helpinstructions.png")

	buttonquads = {}
	for i = 1, 5 do
		buttonquads[i] = love.graphics.newQuad((i-1)*46, 0, 45, 13, buttonhighlight:getWidth(), buttonhighlight:getHeight())
	end

	mappackiconboundary = image("mapsmenu/", "mapicon.png")
	mappackarrow = image("mapsmenu/", "mappackarrow.png")
	mappackpage = image("mapsmenu/", "mappackpage.png")
	mappacknoicon = image("mapsmenu/", "mappacknoicon.png")
	mapsborder = image("mapsmenu/", "mapsborder.png")

	optionsrecords = image("title/", "records.png")
	lockimg = image("title/", "lock.png")
	optionsmenu = image("title/", "optionsborder.png")
	optionsdeathsrecordimg = image("title/", "deathsicon.png")

	pausemenu = image("game/", "pause.png")
	camerasnd = love.audio.newSource("sounds/snapshot.ogg", "static")
	passcodeimg = image("title/", "passcode.png")
	passcodearrowimg = image("title/", "passwordarrow.png")
	invalidpass = image("title/", "invalidpass.png")
	levelpassword = image("game/", "levelpassword.png")
	returnkey = image("title/", "returnkey.png")

	alphaglyphs = image("title/", "alphabet.png")
	alphaquads = {}
	for i = 1, 50 do
		alphaquads[i] = love.graphics.newQuad((i-1)*9, 0, 8, 9, alphaglyphs:getWidth(), alphaglyphs:getHeight())
	end

	pegsimg = image("objects/", "pegs.png")

	hitpoint = image("game/", "hitpoint.png")
	
	pegsquads = {}
	for i = 1, 4 do
		pegsquads[i] = love.graphics.newQuad((i-1)*17, 0, 16, 16, pegsimg:getWidth(), pegsimg:getHeight())
	end

	playerimg = image("objects/", "player.png")

	levelstatus = {}
	levelstatus["pitdeath"] = image("game/", "pit_death.png")
	levelstatus["win"] = image("game/", "level_finish.png")
	levelstatus["lose"] = image("game/", "level_failed.png")
	levelstatus["mismatch"] = image("game/", "peg_mismatch.png")

	love.window.setTitle("Pegs: Lua Edition")

	windowwidth = 12*16*scale 
	windowheight = 9*16*scale
	love.window.setMode(windowwidth, windowheight)

	blockquads = {}

	tilesetimg = image("objects/", "block.png")
	local tilesetdata = love.image.newImageData("graphics/objects/block.png")
	local imgwidth, imgheight = tilesetimg:getWidth(), tilesetimg:getHeight()
	local width, height = math.ceil(imgwidth/17), math.ceil(imgheight/17)

	for x = 1, width do
		for y = 1, height do
			table.insert(blockquads, quad:new(tilesetimg, tilesetdata, x, y, imgwidth, imgheight)) --Make images for all the blocks
		end
	end

	blocks = {}
	for i = 1, 2 do
		blocks[i] = love.graphics.newQuad((i-1)*17, 0, 16, 16, imgwidth, imgheight)
	end
		
	playercontrols = {
		up = "w",
		right = "d",
		down = "s",
		left = "a"
	}

	guihover = sound("", "guiselect.ogg", "static")

	creditssong = sound("", "credits.ogg", "stream")
	bgm = sound("", "pegsbgm.ogg", "stream")
	menu = sound("", "menu.ogg", "stream")

	if not love.filesystem.exists("records/") then
		--MAKE IT
		love.filesystem.createDirectory("records/")	
	end
	love.window.setIcon(iconimg)
	intro_load()
end

function checkversion()
	local http = require("socket.http")
	http.Timeout = 3
	
	local a, b, c = http.request(updatelink)
	local newdata = {}

	if a then
		msgdata = string.gsub(a, "&nbsp;", " "):split("##GAME##")

		for i = 2, #msgdata-1 do
			print(msgdata[i])
			table.insert(newdata, msgdata[i]:split(updatechar))
		end	

		for k = 1, #newdata do
			if newdata[k][1] == "Pegs" then
				return tonumber(versionstring) < tonumber(newdata[k][2]), newdata[k][2], newdata[k][3]
			end
		end
	end
end

function defaultconfig()
	changescale(2)
	mappack = defaultmappack
	audioon = true 
	maxmappacklevels = calculateMappackLevs(mappack)

	local records = love.filesystem.getDirectoryItems("records/")
	for i = #records, 1, - 1 do
		love.filesystem.remove("maps/" .. records[i])
	end
	for i = #mappackstable, 1, - 1 do
		if mappackstable[i] ~= defaultmappack then 
			love.filesystem.remove("maps/" .. mappackstable[i])
		end
	end
end

function calculateMappackLevs(mappack)
	mappacklevels = love.filesystem.getDirectoryItems("maps/" .. mappack .. "/")

	for i = #mappacklevels, 1, -1 do
		if mappacklevels[i]:find("icon") or mappacklevels[i]:find("menubackground") or mappacklevels[i]:find(".db") or mappacklevels[i]:find(".DS_Store") then
			table.remove(mappacklevels, i)
		end
	end

	return #mappacklevels
end

function saveScreenshot() --Why Not?
	love.audio.play(camerasnd)
	local osdate = string.format("screenshot-%s.png", os.date("%Y%m%d-%H%M%S"))
	if not love.filesystem.exists("/snapshots") then
		love.filesystem.createDirectory("/snapshots")
	end
	print("Snapshot saved!")
	local shot = love.graphics.newScreenshot()
	shot:encode(osdate, "png")
	local copy = love.filesystem.read(osdate)
	love.filesystem.write("/snapshots/"..osdate, copy)
	love.filesystem.remove(osdate)
end

function tablecontains(t, entry) --not mine
	for i, v in pairs(t) do
		if v == entry then
			return true
		end
	end
	return false
end

function loadconfig()
	local s = love.filesystem.read("options.txt")
		
	s1 = s:split(";")
	for i = 1, #s1-1 do
		s2 = s1[i]:split(":")
		if s2[1] == "scale" then
			scale = tonumber(s2[2])
		end
		if s2[1] == "volume" then
			if s2[2] == "true" then
				audioon = true 
			else 
				audioon = false
			end
		end
		if s2[1] == "classicpegs" then
			if s2[2] == "true" then
				pegsclassicbeaten = true 
			else 
				pegsclassicbeaten = false
			end
		end
		if s2[1] == "currentmappack" then
			mappack = s2[2]
			if love.filesystem.exists("maps/" .. mappack) then
				print("hooray!")
			else 
				print("Well, fuck you too! Setting to default pack..")
				mappack = defaultmappack
			end
			maxmappacklevels = calculateMappackLevs(mappack)
		end
	end
end

function changescale(s)
	scale = s
	windowwidth = 12*16*scale 
	windowheight = 9*16*scale
	success = love.window.setMode(windowwidth, windowheight)
	print(success)
end

function love.update(dt)
	dt = math.min(0.01666667, dt)
	if _G[gamestate .. "_update"] then
		_G[gamestate .. "_update"](dt)
	end
end

function love.draw()
	if _G[gamestate .. "_draw"] then
		_G[gamestate .. "_draw"]()
	end
end

function love.keypressed(key, unicode)
	if _G[gamestate .. "_keypressed"] then
		_G[gamestate .. "_keypressed"](key, unicode)
	end

	if key == "." then
		saveScreenshot()
	end
end 

function love.keyreleased(key, unicode)
	if _G[gamestate .. "_keyreleased"] then
		_G[gamestate .. "_keyreleased"](key, unicode)
	end
end

function string:split(delimiter) --Not by me
	local result = {}
	local from  = 1
	local delim_from, delim_to = string.find( self, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( self, from , delim_from-1 ) )
		from = delim_to + 1
		delim_from, delim_to = string.find( self, delimiter, from  )
	end
	table.insert( result, string.sub( self, from  ) )
	return result
end

function love.textinput(t)
	if gamestate == "editor" then
		editor_textinput(t)
	end
end