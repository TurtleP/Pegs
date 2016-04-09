function options_load()
	gamestate = "options"
	optionspegx = 75*scale 
	optionspegy = 27*scale
	optionsi = 1
	scalequad = 2
	optionstable = {"scale:" .. tostring(scale), "mute audio:" .. tostring(not audioon), "hard mode:" .. tostring(hardmode), "level editor", "data", "credits", "return to menu"}
	optionsstate = "main"
	levelstarty = 45*scale
	options_loadRecords(mappack)
	options_keyfocus = false
	options_keyfocustimer = .3
	optionsstart = 20*scale
	resetprompt = false
end

function options_loadRecords(mappacktoload)
	if love.filesystem.exists("records/" .. mappacktoload .. "_records.txt") then 
		local s = love.filesystem.read("records/" .. mappacktoload .. "_records.txt")
		
		s1 = s:split("\n")
		for i = 1, #s1-1 do
			s2 = s1[i]:split(";")
			s3 = s2[1]:split(":")
			s4 = s2[2]:split(":")
			if s3[1] == "deaths" then
				deaths[i] = s3[2]
			end
			if s4[1] == "time" then
				time[i] = s4[2]
			end
		end
	end
end

function updateoptionstable()
	optionstable[1] = "scale:" .. tostring(scale) 
	optionstable[2] = "mute audio:" .. tostring(not audioon)
	optionstable[3] = "hard mode:" .. tostring(hardmode)
end

function options_update(dt)
	updateoptionstable()

	if options_keyfocus then
		if options_keyfocustimer > 0 then 
			options_keyfocustimer = options_keyfocustimer - dt
		else 
			options_keyfocustimer = .3
			options_keyfocus = false
		end
	end

	if playingnow then 
		if audioon then 
			love.audio.resume(menu)
		else 
			love.audio.pause(menu)
		end
	else 
		if audioon then 
			if not playingnow then 
				playsound(menu)
				playingnow = true 
			end
		else 
			love.audio.stop(menu)
		end
	end

	if optionsstate == "main" then 
		if optionsi == 1 then
			optionspegx = 75*scale 
			optionspegy = 22*scale
		elseif optionsi == 2 then
			optionspegx = 140*scale 
			optionspegy =  48*scale
		elseif optionsi == 3 then
			optionspegx = 90*scale 
			optionspegy =  78*scale
		elseif optionsi == 4 then
			optionspegx = 50*scale 
			optionspegy =  100*scale
		end
	end

	if optionsstate == "data" then
		if optionspegy > 92*scale and (love.keyboard.isDown("s") or love.keyboard.isDown("down")) and optionsi > 1 then
			optionspegy = 48*scale
			levelstarty = levelstarty - 66*scale
		end
		if optionspegy < 27*scale and (love.keyboard.isDown("w") or love.keyboard.isDown("up")) and optionsi < maxmappacklevels then
			levelstarty = levelstarty + 66*scale
			optionspegy = 92*scale
		end
	end
end

function options_save()
	local file = love.filesystem.newFile("options.txt")

	local open = file:open("w")

	file:write("scale:" .. scale .. ";")
	file:write("volume:" .. tostring(audioon) .. ";")
	file:write("currentmappack:" .. mappack .. ";")
	if pegsclassicbeaten then 
		file:write("classicpegs:" .. tostring(pegsclassicbeaten) .. ";")
	end
end

function options_draw()
	love.graphics.draw(optionsmenu, 0, 0, 0, scale, scale)

	if optionsstate == "main" then 
		love.graphics.setColor(255, 128, 0)
		gameprint(gamestring("v" .. versionstring), 145, 128*scale)
	end

	love.graphics.setColor(255, 255, 255)
	if optionsstate == "main" then
		for i = 1, #optionstable do
			if i == optionsi then
				love.graphics.setColor(255, 0, 0)
				if (i == 1 or i == 2 or i == 3) and options_keyfocus then 
					love.graphics.setColor(0, 0, 255)
				end
			else 
				love.graphics.setColor(0, 0, 0)
			end
			gameprint(gamestring(optionstable[i]), 6, optionsstart+(i-1)*18*scale)
		end
		if resetprompt then
			gameprint(gamestring("reset all data?"),  55, 92*scale)
		end
	elseif optionsstate == "data" then
		love.graphics.draw(returnkey, 5*scale, 5*scale, 0, scale-1, scale-1)
		love.graphics.draw(optionsdeathsrecordimg, 160*scale, 15*scale, 0, scale, scale)
		love.graphics.setColor(0, 0, 0)
		gameprint(gamestring("Menu"), 35, 12*scale)
		gameprint(gamestring("Records"), 69, 25*scale)
		gameprint(gamestring(mappack), (12*9-string.len(mappack)*5.01), 125*scale)
		love.graphics.draw(passcodearrowimg, 10*scale, optionspegy, (math.pi/2), scale, scale)
		love.graphics.setColor(255, 255, 255)
		love.graphics.setScissor(15*scale, 32.5*scale, 175*scale, 77.5*scale)
		love.graphics.draw(optionsrecords, (15*scale), 55*scale, 0, scale, scale)
		love.graphics.setColor(0, 0, 0)
		for s = 1, maxmappacklevels do
			gameprint(gamestring(deaths[s] or "0"), 160, levelstarty+(s-1)*22*scale)
			gameprint(gamestring(time[s] or "0"), 84, levelstarty+(s-1)*22*scale)
			gameprint(gamestring("S"), 138, levelstarty+(s-1)*22*scale)
			gameprint({12, 5, 22, 5, 12}, 16, levelstarty+(s-1)*22*scale)
			gameprint(gamenumberstring(tostring(s)), 63, levelstarty+(s-1)*22*scale)
		end
		love.graphics.setColor(255, 255, 255)
		love.graphics.setScissor()
	end
end

function gamenumberstring(i)
	if type(i) == "string" and i then 
		local s = tostring(i)
		local newval = {}

		for t = 1, string.len(s) do
			table.insert(newval, string.sub(s, t, t))
			print(newval[t])
		end

		for j = 1, #newval do
			if newval[j] == "." then
				newval[j] = 37
			else
				if newval[j] ~= "0" then 
					newval[j] = tonumber(newval[j]) + 26
				else 
					newval[j] = 36
				end
			end
		end

		return newval
	elseif i == nil then 
		return {36}
	end
end

function gamestring(i)
	local s = string.lower(tostring(i))
	local newval = {}
	for t = 1, string.len(s) do
		table.insert(newval, string.sub(s, t, t))
	end

	for y = 1, #newval do 
		for j = 1, #alphabetstringtable do
			if newval[y] == string.lower(alphabetstringtable[j]) then
				newval[y] = j
			end
		end
	end
	return newval
end

function options_keypressed(k, u)
	if optionsstate == "main" then 
		if k == "s" or k == "down" then
			if optionsi < #optionstable then
				playsound(guihover)
				optionsi = optionsi + 1
			end
		end
		if k == "w" or k == "up" then
			if optionsi > 1 then
				playsound(guihover)
				optionsi = optionsi - 1
			end
		end

		if k == "d" or k == "right" then
			if optionsi == 1 then
				if scale < 4 then 
					changescale(scale+1)
					options_load()
				end
			end
			if optionsi == 5 then
				resetprompt = true
			end
		end

		if k == "a" or k == "left" then
			if optionsi == 1 then
				if scale > 1 then
					changescale(scale-1)
					options_load()
				end
			end
			if optionsi == 5 then
				resetprompt = false
			end
		end

		if k == " " then
			if optionsi == 2 then
				audioon = not audioon
				options_keyfocus = true
			end
			if optionsi == 3 then
				hardmode = not hardmode 
				options_keyfocus = true
			end
			if optionsi == 4 then
				levelscreen_load("editor")
			end
			if optionsi == 5 then
				if not resetprompt then 
					optionsi = 1
					optionspegy = 48*scale
					resetprompt = false
					optionsstate = "data"
				else 
					defaultconfig()
				end
			end
			if optionsi == 6 then
				credits_load()
			end
			if optionsi == 7 then
				options_save()
				menu_load(true)
			end

			if k == "escape" then
				if optionsi == 7 then
					options_save()
					menu_load(true)
				end
			end
		end
	end
	if optionsstate == "data" then
		if k == "escape" then
			optionsi = 1
			optionsstate = "main"
		end
		if k == "s" or k == "down" then
			if optionsi < maxmappacklevels then
				optionsi = optionsi + 1
				optionspegy = optionspegy + 22*scale
			end
		end
		if k == "w" or k == "up" then
			if optionsi > 1 then
				optionsi = optionsi - 1
				optionspegy = optionspegy - 22*scale
			end
		end
	end
end