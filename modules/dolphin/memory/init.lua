local bit = require("bit")
local log = require("log")
local ffi = require("ffi")
local network = require("network")

require("extensions.string")
require("smash.enums")

local memory = {
	debug = true,
	hooks = {},
	cache = {},
	ptr_cache = {},
	named = {},
	names = {},
	synced = false,
	map = require("dolphin.memory.melee"), -- The map of the game we want to use!
	no_debug = {
		["frame"] = true,
		["timer.seconds"] = true,
		["timer.millis"] = true,
		["stage_cursor.x"] = true,
		["stage_cursor.y"] = true,
	}
}

local TYPE_NULL = 0
local TYPE_BOOL = 1
local TYPE_BYTE = 2
local TYPE_SHORT = 3
local TYPE_INT = 4
local TYPE_FLOAT = 5
local TYPE_POINTER = 6

local MEM_GET = 0
local MEM_SET = 1
local MEM_UPDATE = 2
local MEM_WATCH = 3

-- Allow us to do things such as memory.player.name without having to do memory.named.player.name
setmetatable(memory, {__index = memory.named})

local TYPE_NAME = {
	["bool"] = TYPE_BOOL,
	["byte"] = TYPE_BYTE,
	["short"] = TYPE_SHORT,
	["int"] = TYPE_INT,
	["float"] = TYPE_FLOAT,
	["pointer"] = TYPE_POINTER,
}

local READ_TYPES = {
	[TYPE_BOOL] = "readBool",
	[TYPE_BYTE] = "readByte",
	[TYPE_SHORT] = "readShort",
	[TYPE_INT] = "readInt",
	[TYPE_FLOAT] = "readFloat"
}

local WRITE_TYPES = {	
	[TYPE_BOOL] = "writeBool",
	[TYPE_BYTE] = "writeByte",
	[TYPE_SHORT] = "writeShort",
	[TYPE_INT] = "writeInt",
	[TYPE_FLOAT] = "writeFloat"
}

function memory.init()
	network.connect("localhost", 1337)
end

network.hook("onServerDisconnected", "Memory - Clear Map", function(server)
	memory.cache = {}
	memory.ptr_cache = {}
	memory.named = {}
	memory.names = {}
	memory.synced = false
end)

network.hook("onServerConnected", "Memory - Create Map", function(server)
	for address, info in pairs(memory.map) do
		if info.type == "pointer" and info.struct then
			for offset, struct in pairs(info.struct) do
				local b = network.buffer()
				b:writeByte(MEM_WATCH)
				b:writeInt(address)
				b:writeByte(TYPE_NAME[info.type])
				b:writeInt(offset)
				b:writeByte(TYPE_NAME[struct.type])
				network.sendServer(b)

				if not memory.ptr_cache[address] then
					memory.ptr_cache[address] = {}
				end

				memory.ptr_cache[address][offset] = nil
				memory.names[info.name .. struct.name] = { type = TYPE_NAME[struct.type], address = address, offset = offset }
				memory.setTableValue(info.name .. struct.name, nil)
			end
		else
			local b = network.buffer()
			b:writeByte(MEM_WATCH)
			b:writeInt(address)
			b:writeByte(TYPE_NAME[info.type])
			network.sendServer(b)
			memory.names[info.name] = address
			memory.setTableValue(info.name, nil)
		end
	end
	network.flushServer()
end)

-- Creates or updates a tree of values for easy indexing
-- Example a path of "player.name" will become memory.player = { name = value }
function memory.setTableValue(path, value)
	local last = memory.named

	local keys = {}
	for key in string.gmatch(path, "[^%.]+") do
		keys[#keys + 1] = tonumber(key) or key
	end

	for i, key in ipairs(keys) do
		if i < #keys then
			last[key] = last[key] or {}
			last = last[key]
		else
			if type(last) ~= "table" then
				return error(("Failed to index a %s value (%q)"):format(type(last), keys[i-1]))
			end
			last[key] = value
		end
	end
end

function memory.writeByte(address, value)
	local b = network.buffer()
	b:writeByte(MEM_SET)
	b:writeInt(address)
	b:writeByte(TYPE_BYTE)
	b:writeByte(value)
	network.sendServer(b)
end

function memory.writeShort(address, value)
	local b = network.buffer()
	b:writeByte(MEM_SET)
	b:writeInt(address)
	b:writeByte(TYPE_SHORT)
	b:writeShort(value)
	network.sendServer(b)
end

function memory.writeInt(address, value)
	local b = network.buffer()
	b:writeByte(MEM_SET)
	b:writeInt(address)
	b:writeByte(TYPE_INT)
	b:writeInt(value)
	network.sendServer(b)
end

function memory.writeFloat(address, value)
	local b = network.buffer()
	b:writeByte(MEM_SET)
	b:writeInt(address)
	b:writeByte(TYPE_FLOAT)
	b:writeFloat(value)
	network.sendServer(b)
end

function memory.writePointerByte(address, offset, value)
	local b = network.buffer()
	b:writeByte(MEM_SET)
	b:writeInt(address)
	b:writeByte(TYPE_POINTER)
	b:writeInt(offset)
	b:writeByte(TYPE_BYTE)
	b:writeByte(value)
	network.sendServer(b)
end

function memory.writePointerShort(address, offset, value)
	local b = network.buffer()
	b:writeByte(MEM_SET)
	b:writeInt(address)
	b:writeByte(TYPE_POINTER)
	b:writeInt(offset)
	b:writeByte(TYPE_SHORT)
	b:writeShort(value)
	network.sendServer(b)
end

function memory.writePointerInt(address, offset, value)
	local b = network.buffer()
	b:writeByte(MEM_SET)
	b:writeInt(address)
	b:writeByte(TYPE_POINTER)
	b:writeInt(offset)
	b:writeByte(TYPE_INT)
	b:writeInt(value)
	network.sendServer(b)
end

function memory.writePointerFloat(address, offset, value)
	local b = network.buffer()
	b:writeByte(MEM_SET)
	b:writeInt(address)
	b:writeByte(TYPE_POINTER)
	b:writeInt(offset)
	b:writeByte(TYPE_FLOAT)
	b:writeFloat(value)
	network.sendServer(b)
end

function memory.setValue(path, value)
	local address = memory.names[path]

	if not address then return end

	local info = memory.map[address]
	local type = TYPE_NAME[info.type]

	local b = network.buffer()
	b:writeByte(MEM_SET)
	b:writeInt(address)
	b:writeByte(type)
	b[WRITE_TYPES[type]](b, value)
	network.sendServer(b)

	memory.setTableValue(path, value)
end

function memory.setPointerValue(path, value)
	local ptr = memory.names[path]

	if not ptr then return end

	local b = network.buffer()
	b:writeByte(MEM_SET)
	b:writeInt(ptr.address)
	b:writeByte(TYPE_POINTER)
	b:writeInt(ptr.offset)
	b:writeByte(ptr.type)
	b[WRITE_TYPES[ptr.type]](b, value)
	network.sendServer(b)

	memory.setTableValue(path, value)
end

function memory.hook(name, desc, callback)
	memory.hooks[name] = memory.hooks[name] or {}
	memory.hooks[name][desc] = callback
end

function memory.hookRun(name, ...)
	-- Normal hooks
	if memory.hooks[name] then
		for desc, callback in pairs(memory.hooks[name]) do
			local succ, err = xpcall(callback, debug.traceback, ...)
			if not succ then
				log.error("memory hook error: %s (%s)", desc, err)
			end
		end
	end

	-- Allow for wildcard hooks
	for hookName, hooks in pairs(memory.hooks) do
		if string.find(hookName, "*", 1, true) then
			local pattern = '^' .. hookName:escapePattern():gsub("%%%*", "([^.]-)") .. '$'
			if string.find(name, pattern) then
				for desc, callback in pairs(hooks) do
					local succ, err = xpcall(callback, debug.traceback, name:match(pattern), ...)
					if not succ then
						log.error("memory hook error: %s (%s)", desc, err)
					end
				end
			end
		end
	end
end

function memory.toHex(address)
	return ("%08X"):format(address)
end

local function readType(buffer, type)
	return buffer[READ_TYPES[type]](buffer)
end

local function readTypeValue(buffer)
	local type = buffer:readByte()
	if type == TYPE_NULL then
		return nil
	end
	return readType(buffer, type)
end

function memory.read()
	local buffer

	-- Read until empty
	repeat
		buffer = network.readServer()

		if buffer then
			local mode = buffer:readByte()

			if mode == MEM_UPDATE then
				local address = buffer:readInt()
				local type = buffer:readByte()

				local info = memory.map[address]
				local frame = memory.frame or 0

				if type == TYPE_POINTER then
					local ptr_addr = buffer:readInt()
					local offset = buffer:readInt()
					local value = readTypeValue(buffer)

					if value == nil then
						-- Pointer is now null
						memory.ptr_cache[address] = nil
						memory.setTableValue(info.name, memory.ptr_cache[address])

						if info.debug or (memory.debug and not memory.no_debug[info.name]) then
							log.debug("[%d][%08X->%08X->%08X = NULL] %s = NULL", frame, address, ptr_addr, ptr_addr + offset, info.name)
						end
					else
						local numValue = tonumber(value) or (value and 1 or 0)

						if info and info.struct and info.struct[offset] then
							local struct = info.struct[offset]
							local name = string.format("%s.%s", info.name, struct.name)

							if info.debug or struct.debug or (memory.debug and not memory.no_debug[name]) then
								log.debug("[%d][%08X->%08X->%08X = %08X] %s = %s", frame, address, ptr_addr, ptr_addr + offset, numValue, name, value)
							end

							memory.ptr_cache[address] = memory.ptr_cache[address] or {}
							memory.ptr_cache[address][offset] = value
							memory.setTableValue(name, memory.ptr_cache[address][offset])

							if memory.synced then
								memory.hookRun(name, value)
							end
						else
							log.warn("[%d][%08X->%08X->%08X = %08X] UNHANDLED POINTER = %s", frame, address, ptr_addr, ptr_addr + offset, numValue, value)
						end
					end
				else
					local value = buffer[READ_TYPES[type]](buffer)
					local numValue = tonumber(value) or (value and 1 or 0)

					if info then
						if info.debug or (memory.debug and not memory.no_debug[info.name]) then
							log.debug("[%d][%08X = %08X] %s = %s", frame, address, numValue, info.name, value)
						end

						memory.cache[address] = value
						memory.setTableValue(info.name, memory.cache[address])

						if not memory.synced and info.name == "frame" then
							memory.synced = true
							memory.hookRun("synced")
							--return false
						else
							memory.hookRun(info.name, value)
							-- Only return true when the frame counter is updated
							return info.name == "frame"
						end
					else
						log.warn("[%d][%08X = %08X] UNHANDLED = %s", frame, address, numValue, value)
					end
				end
			else
				error("unexpected mode: " .. mode)
			end
		end
	until not buffer

	return false
end

return memory