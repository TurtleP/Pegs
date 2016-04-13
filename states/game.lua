function gameInit()
	currentLevel = 1

	titleSong:stop()

	pegCount = 0

	if timedMode then
		countDownTimer = delayer:new()
	end

	gameLoadMap(currentLevel)
end

function gameUpdate(dt)
	if not backgroundSong:isPlaying() then
		backgroundSong:play()
	end

	for k, v in pairs(objects) do
		for j, w in pairs(v) do
			if w.update then
				w:update(dt)
			end
		end
	end

	physicsupdate(dt)

	for k = #objects["player"], 1, -1 do
		if objects["player"][k].remove then
			table.remove(objects["player"], k)
		end
	end

	for k = #objects["peg"], 1, -1 do
		if objects["peg"][k].remove then

			if objects["peg"][k].t ~= "hole" then
				gameAddPegCount(-1)
			end
			
			table.remove(objects["peg"], k)
		end
	end

	print(gameGetPegCount())
	if gameGetPegCount() == 0 then
		if not notices[1] then
			winSound:play()

			newNotice("Nice pegging!", false, function()
				gameLoadMap(currentLevel + 1)
			end)
		end
	end

	if countDownTimer then
		countDownTimer:update(dt)
	end
end

function gameDraw()
	for k, v in pairs(objects) do
		for j, w in pairs(v) do
			if w.draw then
				w:draw()
			end
		end
	end

	if countDownTimer then
		countDownTimer:draw()
	end
end

function gameKeyPressed(key)
	if not objects["player"][1] then
		return
	end

	if key == "left" then
		objects["player"][1]:moveLeft(true)
	elseif key == "right" then
		objects["player"][1]:moveRight(true)
	elseif key == "down" then
		objects["player"][1]:moveDown(true)
	elseif key == "up" then
		objects["player"][1]:moveUp(true)
	elseif key == "z" then
		objects["player"][1]:setPeg(nil)
	end
end

function gameKeyReleased(key)
	if not objects["player"][1] then
		return
	end

	if key == "left" then
		objects["player"][1]:moveLeft(false)
	elseif key == "right" then
		objects["player"][1]:moveRight(false)
	elseif key == "down" then
		objects["player"][1]:moveDown(false)
	elseif key == "up" then
		objects["player"][1]:moveUp(false)
	end
end

function gameAddPegCount(add)
	if not pegCount then
		return
	end
	
	pegCount = util.clamp(pegCount + add, 0, #objects["peg"])
end

function gameGetPegCount()
	return pegCount
end

function gameOver()
	newNotice(
		"Those don't match!", 

		false, 
		
		function()
			gameLoadMap(currentLevel)
		end
	)
end

function gameLoadMap(level)
	objects = {}

	objects["peg"] = {}
	objects["player"] = {}

	if love.filesystem.exists("maps/" .. currentMap .. "/" .. level .. ".lua") then
		local map = require("maps/" .. currentMap .. "/" .. level).layers[1].data

		for y = 1, 8 do
			for x = 1, 12 do
				local r = map[(y - 1) * 12 + x]

				if r == 2 then
					table.insert(objects["peg"], peg:new((x - 1) * 16, (y - 1) * 16, "block"))
				elseif r == 1 then
					table.insert(objects["player"], player:new((x - 1) * 16, (y - 1) * 16, #objects["player"] + 1))
				elseif r == 3 then
					table.insert(objects["peg"], peg:new((x- 1) * 16, (y - 1) * 16, "square"))
				elseif r == 6 then
					table.insert(objects["peg"], peg:new((x - 1) * 16, (y - 1) * 16, "cross"))
				elseif r == 4 then
					table.insert(objects["peg"], peg:new((x - 1) * 16, (y - 1) * 16, "triangle"))
				elseif r == 5 then
					table.insert(objects["peg"], peg:new((x - 1) * 16, (y - 1) * 16, "circle"))
				elseif r == 7 then
					table.insert(objects["peg"], peg:new((x - 1) * 16, (y - 1) * 16, "hole"))
				end
			end
		end
	end

	if countDownTimer then
		if level > 1 then
			countDownTimer:add()
		end
	end

	for x = 1, 12 do
		table.insert(objects["peg"], peg:new((x - 1) * 16, -16, "block"))
		table.insert(objects["peg"], peg:new((x - 1) * 16, util.getHeight(), "block"))
	end

	currentLevel = level
end