function physicsupdate(dt)
	--Player vs OBJECTS
	
	if objects then
		local obj = objects["block"]
		for k, v in pairs(obj) do
			if not v.passive then
				playerCheck(v, false)
			end
		end

		voidCheck(objects["player"][1])

		for k, v in pairs(objects["barrier"]) do
			playerCheck(v, false)
		end
	end

	if pegs then
		local p = pegs 
		for k, v in pairs(pegs) do
			pegscheck(k)
		end
	end
end

function pegscheck(val) 
	for k, v in pairs(pegs[val]) do
		playerCheck(v, true)
		voidCheck(v)
	end
end

function playerCheck(v, isPeg)
	local ply = objects["player"][1]

	if aabb(ply.x, ply.y, ply.width, ply.height, v.x, v.y, v.width, v.height) then
		if ply.movementcallback == "up" then
			if not isPeg then
				ply.y = ply.y + 16*scale 
			else
				v.y = v.y - 16*scale
				v:Push("up", ply)
			end
		elseif ply.movementcallback == "down" then
			if not isPeg then
				ply.y = ply.y - 16*scale 
			else
				v.y = v.y + 16*scale
				v:Push("down", ply)
			end
		elseif ply.movementcallback == "right" then
			if not isPeg then
				ply.x = ply.x - 16*scale 
			else
				v.x = v.x + 16*scale
				v:Push("right", ply)
			end
		elseif ply.movementcallback == "left" then
			if not isPeg then
				ply.x = ply.x + 16*scale 
			else
				v.x = v.x - 16*scale
				v:Push("left", ply)
			end
		end
	end
end

function pegCheck(pegData, v, ply)
	if not ply then return end
	if aabb(pegData.x, pegData.y, pegData.width, pegData.height, v.x, v.y, v.width, v.height) then
		if pegData.movementcallback == "up" then
			pegData.y = pegData.y + 16*scale
			ply.y = ply.y + 16*scale
		elseif pegData.movementcallback == "down" then
			pegData.y = pegData.y - 16*scale
			ply.y = ply.y - 16*scale
		elseif pegData.movementcallback == "left" then
			pegData.x = pegData.x + 16*scale
			ply.x = ply.x + 16*scale
		elseif pegData.movementcallback == "right" then
			pegData.x = pegData.x - 16*scale
			ply.x = ply.x - 16*scale
		end
	end
end

function voidCheck(v)
	for k, d in pairs(objects["block"]) do
		if d.passive then
			if aabb(d.x, d.y, d.width, d.height, v.x, v.y, v.width, v.height) then
				if v.type == "player" then 
					v:die("hole")
				elseif v.type == "square" then
					d.passive = false
					v.remove = true
				end
			end
		end
	end
end

function aabb(v1x, v1y, v1width, v1height, v2x, v2y, v2width, v2height)
	local v1farx, v1fary, v2farx, v2fary = v1x + v1width, v1y + v1height, v2x + v2width, v2y + v2height
	return v1farx > v2x and v1x < v2farx and v1fary > v2y and v1y < v2fary
end