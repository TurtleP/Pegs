io.stdout:setvbuf("no")

util = require 'libraries/util'
require 'libraries/physics'
class = require 'libraries/middleclass'
require 'libraries/variables'

require 'states/title'
require 'states/game'

require 'classes/player'
require 'classes/peg'
require 'classes/notice'
require 'classes/timer'

love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
	util.changeScale(2)

	util.createFonts()

	objectImage = love.graphics.newImage("graphics/objects.png")
	objectQuads = {}
	for k = 1, 7 do
		objectQuads[k] = love.graphics.newQuad((k - 1) * 17, 0, 16, 16, objectImage:getWidth(), objectImage:getHeight())
	end

	titleSong = love.audio.newSource("audio/menu.ogg")
	backgroundSong = love.audio.newSource("audio/bgm.ogg")

	deathSounds = {}
	for k = 1, 3 do
		deathSounds[k] = love.audio.newSource("audio/hurt" .. k .. ".ogg")
	end

	delayerImage = love.graphics.newImage("graphics/timer.png")
	delayerQuads = {}
	for y = 1, 4 do
		for x = 1, 5 do
			table.insert(delayerQuads, love.graphics.newQuad((x - 1) * 15, (y - 1) * 19, 15, 19, delayerImage:getWidth(), delayerImage:getHeight()))
		end
	end

	winSound = love.audio.newSource("audio/win.ogg")

	gameBeaten = true
	timedMode = false

	currentMap = "pegs"
	mapList = love.filesystem.getDirectoryItems("maps/")
	currentMapi = 1
	
	notices = {}

	loadData()

	util.changeState("title")
end

function love.update(dt)
	util.updateState(dt)

	for k, v in pairs(notices) do
		v:update(dt)

		if v.remove then
			table.remove(notices, k)
		end
	end
end

function love.draw()
	util.scale(scale, scale)

	util.renderState()

	for k, v in pairs(notices) do
		v:draw()
	end
end

function love.keypressed(key)
	util.keyPressedState(key)
end

function love.keyreleased(key)
	util.keyReleasedState(key)
end

function newNotice(text, warning, onEnd)
	table.insert(notices, notice:new(text, warning, onEnd))
end

function saveGame()
	love.filesystem.write("currentlevel:" .. currentLevel, "save.txt")
end

function loadData()
	local noticeString = "Loaded default data."

	if love.filesystem.exists("save.txt") then
		noticeString = "Loaded data."	
	end

	newNotice(noticeString)
end

function toggleTimed()
	timedMode = not timedMode
end