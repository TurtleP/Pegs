function titleInit()
	love.graphics.setBackgroundColor(209, 213, 216)

	titleText = "PEGS"
	copyRight = "(c) 2016 TurtleP"
	
	titleOptions =
	{
		{
			"Play Game",
			
			function()
				util.changeState("game")
			end
		},

		{
			"View Credits",

			function()
				titleState = "credits"
			end
		},

		{
			"Quit Pegs",

			love.event.quit
		}
	}

	titleObjects = {}

	spawnTimer = love.math.random(1)

	backgroundSong:stop()
	
	currentSelection = 1

	gameLoadMap(1)

	titleState = "main"

	creditsScroll = 0
end

function titleUpdate(dt)
	if not titleSong:isPlaying() then
		titleSong:play()
	end

	if spawnTimer > 0 then
		spawnTimer = spawnTimer - dt
	else
		local t = {"player", "peg"}
		local pegType = {"square", "triangle", "circle", "cross"}

		table.insert(titleObjects, {_G[t[love.math.random(#t)]]:new(love.math.random(0, util.getWidth()), -16, pegType[love.math.random(#pegType)]), love.math.random(40, 60)})

		spawnTimer = love.math.random(1)
	end

	for k, v in pairs(titleObjects) do
		local obj = v[1]

		obj.y = obj.y + v[2] * dt
	end

	if titleState == "credits" then
		creditsScroll = creditsScroll - 20 * dt
	end
end

function titleDraw()
	love.graphics.setColor(255, 255, 255, 160)

	gameDraw()
	
	local a = 1
	if titleState == "credits" then
		a = 0.5
	end

	love.graphics.setColor(255, 255, 255, 255 * a)

	for k, v in pairs(titleObjects) do
		v[1]:draw()
	end

	love.graphics.setFont(titleFont)

	love.graphics.setColor(0, 0, 0)

	for k = 1, #titleText do
		local s, add = titleText:sub(k, k), 0
		if k % 2 == 0 then
			add = 6
		end

		love.graphics.print(s, util.getWidth() / 2 + (k - 1) * 24 - titleFont:getWidth(titleText) / 2, util.getHeight() * 0.10 + add)
	end

	love.graphics.setFont(mainFont)
	love.graphics.print(copyRight, util.getWidth() / 2 - mainFont:getWidth(copyRight) / 2, util.getHeight() * .38)

	if titleState == "credits" then
		for y = 1, #credits do
			if (util.getHeight() + (y - 1) * 16) + creditsScroll + mainFont:getHeight() > util.getHeight() * .58 then
				love.graphics.print(credits[y], util.getWidth() / 2 - mainFont:getWidth(credits[y]) / 2, (util.getHeight() + (y - 1) * 16) + creditsScroll)
			end
		end
		return
	end

	for k = 1, #titleOptions do
		local v, add = titleOptions[k], 0

		if k > 1 then
			add = 16
		end

		if k == currentSelection then
			love.graphics.setColor(0, 0, 0)
			love.graphics.rectangle("fill", util.getWidth() / 2 - mainFont:getWidth(v[1]) / 2 - 1, util.getHeight() * .58 + (k - 1) * 16 - 2.5, mainFont:getWidth(v[1]), mainFont:getHeight())
			love.graphics.setColor(255, 255, 255)
		else
			love.graphics.setColor(0, 0, 0)
		end

		love.graphics.print(v[1], util.getWidth() / 2 - mainFont:getWidth(v[1]) / 2, util.getHeight() * .58 + (k - 1) * 16)
	end
end

function titleKeyPressed(key)
	if titleState == "main" then
		if key == "z" then
			titleOptions[currentSelection][2]()
		end

		if key == "`" then
			if gameBeaten then
				if not notices[1] then
					toggleTimed()

					newNotice("Timed mode: " .. tostring(timedMode))
				end
			end
		end

		if key == "up" then
			currentSelection = math.max(currentSelection - 1, 1)
		elseif key == "down" then
			currentSelection = math.min(currentSelection + 1, #titleOptions)
		end

		if key == "right" then
			titleChangeMap(1)
		elseif key == "left" then
			titleChangeMap(-1)
		end
	else
		titleState = "main"
	end
end

function titleChangeMap(add)
	local maths, max = math.min, #mapList
	if add < 0 then
		maths, max = math.max, 1
	end

	currentMapi = maths(currentMapi + add, max)
	currentMap = mapList[currentMapi]
	gameLoadMap(1)
end