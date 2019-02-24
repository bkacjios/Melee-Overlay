local memory = require("dolphin.memory")
require("smash.enums")

local melee = {}

function melee.getPlayer(id)
	return memory.player[id]
end

function melee.getPlayerColor(player)
	if not player or not player.team then return TEAM_COLORS[4] end
	return memory.teams and TEAM_COLORS[player.team] or PLAYER_COLORS[player.port]
end

function melee.getPlayerEntity(id)
	return melee.getEntity(melee.getPlayer(id))
end

function melee.isPlayerTransformed(player)
	return player.transformed == 256
end

function melee.getEntity(player)
	local character = player.character
	local transformed = player.transformed == 256
	if (character == CHARACTER.ZELDA or character == CHARACTER.SHEIK) and transformed then
		-- If the character started as zelda or shiek, and they transformed
		-- return their partner entity (Which is the active entity)
		-- A player can start as Sheik by holding A when loading in, so their character ID would be Shiek instead of Zelda
		return player.partner
	else
		return player.entity
	end
end

-- action_state 0x0-0xA means the player is dead
-- action_state 0xB = Sleep (Dead/Waiting to respawn)
-- action_state 0xC = Respawning
-- action_state 0xD = Waiting on respawn platform

function melee.isEntityActive(entity)
	return entity and entity.action_state and entity.action_state ~= 0xB
end

function melee.isEntityAlive(entity)
	return entity and entity.action_state and entity.action_state > 0xB
end

function melee.isEntityRespawning(entity)
	return entity and entity.action_state and entity.action_state >= 0xC and entity.action_state <= 0xD
end

function melee.isEntityOffCamera(entity)
	if entity then
		local camera = memory.camera.limit
		local pos = entity.position
		if pos.x <= camera.left or pos.x >= camera.right  or pos.y <= camera.bottom or pos.y >= camera.top then
			return true
		end
	end
	return false
end

return melee