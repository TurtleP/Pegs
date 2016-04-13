local util = {}

--[[
	util.lua

	Useful Tool in Love

	TurtleP

	v2.0
--]]

function util.changeScale(scalar)
	scale = scalar

	love.window.setMode(love.graphics.getWidth() * scalar, love.graphics.getHeight() * scalar)
end

function util.createFonts()
	titleFont = love.graphics.newFont("graphics/PressStart2P.ttf", 24)
	mainFont = love.graphics.newFont("graphics/PressStart2P.ttf", 8)
end

function util.changeState(toState)
	state = toState

	if _G[toState .. "Init"] then
		_G[toState .. "Init"]()
	end
end

function util.updateState(dt)
	if _G[state .. "Update"] then
		_G[state .. "Update"](dt)
	end
end

function util.scale(x, y)
	love.graphics.scale(scale, scale)
end

function util.renderState()
	if _G[state .. "Draw"] then
		_G[state .. "Draw"]()
	end
end

function util.keyPressedState(key)
	if _G[state .. "KeyPressed"] then
		_G[state .. "KeyPressed"](key)
	end
end

function util.keyReleasedState(key)
	if _G[state .. "KeyReleased"] then
		_G[state .. "KeyReleased"](key)
	end
end

function util.dist(x1,y1, x2,y2) 
	return ((x2-x1)^2+(y2-y1)^2)^0.5 
end

function util.clamp(val, min, max)
	return math.max(min, math.min(val, max))
end

function util.getWidth()
	return 192
end

function util.getHeight()
	return 128
end

Color =
{
	["red"] = {225, 73, 56},
	["green"] = {65, 168, 95},
	["blue"] = {44, 130, 201},
	["yellow"] = {250, 197, 28},
	["orange"] = {243, 121, 52},
	["purple"] = {147, 101, 184},
	["black"] = {0, 0, 0},
	["white"] = {255, 255, 255}
}

return util