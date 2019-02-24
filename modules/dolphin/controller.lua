local log = require("log")
local network = require("network")
local memory = require("dolphin.memory")

local controller = {
	instances = {}
}

local CONTROLLER = {}
CONTROLLER.__index = CONTROLLER

local DEBUG = false

local INPUT_BUTTON = 4
local INPUT_ANALOG = 5

memory.hook("menu", "Controller - Reset on Menu", function(menu)
	-- Changing menu states causes the frame counter to reset, this stops things from breaking
	controller.reset()
end)

function controller.instance(port)
	if not controller.instances[port] then
		controller.instances[port] = setmetatable({
			port = port,
			pressed = {},
			released = {},
			tilt = {
				["MAIN"] = { x = 0.5, y = 0.5 },
				["C"] = { x = 0.5, y = 0.5 },
			},
		}, CONTROLLER)
	end

	return controller.instances[port]
end

function CONTROLLER:__tostring()
	return ("Controller[%d]"):format(self.port)
end

function controller.reset()
	for port, controller in pairs(controller.instances) do
		controller:reset()
	end
end

function controller.releasePressed()
	local needsRelease = false
	for port, controller in pairs(controller.instances) do
		if controller:releasePressed() then
			needsRelease = true
		end
	end
	return needsRelease
end

function CONTROLLER:pressButton(button, frames)
	button = button:upper()

	if self.pressed[button] then return false end
	if self.released[button] and self.released[button] > memory.frame then return false end
	self.pressed[button] = memory.frame + (frames or 2)

	local b = network.buffer()
	b:writeByte(INPUT_BUTTON)
	b:writeByte(self.port)
	b:writeString(button)
	b:writeBool(true)

	network.sendServer(b)
	if DEBUG then
		log.debug("[%d] Controller[%d] PRESSING %s", memory.frame, self.port, button)
	end
	return true
end

function CONTROLLER:releaseButton(button, frames)
	button = button:upper()

	if not self.pressed[button] then return end
	self.released[button] = memory.frame + (frames or 2) -- Prevent this button from being pressed for a short time
	self.pressed[button] = nil

	local b = network.buffer()
	b:writeByte(INPUT_BUTTON)
	b:writeByte(self.port)
	b:writeString(button)
	b:writeBool(false)

	network.sendServer(b)
	if DEBUG then
		log.debug("[%d] Controller[%d] RELEASING %s", memory.frame, self.port, button)
	end
end

function CONTROLLER:releasePressed()
	local needsRelease = false
	for button, pressed in pairs(self.pressed) do
		if pressed then
			needsRelease = true
			if pressed <= memory.frame then
				self:releaseButton(button)
			end
		end
	end
	return needsRelease
end

function CONTROLLER:tiltAnalog(stick, x, y)
	stick = stick:upper()

	if self.tilt[stick].x == x and self.tilt[stick].y == y then return end

	self.tilt[stick].x = x
	self.tilt[stick].y = y

	local b = network.buffer()
	b:writeByte(INPUT_ANALOG)
	b:writeByte(self.port)
	b:writeString(stick)
	b:writeFloat(x)
	b:writeFloat(y)

	network.sendServer(b)

	if DEBUG then
		log.debug("[%d] Controller[%d] TILT %s %.4f %.4f", memory.frame, self.port, stick, x, y)
	end
end

function CONTROLLER:centerSticks()
	self:tiltAnalog("MAIN", 0.5, 0.5)
	self:tiltAnalog("C", 0.5, 0.5)
end

function CONTROLLER:reset()
	self:tiltAnalog("MAIN", 0.5, 0.5)
	self:tiltAnalog("C", 0.5, 0.5)
	--[[self:pressShoulder("L", -1)
	self:pressShoulder("R", -1)]]
	self:releaseButton("A")
	self:releaseButton("B")
	self:releaseButton("X")
	self:releaseButton("Y")
	self:releaseButton("Z")
	self:releaseButton("L")
	self:releaseButton("R")
	self:releaseButton("START")
	self:releaseButton("D_UP")
	self:releaseButton("D_DOWN")
	self:releaseButton("D_LEFT")
	self:releaseButton("D_RIGHT")
	self.released = {}
end

return controller