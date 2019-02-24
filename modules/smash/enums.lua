GAMES = {
	[1] = "MELEE",
	[3] = "BRAWL",
	[4] = "PROJECTM",
}

TEAM_COLORS = {
	[0x00] = {255, 0, 0, 255},		-- Red
	[0x01] = {0, 100, 255, 255},	-- Blue
	[0x02] = {0, 255, 0, 255},		-- Green
	[0x04] = {200, 200, 200, 255},	-- CPU/Disabled
}

PLAYER_COLORS = {
	[0] = {245, 46, 46, 255},
	[1] = {84, 99, 255, 255},
	[2] = {255, 199, 23, 255},
	[3] = {31, 158, 64, 255},
}

PLAYER = {
	HUMAN = 0,
	CPU = 1,
	DISABLED = 3,
}

--[[PLAYER_MODE = {
	HUMAN = 0,
	CPU = 1,
	DEMO = 2,
	NONE = 3,
}]]

TEAM = {
	RED = 0x00,
	BLUE = 0x01,
	GREEN = 0x02,
}

TEAM_NAMES = {
	[0x00] = "Red",
	[0x01] = "Blue",
	[0x02] = "Green",
}

--[[PLAYER = {
	["MELEE"] = {
		HUMAN = 0,
		CPU = 1,
		DISABLED = 3,
	},
	["PROJECTM"] = {
		DISABLED = 0,
		HUMAN = 1,
		CPU = 2,
	}
}]]

MENU = {
	CHARACTER_SELECT = 0,
	STAGE_SELECT = 1,
	IN_GAME = 2,
	POSTGAME_SCORES = 4,
}

-- Frame counter
-- 0x005A084C
-- 0x005A0D28
-- 0x005B5014 == 0x005A084C
-- 0x005B50D

-- Player 1 Selected
-- 0x014EB46F

-- 0x014ECD75 == 0x28 = false, 0xCA = true
-- 0x014ED055
-- 0x014ED3E5 == 0x28 = false, 0x8C = true

-- Player 1 Mode
-- 0x015303F4
-- 0x015303F5
-- 0x015303F6
-- 0x015303F7

-- Player 1 Select
-- 0x015303F8
-- 0x015303F9
-- 0x015303FA
-- 0x015303FB

-- Player 1 Skin
-- 0x015303FC
-- 0x015303FD
-- 0x015303FE
-- 0x015303FF

CHARACTER_PROJECT_M = {
	MARIO = 0x00,
	DK = 0x01,
	LINK = 0x02,
	SAMUS = 0x03,
	ZEROSAMUS = 0x04,
	YOSHI = 0x05,
	KIRBY = 0x06,
	FOX = 0x07,
	PIKACHU = 0x08,
	LUIGI = 0x09,
	CPTFALCON = 0x0A,
	NESS = 0x0B,
	BOWSER = 0x0C,
	PEACH = 0x0D,
	ZELDA = 0x0E,
	SHEIK = 0x0F,
	CLIMBERS = 0x10,
	MARTH = 0x11,
	MRGAMEWATCH = 0x12,
	FALCO = 0x13,
	GANONDORF = 0x14,
	WARIO = 0x15,
	METAKNIGHT = 0x16,
	PIT = 0x17,
	OLIMAR = 0x18,
	LUCAS = 0x19,
	DIDDY = 0x1A,

	DEDEDE = 0x1F,

	CHARIZARD = 0x2A,
	SQUIRTLE = 0x2B,
	IVYSAUR = 0x2C,
	ROY = 0x2D,
	MEWTWO = 0x2E,

	LUCARIO = 0x20,
	IKE = 0x21,
	ROB = 0x22,
	JIGGLYPUFF = 0x23,
	TOONLINK = 0x24,
	WOLF = 0x25,
	SNAKE = 0x26,
	SONIC = 0x27,

	NONE = 0x28,
	RANDOM = 0x29,
}

CHARACTER_PROJECT_M_BAD = {
	MARIO = 0x00,
	DK = 0x01,
	LINK = 0x02,
	SAMUS = 0x03,
	YOSHI = 0x04,
	KIRBY = 0x05,
	FOX = 0x06,
	PIKACHU = 0x07,
	LUIGI = 0x08,
	CPTFALCON = 0x09,
	NESS = 0x0A,
	BOWSER = 0x0B,
	PEACH = 0x0C,
	ZELDA = 0x0D,
	SHEIK = 0x0E,
	CLIMBERS = 0x0F,

	MARTH = 0x11,
	MRGAMEWATCH = 0x12,
	FALCO = 0x13,
	GANONDORF = 0x14,
	WARIO = 0x15,
	METAKNIGHT = 0x16,
	PIT = 0x17,
	ZEROSAMUS = 0x18,
	OLIMAR = 0x19,
	LUCAS = 0x1A,
	DIDDY = 0x1B,

	CHARIZARD = 0x1D,
	SQUIRTLE = 0x1E,
	IVYSAUR = 0x01F,
	DEDEDE = 0x20,
	LUCARIO = 0x21,
	IKE = 0x22,
	ROB = 0x23,

	JIGGLYPUFF = 0x25,
	MEWTWO = 0x26,
	ROY = 0x27,

	TOONLINK = 0x29,

	WOLF = 0x2C,

	SNAKE = 0x2E,
	SONIC = 0x2F,

}

CHARACTER_NAMES_BRAWL_BAD = {
	[0] = "Mario",
	[1] = "Donkey Kong",
	[2] = "Link",
	[3] = "Samus",
	[4] = "Yoshi",
	[5] = "Kirby",
	[6] = "Fox",
	[7] = "Pikachu",
	[8] = "Luigi",
	[9] = "Captain Falcon",
	[10] = "Ness",
	[11] = "Bowser",
	[12] = "Peach",
	[13] = "Zelda",
	[14] = "Sheik",
	[15] = "Ice Climbers",
	[16] = "Marth",
	[17] = "Mr. Game and Watch",
	[18] = "Falco",
	[19] = "Ganondorf",
	[21] = "Meta Knight",
	[22] = "Pit",
	[23] = "Zero Suit Samus",
	[24] = "Olimar",
	[25] = "Lucas",
	[26] = "Diddy Kong",
	[27] = "Pokemon Trainer",
	[28] = "Charizard",
	[29] = "Squirtle",
	[30] = "Ivysaur",
	[31] = "King Dedede",
	[32] = "Lucario",
	[33] = "Ike",
	[34] = "ROB",
	[36] = "Jigglypuff",
	[37] = "Wario",
	[40] = "Toon Link",
	[41] = "NONE",
	[43] = "Wolf",
	[45] = "Snake",
	[46] = "Sonic",
}

CHARACTER = {
	CPTFALCON = 0x00,
	DK = 0x01,
	FOX = 0x02,
	MRGAMEWATCH = 0x03,
	KIRBY = 0x04,
	BOWSER = 0x05,
	LINK = 0x06,
	LUIGI = 0x07,
	MARIO = 0x08,
	MARTH = 0x09,
	MEWTWO = 0x0A,
	NESS = 0x0B,
	PEACH = 0x0C,
	PIKACHU = 0x0D,
	CLIMBERS = 0x0E,
	JIGGLYPUFF = 0x0F,
	SAMUS = 0x10,
	YOSHI = 0x11,
	ZELDA = 0x12,
	SHEIK = 0x13,
	FALCO = 0x14,
	YOUNGLINK = 0x15,
	DRMARIO = 0x16,
	ROY = 0x17,
	PICHU = 0x18,
	GANONDORF = 0x19,
	MASTER_HAND = 0x1A,
	WIREFRAME_MALE = 0x1B,
	WIREFRAME_FEMALE = 0x1C,
	GIGA_BOWSER = 0x1D,
	CRAZY_HAND = 0x1E,
	SANDBAG = 0x1F,
	POPO = 0x20,
	NONE = 0x21,
}

CHARACTER_NAMES = {
	[0x00] = "Cpt. Falcon",
	[0x01] = "Donkey Kong",
	[0x02] = "Fox",
	[0x03] = "Mr. G&W",
	[0x04] = "Kirby",
	[0x05] = "Bowser",
	[0x06] = "Link",
	[0x07] = "Luigi",
	[0x08] = "Mario",
	[0x09] = "Marth",
	[0x0A] = "Mewtwo",
	[0x0B] = "Ness",
	[0x0C] = "Peach",
	[0x0D] = "Pikachu",
	[0x0E] = "Climbers",
	[0x0F] = "Jigglypuff",
	[0x10] = "Samus",
	[0x11] = "Yoshi",
	[0x12] = "Zelda",
	[0x13] = "Sheik",
	[0x14] = "Falco",
	[0x15] = "Young Link",
	[0x16] = "Dr. Mario",
	[0x17] = "Roy",
	[0x18] = "Pichu",
	[0x19] = "Ganondorf",
	[0x1A] = "Master Hand",
	[0x1B] = "Wireframe Male",
	[0x1C] = "Wireframe Female",
	[0x1D] = "Giga Bowser",
	[0x1E] = "Crazy Hand",
	[0x1F] = "Sandbag",
	[0x20] = "Popo",
	[0x21] = "NONE",
}

CHARACTER_CSS = {
	DRMARIO = 0,
	MARIO = 1,
	LUIGI = 2,
	BOWSER = 3,
	PEACH = 4,
	YOSHI = 5,
	DK = 6,
	CPTFALCON = 7,
	GANONDORF = 8,
	FALCO = 9,
	FOX = 10,
	NESS = 11,
	CLIMBERS = 12,
	KIRBY = 13,
	SAMUS = 14,
	ZELDA = 15,
	LINK = 16,
	YOUNGLINK = 17,
	PICHU = 18,
	PIKACHU = 19,
	JIGGLYPUFF = 20,
	MEWTWO = 21,
	MRGAMEWATCH = 22,
	MARTH = 23,
	ROY = 24,
	NONE = 25,
	RANDOM = 33,
}

CHARACTER_CSS_TRANSLATE = {
	[CHARACTER_CSS.DRMARIO] = CHARACTER.DRMARIO,
	[CHARACTER_CSS.MARIO] = CHARACTER.MARIO,
	[CHARACTER_CSS.LUIGI] = CHARACTER.LUIGI,
	[CHARACTER_CSS.BOWSER] = CHARACTER.BOWSER,
	[CHARACTER_CSS.PEACH] = CHARACTER.PEACH,
	[CHARACTER_CSS.YOSHI] = CHARACTER.YOSHI,
	[CHARACTER_CSS.DK] = CHARACTER.DK,
	[CHARACTER_CSS.CPTFALCON] = CHARACTER.CPTFALCON,
	[CHARACTER_CSS.GANONDORF] = CHARACTER.GANONDORF,
	[CHARACTER_CSS.FALCO] = CHARACTER.FALCO,
	[CHARACTER_CSS.FOX] = CHARACTER.FOX,
	[CHARACTER_CSS.NESS] = CHARACTER.NESS,
	[CHARACTER_CSS.CLIMBERS] = CHARACTER.CLIMBERS,
	[CHARACTER_CSS.KIRBY] = CHARACTER.KIRBY,
	[CHARACTER_CSS.SAMUS] = CHARACTER.SAMUS,
	[CHARACTER_CSS.ZELDA] = CHARACTER.ZELDA,
	[CHARACTER_CSS.LINK] = CHARACTER.LINK,
	[CHARACTER_CSS.YOUNGLINK] = CHARACTER.YOUNGLINK,
	[CHARACTER_CSS.PICHU] = CHARACTER.PICHU,
	[CHARACTER_CSS.PIKACHU] = CHARACTER.PIKACHU,
	[CHARACTER_CSS.JIGGLYPUFF] = CHARACTER.JIGGLYPUFF,
	[CHARACTER_CSS.MEWTWO] = CHARACTER.MEWTWO,
	[CHARACTER_CSS.MRGAMEWATCH] = CHARACTER.MRGAMEWATCH,
	[CHARACTER_CSS.MARTH] = CHARACTER.MARTH,
	[CHARACTER_CSS.ROY] = CHARACTER.ROY,
}

CHARACTER_NAMES_CSS = {
	[0] = "Dr. Mario",
	[1] = "Mario",
	[2] = "Luigi",
	[3] = "Bowser",
	[4] = "Peach",
	[5] = "Yoshi",
	[6] = "Donkey Kong",
	[7] = "Cpt. Falcon",
	[8] = "Ganondorf",
	[9] = "Falco",
	[10] = "Fox",
	[11] = "Ness",
	[12] = "Ice Climbers",
	[13] = "Kirby",
	[14] = "Samus",
	[15] = "Zelda",
	[16] = "Link",
	[17] = "Young Link",
	[18] = "Pichu",
	[19] = "Pikachu",
	[20] = "Jigglypuff",
	[21] = "Mewtwo",
	[22] = "Mr. G&W",
	[23] = "Marth",
	[24] = "Roy",
	[25] = "RANDOM",
}

STAGE = {
	PRINCESS_PEACHS_CASTLE = 0x02,
	RAINBOW_CRUISE = 0x03,
	KONGO_JUNGLE = 0x04,
	JUNGLE_JAPES = 0x05,
	GREAT_BAY = 0x06,
	HYRULE_TEMPLE = 0x07,
	BRINSTAR = 0x08,
	BRINSTAR_DEPTHS = 0x09,
	YOSHIS_STORY = 0x0A,
	YOSHIS_ISLAND = 0x0B,
	FOUNTAIN_OF_DREAMS = 0x0C,
	GREEN_GREENS = 0x0D,
	CORNERIA = 0x0E,
	VENOM = 0x0F,
	POKEMON_STADIUM = 0x10,
	POKE_FLOATS = 0x11,
	MUTE_CITY = 0x12,
	BIG_BLUE = 0x13,
	ONETT = 0x14,
	FOURSIDE = 0x15,
	ICICLE_MOUNTAIN = 0x16,
	MUSHROOM_KINGDOM = 0x18,
	MUSHROOM_KINGDOM_2 = 0x19,
	FLAT_ZONE = 0x1B,
	DREAM_LAND = 0x1B,
	YOSHIS_ISLAND_64 = 0x1D,
	KONGO_JUNGLE_64 = 0x1E,
	BATTLEFIELD = 0x24,
	FINAL_DESTINATION = 0x25,
}

STAGE_NAMES = {
	[0x02] = "Princess Peach's Castle",
	[0x03] = "Rainbow Cruise",
	[0x04] = "Kongo Jungle",
	[0x05] = "Jungle Japes",
	[0x06] = "Great Bay",
	[0x07] = "Hyrule Temple",
	[0x08] = "Brinstar",
	[0x09] = "Brinstar Depths",
	[0x0A] = "Yoshi's Story",
	[0x0B] = "Yoshi's Island",
	[0x0C] = "Fountain of Dreams",
	[0x0D] = "Green Greens",
	[0x0E] = "Corneria",
	[0x0F] = "Venom",
	[0x10] = "Pokémon Stadium",
	[0x11] = "Poké Floats",
	[0x12] = "Mute City",
	[0x13] = "Big Blue",
	[0x14] = "Onett",
	[0x15] = "Fourside",
	[0x16] = "Icicle Mountain",
	[0x18] = "Mushroom Kingdom",
	[0x19] = "Mushroom Kingdom 2",
	[0x1B] = "Flat Zone",
	[0x1C] = "Dream Land N64",
	[0x1D] = "Yoshi's Island N64",
	[0x1E] = "Kongo Jungle N64",
	[0x24] = "Battlefield",
	[0x25] = "Final Destination",
}