require("smash.enums")

return {
	-- General game stuff..
	[0x005B5014] = {
		type = "int",
		name = "frame",
	},

	-- Player one stuff
	[0x015303F8] = {
		type = "int",
		name = "player.1.character",
		debug = true,
	},
	[0x015303F4] = {
		type = "int",
		name = "player.1.mode",
		debug = true,
	},
	[0x015303FC] = {
		type = "int",
		name = "player.1.skin",
		debug = true,
	},
	--[[[0x014EB46F] = {
		type = "int",
		table = "player",
		index = 1,
		name = "selected",
		debug = true,
	},]]
}