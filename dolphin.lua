package.path = ".\\?.lua;.\\lua\\?.lua;.\\lua\\?\\init.lua;"
package.cpath = ".\\lua\\?.dll;.\\lua\\bin\\?.dll;.\\lua\\bin\\loadall.dll"

local network = require("network")

-- Define different memory types
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
local INPUT_BUTTON = 4
local INPUT_ANALOG = 5

local TYPE_IO = {
	[TYPE_BOOL] = { read = "readByte", write = "writeByte" },
	[TYPE_BYTE] = { read = "readByte", write = "writeByte" },
	[TYPE_SHORT] = { read = "readShort", write = "writeShort" },
	[TYPE_INT] = { read = "readInt", write = "writeInt" },
	[TYPE_FLOAT] = { read = "readInt", write = "writeInt" } -- Send as the raw 4 bytes, we read it on the overlay as a float
}

local watching = {}
local values = {}
local ptr_watching = {}
local ptr_location = {}
local ptr_values = {}

network.startServer("localhost", 1337)

function memory.writeType(type, address, value)
	memory[TYPE_IO[type].write](address, value)
end

function memory.readType(type, address)
	return memory[TYPE_IO[type].read](address)
end

local function writeType(buffer, type, value)
	buffer:writeByte(type)
	buffer[TYPE_IO[type].write](buffer, value)
end

local function readType(buffer, type)
	return buffer[TYPE_IO[type].read](buffer)
end

local function readClient()
	local buffer = network.readClient()

	if not buffer then return false end

	local mode = buffer:readByte()
	if mode == MEM_WATCH then
		-- Track any memory changes
		local address = buffer:readInt()
		local type = buffer:readByte()
		if type == TYPE_POINTER then
			local offset = buffer:readInt()
			--ptr_location[address] = 0x00000000
			ptr_values[address] = ptr_values[address] or {}
			ptr_watching[address] = ptr_watching[address] or {}
			ptr_watching[address][offset] = buffer:readByte()
		else
			watching[address] = type
			values[address] = nil
		end
	elseif mode == MEM_SET then
		local address = buffer:readInt()
		local type = buffer:readByte()
		if type == TYPE_POINTER then
			local ptr_addr = memory.readInt(address)
			local offset = buffer:readInt()
			type = buffer:readByte()
			--print(("Followed pointer %08X->%08x->%08X"):format(address, ptr_addr, offset))
			address = ptr_addr + offset
		end
		local value = readType(buffer, type)
		--print(("Writing %08X = %08x"):format(address, value))
		memory.writeType(type, address, value)
	elseif mode == INPUT_BUTTON then
		local port = buffer:readByte()
		local name = buffer:readString()
		local value = buffer:readBool()
		controller.get(port-1):setButton(name, value)
	elseif mode == INPUT_ANALOG then
		local port = buffer:readByte()
		local name = buffer:readString()
		local x, y = buffer:readFloat(), buffer:readFloat()
		controller.get(port-1):setAxis(name, x, y)
	end

	return true
end

network.hook("onClientConnected", "Memory - Create Map", function(client)
	watching = {}
	values = {}
	ptr_watching = {}
	ptr_values = {}
	ptr_location = {}
	network.sleep(1)
end)

function memory.step()
	repeat until not readClient()

	for address, type in pairs(watching) do
		local value = memory.readType(type, address)

		if values[address] ~= value then
			values[address] = value

			local b = network.buffer()
			b:writeByte(MEM_UPDATE)
			b:writeInt(address)
			writeType(b, type, value)
			network.sendClient(b)
		end
	end

	for address, offsets in pairs(ptr_watching) do
		local ptr_addr = memory.readInt(address)

		if ptr_location[address] ~= ptr_addr then
			ptr_location[address] = ptr_addr
			--print(("Pointer at %08X changed location to %08X"):format(address, ptr_addr))
			if ptr_addr == 0x00000000 then
				ptr_values[address] = {}
				--print(("Setting %08X to NULL"):format(address))

				local b = network.buffer()
				b:writeByte(MEM_UPDATE)
				b:writeInt(address)
				b:writeByte(TYPE_POINTER)
				b:writeInt(ptr_addr)
				b:writeInt(ptr_addr)
				b:writeByte(TYPE_NULL)
				network.sendClient(b)
				break
			end
		end

		if ptr_addr ~= 0x00000000 then
			for offset, type in pairs(offsets) do
				local value = memory.readType(type, ptr_addr + offset)

				-- If the location of the pointer changed, or our value changed..
				if ptr_values[address][offset] ~= value then
					ptr_values[address][offset] = value

					local b = network.buffer()
					b:writeByte(MEM_UPDATE)
					b:writeInt(address)
					b:writeByte(TYPE_POINTER)
					b:writeInt(ptr_addr)
					b:writeInt(offset)
					writeType(b, type, value)
					network.sendClient(b)
				end
			end
		end
	end

	network.flushClient()
end