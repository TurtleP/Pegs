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

function tablecontains(t, entry)
	for i, v in pairs(t) do
		if v == entry then
			return true
		end
	end
	return false
end

function gprint(text, x, y)
	love.graphics.print(text, x*scale, y*scale)
end

function image(folder, img)
	if love.filesystem.exists("graphics/" .. folder .. img) then
		return love.graphics.newImage("graphics/" .. folder .. img)
	else
		print("Warning! Image '" .. img .. "' in folder '" .. folder .. "' does not exist!")
	end
end

function newquad(t, max, x, y, w, h, img)
	if t == "table" then
		if max then
			for i = 1, max do
				return love.graphics.newQuad((i-1)*x, y, w, h, img:getWidth(), img:getHeight())
			end
		else
			print("Warning! No max value for quad table has been set!")
		end
	else 
		print("Well, fuck you. You don't need it for anything other than tables, really.")
	end
end

function sound(folder, sound, type)
	if love.filesystem.exists("sounds/" .. folder .. sound) then
		return love.audio.newSource("sounds/" .. folder .. sound, type)
	else
		print("Warning! Audio '" .. sound .. "' in folder '" .. folder .. "' does not exist!")
	end
end

function drawimage(img, x, y, rot, scalar, scalar2, offX, offY)
	if img then 
		love.graphics.draw(img, x, y, rot, scalar, scalar2, offX, offY)
	else 
		print("Warning! Missing image file for drawing operation of " .. img)
	end
end

function drawrectangle(style, x, y, width, height)
	love.graphics.rectangle(style, x*scale, y*scale, width*scale, height*scale)
end

function playsound(sound)
	if audioon and sound then
		love.audio.stop(sound)
		sound:rewind()
		sound:play()
	end
end