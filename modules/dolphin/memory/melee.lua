require("smash.enums")

local map = {
	-- General game stuff..
	[0x00479D60] = { type = "int", name = "frame" },
	[0x00479D33] = { type = "byte", name = "menu" },
	[0x0049E753] = { type = "byte", name = "stage.id" },
	[0x004807C8] = { type = "bool", name = "teams" },
	[0x0046B6C8] = { type = "int", name = "timer.seconds" },
	[0x0046B6CC] = { type = "short", name = "timer.millis" },

	[0x0045C370] = { type = "byte", name = "settings.item_frequency" },
	[0x0045C378] = { type = "int", name = "settings.item_switch.1" },
	[0x0045C37C] = { type = "int", name = "settings.item_switch.2" },
	[0x0045C388] = { type = "int", name = "settings.random_stages" },

	--[0x0046DB88] = { type = "int", name = "item.frequency1", debug = true },
	--[0x0046DB8C] = { type = "int", name = "item.frequency1", debug = true},

	-- Stage select cursor
	[0x00C8EE50] = { type = "float", name = "stage.cursor.x" },
	[0x00C8EE60] = { type = "float", name = "stage.cursor.y" },
	--[0x0025AA10] = { type = "byte", name = "stage.default_select", debug = true },

	--[[
	-- 9 = 20XX, 22 = normalish, 19 = Alt Normal
	[0x003FBADF] = { type = "byte", name = "20xx.settings.cpu_type.1" },
	[0x003FBB1B] = { type = "byte", name = "20xx.settings.cpu_type.2" },
	[0x003FBB57] = { type = "byte", name = "20xx.settings.cpu_type.3" },
	[0x003FBB93] = { type = "byte", name = "20xx.settings.cpu_type.4" },

	[0x003F0B79] = { type = "byte", name = "20xx.css.bowser", debug = true }, -- 0x05 for Bowser, 0x1D for Giga Bowser
	[0x003F0CC9] = { type = "byte", name = "20xx.css.zelda", debug = true }, -- 0x12 for Zelda, 0x13 for Sheik
	]]
}

local game = 0x0046db68

local game_struct = {
	[0x06] = { type = "bool", name = "game.bombrain" },
	[0x0E] = { type = "short", name = "game.stage" },
}

for offset, info in pairs(game_struct) do
	map[game + offset] = info
end

local stage_info = 0x0049E6C8

local stage_info_struct = {
	[0x0000] = { type = "float", name = "camera.limit.left" },
	[0x0004] = { type = "float", name = "camera.limit.right" },
	[0x0008] = { type = "float", name = "camera.limit.top" },
	[0x000C] = { type = "float", name = "camera.limit.bottom" },

	[0x0074] = { type = "float", name = "stage.blastzone.left" },
	[0x0078] = { type = "float", name = "stage.blastzone.right" },
	[0x007C] = { type = "float", name = "stage.blastzone.top" },
	[0x0080] = { type = "float", name = "stage.blastzone.bottom" },
}

for offset, info in pairs(stage_info_struct) do
	map[stage_info + offset] = info
end

--[[
Item frequency = 0x8045C370

0x8046DB80

8046db68 + 0x24D0

0x0044D178 = SOME RANDOM WEBSITE
0x8046db68 + 0x24D3 = 0x8045C370 = GOOGLE DOC
0x8046b6a0 + 0x24D3 = 0x0046DB73 = 20xx
]]

local settings = 0x046b6A0

local settings_struct = {
	[0x24D0] = { type = "byte", name = "match.settings.teams" },
	[0x24D3] = { type = "byte", name = "match.settings.item_frequency" },
	[0x24D4] = { type = "byte", name = "match.settings.self_destruct" },
	[0x24E8] = { type = "int", name = "match.settings.item_switch.1" },
	[0x24EC] = { type = "int", name = "match.settings.item_switch.2" },
}

for offset, info in pairs(settings_struct) do
	map[settings + offset] = info
end

local player_cursors = {
	[1] = {
		x = 0x01118DEC,
		y = 0x01118DF0,
	},
	[2] = {
		x = 0x0111826C,
		y = 0x01118270,
	},
	[3] = {
		x = 0x011176EC,
		y = 0x011176F0,
	},
	[4] = {
		x = 0x01115A30,
		y = 0x01115A40,
	},
}

local player_cursors_20xx = {
	[1] = {
		x = 0x01166838,
		y = 0x0116683C,
	},
	[2] = {
		x = 0x01165B38,
		y = 0x01165B3C,
	},
	[3] = {
		x = 0x01164CD8,
		y = 0x01164CDC,
	},
	[4] = {
		x = 0x0115D878,
		y = 0x0115D87C,
	},
}

for id, data in ipairs(player_cursors_20xx) do
	for key, addr in pairs(data) do
		map[addr] = {
			type = "float",
			name = ("player.%i.cursor.%s"):format(id, key),
		}
	end
end

local player_static_addresses = {
	0x00453080, -- Player 1
	0x00453F10, -- Player 2
	0x00454DA0, -- Player 3
	0x00455C30, -- Player 4
}

local player_static_struct = {
	[0x000] = { type = "int", name = "state" },
	--[0x004] = { type = "int", name = "character" },
	[0x008] = { type = "int", name = "mode" },
	[0x00C] = { type = "short", name = "transformed" },
	[0x010] = { type = "float", name = "position.x" },
	[0x014] = { type = "float", name = "position.y" },
	[0x018] = { type = "float", name = "position.z" },
	[0x01C] = { type = "float", name = "partner_position.x" },
	[0x020] = { type = "float", name = "partner_position.y" },
	[0x024] = { type = "float", name = "partner_position.z" },
	[0x040] = { type = "float", name = "facing" },
	[0x044] = { type = "byte", name = "skin" },
	--[0x045] = { type = "byte", name = "port" },
	[0x046] = { type = "byte", name = "color" },
	[0x047] = { type = "byte", name = "team" },
	[0x048] = { type = "byte", name = "port" },
	[0x049] = { type = "byte", name = "cpu_level" },
	[0x04A] = { type = "byte", name = "cpu_type" }, -- 9 = 20XX, 22 = normalish, 19 = Alt Normal
	[0x054] = { type = "float", name = "attack_ratio" },
	[0x058] = { type = "float", name = "damage_ratio" },
	[0x060] = { type = "short", name = "percent" },
	[0x062] = { type = "short", name = "percent_starting" },
	[0x064] = { type = "short", name = "stamina" },
	--[0x066] = { type = "int", name = "falls" },
	[0x070] = { type = "int", name = "kills_player1" },
	[0x074] = { type = "int", name = "kills_player2" },
	[0x078] = { type = "int", name = "kills_player3" },
	[0x07C] = { type = "int", name = "kills_player4" },
	[0x080] = { type = "int", name = "kills_player5" },
	[0x084] = { type = "int", name = "kills_player6" },
	[0x08C] = { type = "short", name = "suicides" },
	[0x08E] = { type = "byte", name = "stocks" },
	[0x090] = { type = "int", name = "coins" },
	[0x094] = { type = "int", name = "coins_total" },
	[0x0E8] = { type = "int", name = "attacks_count" },
	[0x0F0] = { type = "int", name = "attacks_landed" },

	-- Defined these as pointers below
	--[0x0B0] = { type = "int", name = "entity" }, -- Pointer to player entity -> 0x00453130
	--[0x0B4] = { type = "int", name = "partner" }, -- Pointer to partner entity -> 0x00453134

	[0xD1C] = { type = "float", name = "damage_taken" },
	[0xD20] = { type = "float", name = "damage_peak" },
	[0xD24] = { type = "int", name = "damage_recovered" },
	[0xD28] = { type = "float", name = "damage_given" },
	[0xD60] = { type = "int", name = "attacks_landed2" },
	--[0xDDC] = { type = "int", name = "air_time" },
	--[0xDE0] = { type = "int", name = "ground_time" },
}

for id, address in ipairs(player_static_addresses) do
	for offset, info in pairs(player_static_struct) do
		map[address + offset] = {
			type = info.type,
			debug = info.debug,
			name = ("player.%i.%s"):format(id, info.name),
		}
	end
end

local entity_pointer_offsets = {
	[0xB0] = "entity",
	[0xB4] = "partner", -- Partner entity (For sheik/zelda/iceclimbers)
}

for id, address in ipairs(player_static_addresses) do
	for offset, name in pairs(entity_pointer_offsets) do
		map[address + offset] = {
			type = "pointer",
			name = ("player.%i.%s"):format(id, name),
			--debug = true,
			struct = {
				--[0x60 + 0x0000] = { type = "int", name = "base_entity" },
				[0x60 + 0x0004] = { type = "int", name = "character" },
				[0x60 + 0x0008] = { type = "int", name = "spawns" },
				[0x60 + 0x000C] = { type = "byte", name = "slot" },
				[0x60 + 0x0010] = { type = "int", name = "action_state" },
				--[0x60 + 0x0014] = { type = "int", name = "animation_state" },
				--[0x60 + 0x0018] = { type = "int", name = "action_id" },
				[0x60 + 0x00B0] = { type = "float", name = "position.x" },
				[0x60 + 0x00B4] = { type = "float", name = "position.y" },
				[0x60 + 0x00B8] = { type = "float", name = "position.z" },
				[0x60 + 0x0619] = { type = "byte", name = "skin" },
				[0x60 + 0x061A] = { type = "byte", name = "color" },
				[0x60 + 0x061B] = { type = "byte", name = "team" },
				[0x60 + 0x1830] = { type = "float", name = "percent" },
				[0x60 + 0x1838] = { type = "float", name = "add_percent" }, -- Setting this to a value will apply the value as damage the next frame
				[0x60 + 0x18F0] = { type = "int", name = "sub_percent" }, -- Setting this to a value will apply the value as a heal the next frame
			},
		}
	end
end

local player_select_addresses = {
	0x003F0E06,
	0x003F0E2A,
	0x003F0E4E,
	0x003F0E72,
}

local player_select = {
	[0x00] = "team",
	[0x01] = "mode",
	[0x02] = "skin",
	[0x03] = "previous",
	[0x04] = "character",
}

for id, address in ipairs(player_select_addresses) do
	for offset, name in pairs(player_select) do
		map[address + offset] = {
			type = "byte",
			name = ("player.%i.select.%s"):format(id, name),
		}
	end
end

local player_select_external_addresses = {
	0x0043208B,
	0x00432093,
	0x0043209B,
	0x004320A3,
}

local player_select_external = {
	--[0x00] = "unknown",
	[0x04] = "character",
	--[0x08] = "mode"
}

for id, address in ipairs(player_select_external_addresses) do
	for offset, name in pairs(player_select_external) do
		map[address + offset] = {
			type = "byte",
			name = ("player.%i.%s"):format(id, name),
		}
	end
end

return map