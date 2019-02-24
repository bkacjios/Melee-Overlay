local hook = require("hook")
local memory = require("dolphin.memory")
local util = require("smash.util")
local melee = require("smash.melee")
require("extensions.math")

local overlay = {
	fonts = {
		percent = love.graphics.newFont("fonts/Rodin-Bokutoh-Pro-UB.ttf", 64),
		sub_percent = love.graphics.newFont("fonts/Rodin-Bokutoh-Pro-UB.ttf", 24),
		huge = love.graphics.newFont("fonts/Rodin-Bokutoh-Pro-UB.ttf", 32),
		large = love.graphics.newFont("fonts/Rodin-Bokutoh-Pro-UB.ttf", 24),
		medium = love.graphics.newFont("fonts/Rodin-Bokutoh-Pro-UB.ttf", 16),
		small = love.graphics.newFont("fonts/Rodin-Bokutoh-Pro-UB.ttf", 12),
		tiny = love.graphics.newFont("fonts/Rodin-Bokutoh-Pro-UB.ttf", 8),
	},
	texture_cache = {
		players = {
			love.graphics.newImage("textures/player1.png"),
			love.graphics.newImage("textures/player2.png"),
			love.graphics.newImage("textures/player3.png"),
			love.graphics.newImage("textures/player4.png"),
		},
		heads = {},
		stocks = {},
	},
	minimap_circle = love.graphics.newImage("textures/circle.png"),
	textures = {
		[0x00] = {
			icon = "falcon",
			skin = {"original", "black", "red", "white", "green", "blue"},
			series = "fzero"
		},
		[0x01] = {
			icon = "dk",
			skin = {"original", "black", "red", "blue", "green"},
			series = "donkey_kong"
		},
		[0x02] = {
			icon = "fox",
			skin = {"original", "red", "blue", "green"},
			series = "star_fox"
		},
		[0x03] = {
			icon = "gameandwatch",
			skin = {"original", "red", "blue", "green"},
			series = "game_and_watch"
		},
		[0x04] = {
			icon = "kirby",
			skin = {"original", "yellow", "blue", "red", "green", "white"},
			series = "kirby"
		},
		[0x05] = {
			icon = "bowser",
			skin = {"green", "red", "blue", "black"},
			series = "mario"
		},
		[0x06] = {
			icon = "link",
			skin = {"green", "red", "blue", "black", "white"},
			series = "zelda"
		},
		[0x07] = {
			icon = "luigi",
			skin = {"green", "white", "blue", "red"},
			series = "mario"
		},
		[0x08] = {
			icon = "mario",
			skin = {"red", "yellow", "black", "blue", "green"},
			series = "mario"
		},
		[0x09] = {
			icon = "marth",
			skin = {"original", "red", "green", "black", "white"},
			series = "fire_emblem"
		},
		[0x10] = {
			icon = "samus",
			skin = {"red", "pink", "black", "green", "blue"},
			series = "metroid"
		},
		[0x11] = {
			icon = "yoshi",
			skin = {"green", "red", "blue", "yellow", "pink", "light_blue"},
			series = "yoshi"
		},
		[0x12] = {
			icon = "zelda",
			skin = {"original", "red", "blue", "green", "white"},
			series = "zelda"
		},
		[0x13] = {
			icon = "sheik",
			skin = {"original", "red", "blue", "green", "black"},
			series = "zelda"
		},
		[0x14] = {
			icon = "falco",
			skin = {"original", "red", "blue", "green"},
			series = "star_fox"
		},
		[0x15] = {
			icon = "younglink",
			skin = {"green", "red", "blue", "black", "white"},
			series = "zelda"
		},
		[0x16] = {
			icon = "doc",
			skin = {"white", "red", "blue", "green", "black"},
			series = "mario"
		},
		[0x17] = {
			icon = "roy",
			skin = {"original", "red", "blue", "green", "yellow"},
			series = "fire_emblem"
		},
		[0x18] = {
			icon = "pichu",
			skin = {"original", "red", "blue", "green"},
			series = "pokemon"
		},
		[0x19] = {
			icon = "ganon",
			skin = {"original", "red", "blue", "green", "purple"},
			series = "zelda"
		},
		[0x0A] = {
			icon = "mewtwo",
			skin = {"original", "red", "blue", "green"},
			series = "pokemon"
		},
		[0x0B] = {
			icon = "ness",
			skin = {"original", "yellow", "blue", "green"},
			series = "earthbound"
		},
		[0x0C] = {
			icon = "peach",
			skin = {"original", "daisy", "white", "blue", "green"},
			series = "mario"
		},
		[0x0D] = {
			icon = "pikachu",
			skin = {"original", "red", "blue", "green"},
			series = "pokemon"
		},
		[0x0E] = {
			icon = "climbers",
			skin = {"original", "green", "orange", "red"},
			series = "ice_climbers"
		},
		[0x0F] = {
			icon = "puff",
			skin = {"original", "red", "blue", "green", "crown"},
			series = "pokemon"
		},
		--[[[0x21] = {
			icon = "wireframe",
			series = "smash"
		},]]
	},
	nana_skins = {
		[0] = 3,
		[1] = 2,
		[2] = 0,
		[4] = 0,
	},
	percent_updated = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
	},
	partner_percent_updated = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
	},
	stats = {
		mode = 0,
		updated = 0,
		stop = 0,
		mode_skipped = 0,
	}
}

function overlay.init()
	for cid, info in pairs(overlay.textures) do
		overlay.texture_cache.heads[cid] = love.graphics.newImage(("textures/heads/%s.png"):format(info.icon))

		for sid, skin in ipairs(info.skin) do
			overlay.texture_cache.stocks[cid] = overlay.texture_cache.stocks[cid] or {}
			overlay.texture_cache.stocks[cid][sid] = love.graphics.newImage(("textures/stocks/%s-%s.png"):format(info.icon, skin))
		end
	end
	for cid, info in pairs(overlay.textures) do
	end
end

memory.hook("player.*.entity.percent", "Overlay - Player Percent", function(player, percent)
	overlay.percent_updated[tonumber(player)] = util.getTime()
end)

memory.hook("player.*.partner.percent", "Overlay - Player Percent", function(player, percent)
	overlay.partner_percent_updated[tonumber(player)] = util.getTime()
end)

function overlay.didPercentChange(slot)
	local player = melee.getPlayer(slot)
	local time = util.getTime()
	local change_table = melee.isPlayerTransformed(player) and overlay.partner_percent_updated or overlay.percent_updated
	return change_table[slot] + 0.25 > time
end

function overlay.didPartnerPercentChange(slot)
	local time = util.getTime()
	return overlay.partner_percent_updated[slot] + 0.25 > time
end

memory.hook("player.*.stocks", "Overlay - Player Stocks", function(player, stocks)
	local now = util.getTime()

	overlay.stats.mode_skipped = overlay.stats.mode
	overlay.stats.updated = now
	overlay.stats.stop = now + 5
	overlay.stats.mode = 2
end)

function overlay.printCenteredInBox(text, boxX, boxY, boxW, boxH)
	local font = love.graphics.getFont()
	love.graphics.print( text, boxX + boxW/2 - font:getWidth(text)/2, boxY + boxH/2 - font:getHeight()/4 )
end

function overlay.getHeadInfo(id)
	if not overlay.texture_cache["heads"][id] then
		return overlay.texture_cache["heads"][0x21]
	end
	return overlay.texture_cache["heads"][id]
end

function overlay.drawPlayerIcon(id, ...)
	if overlay.texture_cache["players"][id] then
		love.graphics.easyDraw(overlay.texture_cache["players"][id], ...)
	end
end

function overlay.drawStockIcon(id, skin, ...)
	if not overlay.texture_cache[id] then
		overlay.texture_cache[id] = {}
	end
	if not overlay.texture_cache[id][skin] then
		local info = overlay.textures[id]
		if not info or not info.skin then return end

		local icon = info.icon
		local color = info.skin[skin+1]
		if not icon or not color then
			return error(("Failed to get skin info for %i - %i"):format(id, skin))
		end

		overlay.texture_cache[id][skin] = love.graphics.newImage(("textures/stocks/%s-%s.png"):format(icon, color))
	end
	if overlay.texture_cache[id][skin] then
		love.graphics.easyDraw(overlay.texture_cache[id][skin], ...)
	end
end

function overlay.drawSeriesIcon(id, ...)
	if not overlay.texture_cache[id] then
		overlay.texture_cache[id] = {}
	end
	if not overlay.texture_cache[id]["series"] then
		local info = overlay.textures[id]
		if not info then return end

		local series = info.series
		if not series then
			return error(("Failed to get series info for %i"):format(id))
		end

		overlay.texture_cache[id]["series"] = love.graphics.newImage(("textures/series/%s.png"):format(series))
	end
	if overlay.texture_cache[id]["series"] then
		love.graphics.easyDraw(overlay.texture_cache[id]["series"], ...)
	end
end

do
	local active = {}
	local num = 1

	function overlay.getActivePlayers()
		num = 1
		for i=1,4 do
			if memory.player[i].mode ~= PLAYER.DISABLED then
				active[num] = i
				num = num + 1
			else
				active[i] = nil
			end
		end
		return active
	end
end

function overlay.getPercent(slot)
	local entity = melee.getPlayerEntity(slot)
	return math.min(entity.percent, 999)
end

function HSLtoRGB(h, s, l)
	if s == 0 then return l,l,l end
	h, s, l = h/360*6, math.min(math.max(0, s), 1), math.min(math.max(0, l), 1)
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-0.5*c), 0,0,0
	if h < 1		then r,g,b = c,x,0
	elseif h < 2	then r,g,b = x,c,0
	elseif h < 3	then r,g,b = 0,c,x
	elseif h < 4	then r,g,b = 0,x,c
	elseif h < 5	then r,g,b = x,0,c
	else				 r,g,b = c,0,x
	end
	return math.floor((r+m)*255), math.floor((g+m)*255), math.floor((b+m)*255)
end

local color_white = {255, 255, 255, 255}
local color_black = {0, 0, 0, 255}
local color_yellow = {255, 255, 0, 255}
local color_red = {230, 0, 0, 255}
local color_green = {34, 177, 76, 255}

--[[
0-10% = White
10-35 = white -> yellow {255, 205, 0}

HSL	= 60, 1, 1
10%	= 60, 1, 1
35%	= 50, 1, 0.5
100 = 0, 1, 0.5
100 = 360, 1, 0.5
200 = 343, 1, 0.33
300 = 343, 1, 0.34
999 = 344, 1, 0.24
]]

local function colorFade(from, to, frac)
	local rf, gf, bf, af = 255, 255, 255, 255
	local rfrac = (1 - frac)
	rf = (from[1] * rfrac) + to[1] * frac
	gf = (from[2] * rfrac) + to[2] * frac
	bf = (from[3] * rfrac) + to[3] * frac
	return rf, gf, bf, af
end

local function cerp(a,b,t) local f=(1-math.cos(t*math.pi))*.5 return a*(1-f)+b*f end
local function lerp(a,b,t) return (1-t)*a + t*b end
local function lerp2(a,b,t) return a+(b-a)*t end

local function ease_elastic(t, times)
 	return (1 - (math.exp(-12*t) + math.exp(-6*t) * math.cos(((times or 6) + 0.5) * math.pi * t))/2)/0.99999692789382332858
end

local function ease_outback(t, param)
	t = 1-t
	return 1-t*t*(t+(t-1)*(param or 1.701540198866824))
end

function overlay.getPercentColor(percent)
	if percent <= 10 then
		return color_white
	elseif percent <= 35 then
		local fade = (percent-10)/25
		return HSLtoRGB(lerp(60, 50, fade), 1, lerp(1, 0.5, fade))
	elseif percent <= 100 then
		local fade = (percent-35)/65
		return HSLtoRGB(lerp(50, 0, fade), 1, 0.5)
	elseif percent <= 200 then
		local fade = (percent-100)/100
		return HSLtoRGB(lerp(360, 344, fade), 1, lerp(0.5, 0.33, fade))
	end
	local fade = (percent-200)/799
	return HSLtoRGB(344, 1, lerp(0.33, 0.24, fade))
end

function overlay.getCharacterID(slot)
	local player = memory.player[slot]

	if not player then return CHARACTER.NONE end

	local character = player.character
	local transformed = player.transformed == 256

	-- Handle and detect Zelda/Sheik transformations
	if character == CHARACTER.SHEIK then
		character = transformed and CHARACTER.ZELDA or CHARACTER.SHEIK
	elseif character == CHARACTER.ZELDA then
		character = transformed and CHARACTER.SHEIK or CHARACTER.ZELDA
	end

	return character
end

-- Used if the overlay is set to "Ultimate" mode
function overlay.drawHeadHUDImage(character, color, x, y, r, width, height, ...)
	local head = overlay.texture_cache["heads"][character]

	if not head then return end

	love.graphics.setColor(color)
	love.graphics.easyDraw(overlay.hud_player_bg, x, y, r, width, height, ...)

	-- All of smash ultimates Portrait images use a canvas size of 162x162
	-- Some images are larger/smaller because of hair, ears, hats, etc..
	-- We Want to draw the same region of pixels, originating from the center of the image
	local canvasW, canvascH = 162, 162
	local imgW, imgH = head.hud:getWidth(), head.hud:getHeight()

	-- Scale the canvas based on the dimensions we want to draw
	local scaledCanvasW = (width/canvasW) * canvasW
	local scaledCanvasH = (height/canvascH) * canvascH

	-- The new width/height to draw
	local drawW = (imgW/canvasW) * width
	local drawH = (imgH/canvascH) * height

	-- Adjust position based on how much the image overflows/underflows from the canvas
	x = x + (scaledCanvasW/2) - (drawW/2)
	y = y + (scaledCanvasH/2) - (drawH/2)

	-- Boom
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.easyDraw(head.hud, x, y, r, drawW, drawH, 0, 0)
end

function overlay.drawHeadImage(slot, left, x, y, w, h)
	local player = memory.player[slot]
	local cid = overlay.getCharacterID(slot)
	local head = overlay.getHeadInfo(cid)

	love.graphics.push("transform")
		local s = w/8 -- How many pixels to slant

		love.graphics.translate(x, y)
		local myStencilFunction = function()
			if left == true then
				love.graphics.polygon("fill",
					0, 0,
					s, h,
					w, h,
					w - s, 0)
			else
				love.graphics.polygon("fill",
					s, 0,
					0, h,
					w - s, h,
					w, 0)
			end
		end
		love.graphics.stencil(myStencilFunction, "replace", 1)
		love.graphics.setStencilTest("greater", 0)
		love.graphics.setColor(255, 255, 255, 255)

		local img = head.image
		local iW, iH = img:getWidth(), img:getHeight()

		if (left and head.right) or (not left and not head.right) then
			love.graphics.easyDraw(img, 0, 0, 0, w, h, 0, 0)
		else
			love.graphics.easyDraw(img, 0, 0, 0, -w, h, 1, 0)
		end
		love.graphics.setStencilTest()

		love.graphics.setColor(0, 0, 0, 255)

		local cH = 12 -- How tall our color bar should be
		local ss = cH / (h / s)

		if left == true then
			love.graphics.polygon("line",
				0, 0,
				s, h,
				w, h,
				w - s, 0)

			love.graphics.setColor(melee.getPlayerColor(player))
			love.graphics.polygon("fill",
				s, h,
				s + ss, h + cH,
				w + ss, h + cH,
				w, h)
			love.graphics.setColor(0, 0, 0, 255)
			love.graphics.polygon("line",
				s, h,
				s + ss, h + cH,
				w + ss, h + cH,
				w, h)
		else
			love.graphics.polygon("line",
				s, 0,
				0, h,
				w - s, h,
				w, 0)

			love.graphics.setColor(melee.getPlayerColor(player))
			love.graphics.polygon("fill",
				0, h,
				0 - ss, h + cH,
				w - s - ss, h + cH,
				w - s, h)
			love.graphics.setColor(0, 0, 0, 255)
			love.graphics.polygon("line",
				0, h,
				0 - ss, h + cH,
				w - s - ss, h + cH,
				w - s, h)
		end
	love.graphics.pop()
end

function overlay.textOutlinef(text, width, x, y, ...)
	local steps = ( width * 2 ) / 3
	if ( steps < 1 ) then steps = 1 end

	for _x = -width, width, steps do
		for _y = -width, width, steps do
			love.graphics.printf(text, x + _x, y + _y, ...)
		end
	end
end

function overlay.textOutline(text, width, x, y, ...)
	local steps = ( width * 2 ) / 3
	if ( steps < 1 ) then steps = 1 end

	for _x = -width, width, steps do
		for _y = -width, width, steps do
			love.graphics.print(text, x + _x, y + _y, ...)
		end
	end
end

function overlay.drawTimer(now)
	local timerX = 1280 - 58 - 16
	local timerY = 16

	local minutes = math.floor(memory.timer.seconds/ 60)
	local seconds = math.floor(memory.timer.seconds % 60)
	local millis = 60 - memory.timer.millis

	local timer = ("%i:%02i."):format(minutes, seconds)
	local milli = ("%02i"):format(millis)

	local timerW, timerH = overlay.fonts.large:getWidth(timer), overlay.fonts.large:getHeight()
	local milliW, milliH = overlay.fonts.medium:getWidth(milli), overlay.fonts.medium:getHeight()

	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.setFont(overlay.fonts.large)
	overlay.textOutline(timer, 2, timerX - timerW - milliW + 1, timerY + 1)
	love.graphics.setFont(overlay.fonts.medium)
	overlay.textOutline(milli, 2, timerX - milliW + 1, timerY + (timerH - milliH - 8) + 1)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(overlay.fonts.large)
	love.graphics.print(timer, timerX - timerW - milliW, timerY)
	love.graphics.setFont(overlay.fonts.medium)
	love.graphics.print(milli, timerX - milliW, timerY + (timerH - milliH - 8))

end

function overlay.drawPercent(now, slot, x, y)
	if memory.menu ~= MENU.IN_GAME then return end

	local player = melee.getPlayer(slot)

	if not player then return end

	love.graphics.push("transform")
		love.graphics.translate(x, y)

		local character = overlay.getCharacterID(slot)
		local stocks = math.min(player.stocks, 99)
		local color = melee.getPlayerColor(player)

		love.graphics.setColor(color[1], color[2], color[3], 200)
		overlay.drawSeriesIcon(character, 0, 8, 0, 128, 128)

		--[[love.graphics.setColor(255, 255, 255, 255)
		overlay.drawPlayerIcon(slot, -12, 2)]]

		if stocks > 0 then
			local percent = overlay.getPercent(slot)
			local display = ("%i"):format(percent)
			local decimal = (".%i%%"):format(math.floor(percent%1*10))

			local sx, sy = 0, 0

			-- Do a little random motion when getting hit
			if overlay.didPercentChange(slot) then
				sx = math.random(-8, 8)
				sy = math.random(-8, 8)
			end

			local decimalW = overlay.fonts.sub_percent:getWidth(decimal)
			local percentW = overlay.fonts.percent:getWidth(display)

			local pX, pY = sx + 128 - decimalW - percentW + 6, 40 + sy

			love.graphics.setFont(overlay.fonts.percent)
			love.graphics.setColor(0, 0, 0, 255)
			overlay.textOutline(display, 4, pX + 2, pY + 2, 0, 1, 1, 0, 0, -0.15, 0)
			love.graphics.setColor(overlay.getPercentColor(percent))
			love.graphics.print(display, pX, pY, 0, 1, 1, 0, 0, -0.15, 0)

			local dX, dY = sx + 128 - decimalW, 78 + sy

			love.graphics.setFont(overlay.fonts.sub_percent)

			love.graphics.setColor(0, 0, 0, 255)
			overlay.textOutline(decimal, 2, dX + 1, dY + 1, 0, 1, 1, 0, 0, -0.15, 0)
			love.graphics.setColor(overlay.getPercentColor(percent))
			love.graphics.print(decimal, dX, dY, 0, 1, 1, 0, 0, -0.15, 0)

			if character == CHARACTER.CLIMBERS and player.partner.action_state ~= 0xB then
				local display = ("%.1f%%"):format(player.partner.percent)

				local sx, sy = 0, 0
				if overlay.didPartnerPercentChange(slot) then
					sx = math.random(-8, 8)
					sy = math.random(-8, 8)
				end

				love.graphics.setColor(0, 0, 0, 255)
				overlay.textOutlinef(display, 2, sx - 40 + 8, 112 + sy, 128, "right", 0, 1, 1, 0, 0, -0.15, 0)
				love.graphics.setColor(overlay.getPercentColor(player.partner.percent))
				love.graphics.printf(display, sx - 40 + 8, 112 + sy, 128, "right", 0, 1, 1, 0, 0, -0.15, 0)

				love.graphics.setColor(255, 255, 255, 255)
				overlay.drawStockIcon(character, overlay.nana_skins[player.skin] or 0, 40 + 64, 112)
			end

			love.graphics.setColor(255, 255, 255, 255)

			local sX, sY = 0, 6

			if stocks <= 4 then
				for i=0, stocks-1 do
					overlay.drawStockIcon(character, player.skin, sX + (24*i), sY, 0, 24, 24)
				end
			else
				local display = ("x%d"):format(stocks)

				love.graphics.setFont(overlay.fonts.medium)
				love.graphics.setColor(0, 0, 0, 255)
				overlay.textOutlinef(display, 2, sX + 1, sY + 4 + 1, 48, "right")
				love.graphics.setColor(255, 255, 255, 255)
				love.graphics.printf(display, sX, sY + 4, 48, "right")

				local w = overlay.fonts.medium:getWidth(display)

				overlay.drawStockIcon(character, player.skin, sX, sY, 0, 24, 24)
			end
		end
	love.graphics.pop()
end

local minimapFadeTime = 0.5
local minimapFadeEnd = 0

-- Draw an offscreen minimap like in Ultimate
function overlay.drawMinimap(now)
	for i=1,4 do
		local player = melee.getPlayer(i)

		-- Only show the overlay if the player entity is active, not respawning, and outside the bounds of the camera limits
		if		(melee.isEntityActive(player.entity) and not melee.isEntityRespawning(player.entity) and melee.isEntityOffCamera(player.entity))
			or	(melee.isEntityActive(player.partner) and not melee.isEntityRespawning(player.partner) and melee.isEntityOffCamera(player.partner)) then
			minimapFadeEnd = util.getTime() + minimapFadeTime
		end
	end

	-- If the timer is greater than the current time, that means someone is outside the camera bounds
	if minimapFadeEnd < now then return end

	-- Fade out the box when the minimapFadeEnd value stops updating
	local fade = math.max(0, minimapFadeEnd - now)/minimapFadeTime

	-- Top right corner of the overlay
	local minimapPosx = 1280 - 58 - 16
	local minimapPosY = 56

	-- The width/height of the minimap box
	local minimapW, minimapH = 192, 96

	-- Draw the minimap background
	love.graphics.setColor(0, 0, 0, 100 * fade)
	love.graphics.rectangle("fill", minimapPosx - minimapW, minimapPosY, minimapW, minimapH)
	love.graphics.setColor(0, 0, 0, 200 * fade)
	love.graphics.rectangle("line", minimapPosx - minimapW, minimapPosY, minimapW, minimapH)

	local zone = memory.stage.blastzone
	local stageW = zone.right - zone.left
	local stageH = zone.top - zone.bottom

	-- The scale we need to apply to the players positional values
	local x_scale = minimapW / stageW
	local y_scale = minimapH / stageH

	-- Scale the camera limits
	local camera = memory.camera.limit
	local camW = (camera.right - camera.left) * x_scale
	local camH = (camera.top - camera.bottom) * y_scale

	-- Draw the camera limit as a white box within the minimap
	love.graphics.setColor(255, 255, 255, 200 * fade)
	love.graphics.rectangle("line", minimapPosx - (minimapW/2) - (camW/2), minimapPosY + (minimapH/2) - (camH/2), camW, camH)

	for i=1,4 do
		local player = memory.player[i]
		local color = melee.getPlayerColor(player)
		love.graphics.setColor(color[1], color[2], color[3], 255*fade)

		-- Draw the main entity for the player on the minimap
		if melee.isEntityActive(player.entity) then
			local pos = player.position
			local x = (minimapW/2) - (pos.x * x_scale)
			local y = (minimapH/2) - (pos.y * y_scale)
			love.graphics.easyDraw(overlay.minimap_circle, minimapPosx - x, minimapPosY + y, 0, 12, 12, 0.5, -1)
		end

		-- This should only happen for ice-climbers or zelda/sheik
		-- but draw the secondary entity for the player on the minimap
		if melee.isEntityActive(player.partner) then
			local pos = player.partner_position
			local x = (minimapW/2) - (pos.x * x_scale)
			local y = (minimapH/2) - (pos.y * y_scale)
			love.graphics.easyDraw(overlay.minimap_circle, minimapPosx - x, minimapPosY + y, 0, 12, 12, 0.5, -1)
		end
	end
end

function overlay.draw()
	-- The overlay only draws while in a match
	if memory.menu ~= MENU.IN_GAME then return end

	local now = util.getTime()

	local active = overlay.getActivePlayers()

	if #active <= 2 then
		overlay.drawPercent(now, active[1], 128, 720 - 172)
		overlay.drawPercent(now, active[2], 1280 - 256, 720 - 172)
	else
		overlay.drawPercent(now, active[1], 152, 720 - 172)
		overlay.drawPercent(now, active[2], 256 + 128 + 32, 720 - 172)
		overlay.drawPercent(now, active[3], 1280 - 256 - 128 - 192, 720 - 172)
		overlay.drawPercent(now, active[4], 1280 - 256 - 32, 720 - 172)
	end

	overlay.drawTimer(now)
	overlay.drawMinimap(now)

	--[[love.graphics.setFont(overlay.fonts.small)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("FPS: " .. love.timer.getFPS(), 4, 0)]]
end

return overlay