function menu_load(alreadyplaying)
	love.audio.stop(creditssong)
	gamestate = "menu"
	selectioni = 1
	selections = {"play", "options", "maps", "help", "quit"}
	selectionbuttonx = 11*scale
	selectionbuttony = 130*scale
	selectionwidth = 30
	helpprompt = false
	passcode = {0, 0, 0, 0}
	passcodei = 1
	passcodearrowx = 45*scale 
	passcodearrowy = 75*scale
	invalidcode = false
	flashtimer = 0
	pass = false
	passcodeprompt = false

	deaths = {}
	time = {}
	lives = 3
	 
	print(maxmappacklevels)
	for i = 1, maxmappacklevels do
		deaths[i] = 0
		time[i] = 0
	end

	if audioon then 
		playingnow = alreadyplaying

		if not playingnow then 
			playsound(menu);menu:setLooping(true)
			playingnow = true
		end
	end

	files = love.filesystem.getDirectoryItems("")

	suspended = false
	for i = 1, #files do
		if files[i]:sub(-4, -1) == ".png" then
			filenum = files[i]:split("-")
			mappack = filenum[2]
			suspendid = filenum[3]:gsub(".png", "")
			suspended = true
		end
	end

	initialimgtimer = 0
	opacity = 255
	opacity2 = 0

	game_Setup("1")
	love.audio.stop(bgm)
end

function menu_update(dt)
	if selectioni == 1 then
		selectionbuttonx = 10*scale
	elseif selectioni == 2 then
		selectionbuttonx = 43*scale
	elseif selectioni == 3 then
		selectionbuttonx = 73*scale
	elseif selectioni == 4 then
		selectionbuttonx = 119*scale
	else
		selectionbuttonx = 158*scale
	end

	if passcodei == 1 then
		passcodearrowx = 45*scale 
		passcodearrowy = 75*scale
	elseif passcodei == 2 then
		passcodearrowx = 77.5*scale 
		passcodearrowy = 75*scale
	elseif passcodei == 3 then
		passcodearrowx = 111*scale 
		passcodearrowy = 75*scale
	else 
		passcodearrowx = 144*scale 
		passcodearrowy = 75*scale
	end

	if passcodeprompt then
		if invalidcode then
			flashtimer = flashtimer + 2*dt 
		end
	end

	initialimgtimer = initialimgtimer + dt 
	if initialimgtimer > 1 and opacity > 0 then
		opacity = math.max(0, opacity-dt*120)
	end
end

function menu_draw()
	if passcodeprompt then
		love.graphics.draw(passcodeimg, 0, 0, 0, scale, scale)
			--draw the fucking god damn glyphs, biatch
		if passcode[1] > 0 then 
			love.graphics.draw(alphaglyphs, alphaquads[passcode[1]], 43*scale, 62*scale, 0, scale, scale)
		end
		if passcode[2] > 0 then 
			love.graphics.draw(alphaglyphs, alphaquads[passcode[2]], 75*scale, 62*scale, 0, scale, scale)
		end
		if passcode[3] > 0 then 
			love.graphics.draw(alphaglyphs, alphaquads[passcode[3]], 108*scale, 62*scale, 0, scale, scale)
		end
		if passcode[4] > 0 then 
			love.graphics.draw(alphaglyphs, alphaquads[passcode[4]], 141*scale, 62*scale, 0, scale, scale)
		end
		love.graphics.draw(passcodearrowimg, passcodearrowx, passcodearrowy, 0, scale, scale)

		if invalidcode then
			local shoulddraw = math.floor(flashtimer%2)
		
			if shoulddraw == 1 then
				love.graphics.setColor(0, 0, 0)
				love.graphics.rectangle("fill", 65*scale, 94*scale, 60*scale, 11*scale)
				love.graphics.setColor(255, 255, 255)
			else	
				love.graphics.draw(invalidpass, 65*scale, 95*scale, 0, scale, scale)
			end

			if flashtimer > 10 then
				invalidcode = false 
				flashtimer = 0
			end
		end
	end

	if not passcodeprompt then 
		love.graphics.setBackgroundColor(255, 255, 255)

		love.graphics.setColor(255, 255, 255)
		game_draw()

		love.graphics.setColor(255, 255, 255, opacity)
		drawimage(titlescreen, 0, 0, 0, scale, scale)

		love.graphics.setColor(255, 255, 255)
		if love.filesystem.exists("suspend.png") then
			love.graphics.draw(mappackarrow, 8*scale, 131*scale, math.pi/2, scale, scale)
		end
		love.graphics.rectangle("fill", 0, love.window.getHeight()-16*scale, love.window.getWidth(), 16*scale)
		drawimage(buttonsimg, 12*scale, 131*scale, 0, scale, scale)
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(buttonhighlight, buttonquads[selectioni], selectionbuttonx, 130*scale, 0, scale, scale)
		if helpprompt then
			love.graphics.draw(helpimg, 22*scale, 52*scale, 0, scale, scale)
		end
	end
end

function menu_keypressed(k, u)
	if not helpprompt then
		if k == "right" or k == "d" then
			if not passcodeprompt then 
				if selectioni < #selections then 
					playsound(guihover)
					selectioni = selectioni + 1
				end
			else 
				if passcodei < 4 then
					passcodei = passcodei + 1
				end
			end
		end
		
		if k == "left" or k == "a" then
			if not passcodeprompt then 
				if selectioni > 1 then
					playsound(guihover)
					selectioni = selectioni - 1
				end
			else 
				if passcodei > 1 then 
					passcodei = passcodei - 1
				end
			end
		end
	end

	if k == "up" or k == "w" then
		if passcodeprompt then
			if passcode[passcodei] < 26 then 
				passcode[passcodei] = passcode[passcodei] + 1
			end
		end
	end

	if k == "down" or k == "s" then
		if passcodeprompt then
			if passcode[passcodei] > 0 then 
				passcode[passcodei] = passcode[passcodei] - 1
			end
		end
	end

	if k == "`" then
		if mappack == "Pegs Classic Levels" then
			passcodeprompt = not passcodeprompt 
		end
	end

	if k == " " then
		if not passcodeprompt then 
			if selectioni == 1 then
				love.audio.stop(menu);menu:setLooping(false)
				if not suspended then 
					game_load("1")
				else 
					print("Loading level")
					game_load("suspend-" .. suspendid, mappack)
				end
			elseif selectioni == 2 then
				helpprompt = not helpprompt 
			elseif selectioni == 3 then
				options_load()
			elseif selectioni == 4 then
				mapsmenu_load()
			else 
				love.event.push("quit")
			end
		else 
			for i = 1, 4 do
				for j = 1, #passwords do 
					if passcode[i] == gamestring(passwords[j])[i] then
						if not pass then 
							game_load(tostring(j))
							pass = true 
						end
					else 
						invalidcode = true 
					end
				end
			end
		end
	end
end