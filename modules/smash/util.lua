local socket = require("socket")
require("smash.enums")

local util = {}

function util.getTeamName(id)
	return TEAM_NAMES[id] or "UNKNOWN TEAM"
end

function util.getCharacterName(id)
	return CHARACTER_NAMES[id] or "UNKNOWN CHARACTER"
end

function util.getStageName(id)
	return STAGE_NAMES[id] or "UNKNOWN STAGE"
end

function util.getTime()
	return socket.gettime()
end

return util