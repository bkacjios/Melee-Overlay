local socket = require("socket")
local buffer = require("network.buffer")

local network = {
	server_config = {
		host = nil,
		port = nil
	},
	server = nil,
	client = nil,
	hooks = {},
	client_buffer = buffer(),
	server_buffer = buffer(),
}

function network.sleep(t)
	socket.sleep(t)
end

function network.gettime()
	return socket.gettime()
end

function network.buffer(...)
	return buffer(...)
end

function network.hook(name, desc, callback)
	network.hooks[name] = network.hooks[name] or {}
	network.hooks[name][desc] = callback
end

function network.hookRun(name, ...)
	-- Normal hooks
	if network.hooks[name] then
		for desc, callback in pairs(network.hooks[name]) do
			local succ, err = xpcall(callback, debug.traceback, ...)
			if not succ then
				print(("network hook error: %s (%s)"):format(desc, err))
			end
		end
	end
end

-- Start a server
function network.startServer(host, port)
	local server = assert(socket.bind(host, port))
	print("Server started..", server:getsockname())
	network.server = server
end

-- Connect to a server
function network.connect(host, port)
	network.server_config.host = host
	network.server_config.port = port
	print("Connecting to server..")
	local server, err = socket.connect(host, port)
	if not server then return false, err end
	print("Connected", server:getsockname())
	--server:settimeout(0)
	network.server = server
	network.hookRun("onServerConnected", server)
	return server
end

-- Get the connection to the server, or reconnect if it's unavailable
function network.getServer()
	if network.server then return network.server end
	local host = network.server_config.host
	local port = network.server_config.port
	assert(host and port, "never connected to server, unable to reconnect..")
	return network.connect(host, port)
end

function network.serverDisconnect()
	print("Server disconnected..")
	network.hookRun("onServerDisconnected", network.server)
	network.server:close()
	network.server = nil
end

function network.getClient()
	assert(network.server, "Server is not started")
	if network.client then return network.client end
	print("Waiting for client..")
	local client, err = network.server:accept()
	if not client then return false, err end
	print("Client connected..", client:getsockname())
	client:settimeout(0)
	network.client = client
	network.hookRun("onClientConnected", client)
	return client
end

function network.clientDisconnect()
	print("Client disconnected..")
	network.hookRun("onClientDisconnected", network.client)
	network.client:close()
	network.client = nil
end

function network.read(socket)
	local header, err = socket:receive(4)
	if not header then return false, err end
	local b = buffer(header)
	local data, err = socket:receive(b:readInt())
	if not data then return false, err end
	local b = buffer(data)
	return b
end

function network.readClient()
	local client = network.getClient()
	if client then
		local buffer, err = network.read(client)
		if err == "timeout" then
		elseif err == "closed" then
			network.clientDisconnect()
		end
		return buffer, err
	end
end

function network.readServer()
	local server = network.getServer()
	if server then
		local buffer, err = network.read(server)
		if err == "timeout" then
		elseif err == "closed" then
			network.serverDisconnect()
		end
		return buffer, err
	end
end

function network.sendClient(buffer)
	-- Prefix a header that tells how long the packet is
	buffer:seek("set", 0)
	buffer:writeInt(buffer:len())

	network.client_buffer:writeBuffer(buffer)
end

function network.flushClient()
	local client = network.getClient()
	local last, err = client:send(network.client_buffer:toString())
	if err == "closed" then
		network.clientDisconnect()
	end
	network.client_buffer = buffer()
end

function network.sendServer(buffer, immediate)
	-- Prefix a header that tells how long the packet is
	buffer:seek("set", 0)
	buffer:writeInt(buffer:len())

	if immediate then
		local server = network.getServer()
		local last, err = server:send(buffer:toString())
		if err == "closed" then
			network.serverDisconnect()
		end
	else
		network.server_buffer:writeBuffer(buffer)
	end
end

function network.flushServer()
	local server = network.getServer()
	local last, err = server:send(network.server_buffer:toString())
	if err == "closed" then
		network.serverDisconnect()
	end
	network.server_buffer = buffer()
end

return network