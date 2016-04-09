function levelscreen_load(reason)
	gamestate = "levelscreen"
	love.graphics.setBackgroundColor(0, 0, 0)
	love.audio.stop(menu)

	levelscreen = {
		reason = reason,
		timer = 4,
		loadinggraphic = image("levelscreen/", "rotate.png")
	}

	winmusic = sound("", "mappack.ogg", "stream")

	rotimg = 0
	rotOffx = 0
	rotOffy = 0
	if levelscreen.reason == "gameover" then
		love.audio.stop(bgm)
	end
end

function levelscreen_draw()
	love.graphics.setColor(255, 255, 255)
	if levelscreen.reason == "gameover" then
		love.graphics.setColor(255, 255, 255)
		gameprint(gamestring("GAME OVER"), 55, 50*scale)
	elseif levelscreen.reason == "win" then
		gameprint(gamestring("CONGRATULATIONS"), 30, 60*scale)
		gameprint(gamestring("YOU"), 65, 75*scale)
		gameprint(gamestring("WON!"), 100, 75*scale)
	elseif levelscreen.reason == "editor" then
		gameprint(gamestring("Now loading the"), 30, 50*scale)
		gameprint(gamestring("level editor"), 43, 80*scale)
		gameprint(gamestring("Press 'q' for tools"), (12*9-string.len("Press 'q' for tools")*4), 132*scale, -1)
		love.graphics.draw(levelscreen.loadinggraphic, love.graphics.getWidth()-12*scale, love.graphics.getHeight()-12*scale, rotimg, rotOffX, rotOffy)
	end
end

function levelscreen_update(dt)
	levelscreen.timer = levelscreen.timer - dt

	if levelscreen.timer < 0 then
		if levelscreen.reason ~= "editor" then
			menu_load()
		else 
			editor_load()
		end
	end
end

function levelscreen_keypressed(k, u)
	if levelscreen.reason ~= "editor" then 
		if k == "return" then
			menu_load()
		end
	end
end