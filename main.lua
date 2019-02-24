package.path = package.path .. ";modules/?.lua;modules/?/init.lua"
love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";modules/?.lua;modules/?/init.lua")

local network = require("network")
local memory = require("dolphin.memory")
local overlay = require("overlay")

math.randomseed(os.time())

love.graphics.oldSetColor = love.graphics.setColor

-- Love2D changed color values to be 0-1
-- Allow 0-255 value sagain..
function love.graphics.setColor(r,g,b,a)
	if type(r) == "table" then
		a, b, g, r = r[4] or 255, r[3] or 255, r[2] or 255, r[1] or 255
	else
		r, g, b, a = r or 255, g or 255, b or 255, a or 255
	end
	love.graphics.oldSetColor(r/255,g/255,b/255,a/255)
end

-- Draw an image using width and height in pixels
-- OriginX and OriginY should be between 0 and 1
-- An origin of 0.5, 0.5 would be the center
function love.graphics.easyDraw(obj, x, y, rotation, width, height, originX, originY, ...)
	if not obj then return end

	local objW, objH = obj:getWidth(), obj:getHeight()

	rotation = rotation or 0
	width = width or objW
	height = height or objH
	originX = originX or 0
	originY = originY or 0

	local scaledW = width / objW
	local scaledH = height / objH
	love.graphics.draw(obj, x, y, r, scaledW, scaledH, objW * originX, objH * originY, ...)
end

function love.load()
	love.graphics.setBackgroundColor(0, 0, 0, 0) -- This allows OBS to capture it with a transparent background
	overlay.init()
	memory.init()
end

function love.update(dt)
	repeat
		-- Read all memory updates until there is a new frame
		-- This syncs the overlays framerate with the game!
	until memory.read()

	-- Send any memory changes to dolphin at the end of each frame
	-- Yes, we can modify the game using the overlay!
	network.flushServer()
end

function love.draw()
	overlay.draw()
end

function love.quit()
	network.flushServer()
end