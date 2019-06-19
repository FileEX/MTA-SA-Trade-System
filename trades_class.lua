--[[
	Author: FileEX
]]

TradeClass = {};
setmetatable(TradeClass, {__call = function(o) return o:constructor(); end, __index = TradeClass});

local screenX, screenY = guiGetScreenSize();

local floor = math.floor;

local textures = {'add_hover', 'bg', 'box', 'btn_accept', 'btn_decline', 'car', 'house', 'PLN', 'pp'};

local tex = {};
-- ignore ids like planes, boats etc. map table
local ignoreIDs = {--[[airplanes]][592] = true, [577] = true, [511] = true, [512] = true, [593] = true, [520] = true, [553] = true, [476] = true, [519] = true, [460] = true, [513] = true, [548] = true, [425] = true, [417] = true, [487] = true, [488] = true, [497] = true, [563] = true, [447] = true, [469] = true, --[[boats]][472] = true, [473] = true, [493] = true, [595] = true, [484] = true, [430] = true, [453] = true, [452] = true, [446] = true, [454] = true, --[[bikes only]][509] = true, [481] = true, [510] = true, --[[utils vehicles]][485] = true, [431] = true, [438] = true, [437] = true, [574] = true, [420] = true, [525] = true, [408] = true, [552] = true, [416] = true, [433] = true, [427] = true, [490] = true, [528] = true, [407] = true, [544] = true, [523] = true, [470] = true, [596] = true, [597] = true, [598] = true, [599] = true, [597] = true, [432] = true, [601] = true, [428] = true, [499] = true, [609] = true, [498] = true, [524] = true, [532] = true, [578] = true, [486] = true, [406] = true, [573] = true, [455] = true, [588] = true, [403] = true, [423] = true, [414] = true, [443] = true, [515] = true, [514] = true, [531] = true, [456] = true, [530] = true, [459] = true, [422] = true, [572] = true, [582] = true, [583] = true, [442] = true, [409] = true, [505] = true, [494] = true, [502] = true, [503] = true, [441] = true, [464] = true, [594] = true, [501] = true, [465] = true, [564] = true, --[[trailers]][606] = true, [607] = true, [610] = true, [584] = true, [611] = true, [608] = true, [435] = true, [450] = true, [591] = true, --[[railroads]][590] = true, [538] = true, [570] = true, [569] = true, [537] = true, [449] = true, --[[others utility]][504] = true, [571] = true, [444] = true, [556] = true, [557] = true, [539] = true};

local vehicleNames = {};

local renderData = {
	bg = {(screenX / 2) - 0.16 * screenX * 1.2, 0.15 * screenY * 1.3, 0.38 * screenX * 1.2, 0.41 * screenY * 1.3},
	boxes = {
		-- top
		{(screenX / 2) - 0.125 * screenX * 1.2, 0.37 * screenY * 1.3, 0.055 * screenX * 1.2, 0.082 * screenY * 1.3},
		{(screenX / 2) - 0.065 * screenX * 1.2, 0.37 * screenY * 1.3, 0.055 * screenX * 1.2, 0.082 * screenY * 1.3},
		{(screenX / 2) - 0.005 * screenX * 1.2, 0.37 * screenY * 1.3, 0.055 * screenX * 1.2, 0.082 * screenY * 1.3},
		{(screenX / 2) + 0.056 * screenX * 1.2, 0.37 * screenY * 1.3, 0.055 * screenX * 1.2, 0.082 * screenY * 1.3},
		{(screenX / 2) + 0.116 * screenX * 1.2, 0.37 * screenY * 1.3, 0.055 * screenX * 1.2, 0.082 * screenY * 1.3},
		-- bottom
		{(screenX / 2) - 0.125 * screenX * 1.2, 0.22 * screenY * 1.3, 0.055 * screenX * 1.2, 0.082 * screenY * 1.3},
		{(screenX / 2) - 0.065 * screenX * 1.2, 0.22 * screenY * 1.3, 0.055 * screenX * 1.2, 0.082 * screenY * 1.3},
		{(screenX / 2) - 0.005 * screenX * 1.2, 0.22 * screenY * 1.3, 0.055 * screenX * 1.2, 0.082 * screenY * 1.3},
		{(screenX / 2) + 0.056 * screenX * 1.2, 0.22 * screenY * 1.3, 0.055 * screenX * 1.2, 0.082 * screenY * 1.3},
		{(screenX / 2) + 0.116 * screenX * 1.2, 0.22 * screenY * 1.3, 0.055 * screenX * 1.2, 0.082 * screenY * 1.3},
	},
	buttons = {
		-- accept
		{(screenX / 2) - 0.065 * screenX * 1.2, 0.52 * screenY * 1.3, 0.086 * screenX * 1.2, 0.03 * screenY * 1.3},
		-- decline
		{(screenX / 2) + 0.056 * screenX * 1.2, 0.52 * screenY * 1.3, 0.086 * screenX * 1.2, 0.03 * screenY * 1.3},
		-- add item
		--{(screenX / 2) - 0.125 * screenX * 1.2, 0.475 * screenY * 1.3, 0.034 * screenX * 1.2, 0.051 * screenY * 1.3},
	},

	texts = {
		-- title
		{(screenX / 2) - 0.05 * screenX * 1.2, 0.165 * screenY * 1.3, 0, 0},
		-- accept / wait
		--{(screenX / 2) - 0.065 * screenX * 1.2, 0.479 * screenY * 1.3, 0, 0},
		{(screenX / 2) - 0.16 * screenX * 1.2, 0.479 * screenY * 1.3, (screenX / 2) - 0.16 * screenX * 1.2 + 0.38 * screenX * 1.2, 0},

		-- tab1
		{0.0405 * screenX * 1.2, 0.1825 * screenY * 1.3, 0, 0},
		-- tab2
		{0.1195 * screenX * 1.2, 0.1825 * screenY * 1.3, 0, 0},
		-- tab3
		{0.1985 * screenX * 1.2, 0.1825 * screenY * 1.3, 0, 0},

		-- edit title
		{(screenX / 2) - 0.085 * screenX * 1.2, 0.285 * screenY * 1.3, (screenX / 2) - 0.085 * screenX * 1.2 + 0.25 * screenX * 1.2,  0.285 * screenY * 1.3 + 0.0225 * screenY * 1.3},
		
		-- edit info
		{(screenX / 2) - 0.04050 * screenX * 1.2, 0.319 * screenY * 1.3},
	},

	win = {0.02 * screenX * 1.2, 0.1725 * screenY * 1.3, 0.235 * screenX * 1.2, 0.369 * screenY * 1.3},
	tabs = {
		-- cars
		{0.02 * screenX * 1.2, 0.1725 * screenY * 1.3, 0.075 * screenX * 1.2, 0.035 * screenY * 1.3},
		-- houses
		{0.099 * screenX * 1.2, 0.1725 * screenY * 1.3, 0.075 * screenX * 1.2, 0.035 * screenY * 1.3},
		-- others
		{0.178 * screenX * 1.2, 0.1725 * screenY * 1.3, 0.075 * screenX * 1.2, 0.035 * screenY * 1.3},
	},

	rowStart = {0.025 * screenX * 1.2, 0.3025 * screenY * 1.3, 0.034 * screenX * 1.2, 0.051 * screenY * 1.3, 0.5 * screenX * 1.2, 0.5 * screenY * 1.3, 0.145 * screenY * 1.3},
	infoWin = {0.150 * screenX * 1.2, 0.20 * screenY * 1.3},

	editFrame = {(screenX / 2) - 0.085 * screenX * 1.2, 0.285 * screenY * 1.3, 0.25 * screenX * 1.2, 0.16 * screenY * 1.3, 0.0225 * screenY * 1.3, (screenX / 2) - 0.075 * screenX * 1.2, 0.4075 * screenY * 1.3, 0.075 * screenX * 1.2, 0.035 * screenY * 1.3, (screenX / 2) + 0.080 * screenX * 1.2, (screenX / 2) - 0.050 * screenX * 1.2, 0.340 * screenY * 1.3, 0.19 * screenX * 1.2},
};
-- calc static offset
local constStackOffset = renderData['rowStart'][4] - (0.013 * screenY * 1.3);
local constStackOffset2 = renderData['rowStart'][4] + (0.0075 * screenY * 1.3);

local multiplerY = 0.052991453 * screenY * 1.3;

function TradeClass:constructor()
	self.__init = function()
		self.secPlayer = false;
		self.textColor = 0xFF00FF00;
		self.waitTimer = false;
		self.accepted = false;
		self.reSeconds = 0;
		self.items = {};
		self.pItems = {};
		self.text = "";
		self.activeTab = 1;
		self.scroll = 0;
		self.visibleRows = 6;
		self.columns = 3;
		self.rows = 0;
		self.selectedTab = 1;
		self.stack = false;
		self.space = "                             ";
		self.slots = {};
		for i = 1,5 do
			self.slots[i] = 0;
			self.items[i] = 0;
		end
		self.editFrame = false;
		self.stackType = '';
		self.locked = false;
	end

	self.onRender = function() self:render(self); end;
	self.onClick = function(btn, state) self:click(btn,state); end;
	self.font = exports['rm_gui']:fonts_getFont(16, 'regular');

	self.findFreeSlot = function()
		local fI = -1;
		for i = 1,10 do
			if self.slots[i] == 0 then
				fI = i;
				break;
			end
		end

		return fI;
	end

	self.unloadVehicleNames = function()
		for i = 1, #vehicleNames do
			table.remove(vehicleNames, i);
		end

		--- recreate empty table
		vehicleNames = {};
	end

	self.loadVehicleNames = function()
		for i = 400, 611 do
			if not ignoreIDs[i] then
				table.insert(vehicleNames, getVehicleNameFromModel(i));
			else
				table.insert(vehicleNames, 'unknown'); -- FIX
			end
		end
	end

	self.loadTextures = function(_,b)
		if b then
			for k,v in pairs(textures) do
				tex[k] = DxTexture('i/'..v..'.png','argb',false,'clamp');
			end
		else
			for k,v in pairs(tex) do
				v:destroy();
				table.remove(tex, k);
			end

			tex = {};
		end
	end

	self.formatPattern = function(_, i)
		if i == 1 then
			return 'sekundę';
		end

		if (i % 10 > 1) and (i % 10 < 5) and (not ((i % 100 >= 10) and (i % 10 >= 10))) then
			return 'sekundy';
		else
			return 'sekund';
		end
	end

	self.showEditFrame = function(_,b)
		if b then
			exports['rm_gui']:dxCreateButton('acpBtn', renderData['editFrame'][6], renderData['editFrame'][7], renderData['editFrame'][8], renderData['editFrame'][9], 'Akceptuj', 180);
			exports['rm_gui']:dxSetStatusButton('acpBtn', true);
			exports['rm_gui']:dxCreateButton('cncBtn', renderData['editFrame'][10], renderData['editFrame'][7], renderData['editFrame'][8], renderData['editFrame'][9], 'Anuluj', 180);
			exports['rm_gui']:dxSetStatusButton('cncBtn', true);

			exports['rm_editbox']:create('', 'nField', renderData['editFrame'][11], renderData['editFrame'][12], renderData['editFrame'][13], renderData['editFrame'][9], '', false, 9, false, false, true, false, false);
		else
			exports['rm_gui']:dxDestroyButton('acpBtn');
			exports['rm_gui']:dxDestroyButton('cncBtn');

			exports['rm_editbox']:destroy('nField');
		end

		Timer(function() -- small bug fix
			self.editFrame = b;
		end, 50, 1);
	end

	self.showUI = function(_,b)
		_G[b and 'addEventHandler' or 'removeEventHandler']('onClientRender', root, self.onRender);
		_G[b and 'addEventHandler' or 'removeEventHandler']('onClientClick', root, self.onClick);
		showCursor(b)

		self:loadTextures(b);

		self:loadVehicleNames();

		if b then
			triggerServerEvent('getClientData', localPlayer, 'vehicles');
		end
	end

	self.__init();
	return self;
end

function TradeClass:SyncPlayer(s)
	self.secPlayer = s;
end

function TradeClass:lockTimer()
	self.reSeconds = lockTime;
	self.textColor = 0xFFFFFFFF;
	self.text = 'Zaczekaj '..lockTime..' '..self:formatPattern(lockTime);
	if self.waitTimer and self.waitTimer.valid then
		self.waitTimer:destroy();
	end

	self.waitTimer = Timer(function()
		self.reSeconds = self.reSeconds - 1;
		self.text = 'Zaczekaj '..self.reSeconds..' '..self:formatPattern(self.reSeconds);
		if self.reSeconds == 0 then
			self.waitTimer = false;
			self.text = '';
		end
	end, 1000, lockTime);
end

function TradeClass:render()
	--bg
	dxDrawImage(renderData['bg'][1], renderData['bg'][2], renderData['bg'][3], renderData['bg'][4], tex[2], 0,0,0, 0xFFFFFFFF, false);

	for i = 1,10 do
		dxDrawImage(renderData['boxes'][i][1], renderData['boxes'][i][2], renderData['boxes'][i][3], renderData['boxes'][i][4], tex[3], 0, 0, 0, 0xFFFFFFFF, false);
		if i <= 5 then
			-- their items
			if self.slots[i] ~= 0 then
				local data = self.slots[i].tbl;
				local sl = data.slot;

				if (not data.stack and data.selected) or (not data.selected and data.stack) then
					dxDrawImage(renderData['boxes'][sl][1], renderData['boxes'][sl][2], renderData['boxes'][sl][3], renderData['boxes'][sl][4], data.icon, 0, 0, 0, 0xFFFFFFFF, false);
					
					if data.value then
						dxDrawText('x'..data.value, renderData['boxes'][sl][1], renderData['boxes'][sl][2] + constStackOffset2, 0, 0, 0xFFFFFFFF, 1.2, self.font);
					end

					if not data.stack and isMouseInPosition(renderData['boxes'][sl][1], renderData['boxes'][sl][2], renderData['boxes'][sl][3], renderData['boxes'][sl][4]) then
						local cx, cy = getCursorPosition();
						local cx, cy = cx * screenX, cy * screenY;

						dxDrawRectangle(cx, cy, renderData['infoWin'][1], renderData['infoWin'][2], 0xFF474747, true);
						if data.dataType == 'vehicle' then
							dxDrawText("\t\t"..self.space.."Informacje:\nPojazd: "..vehicleNames[data.model - 399].."\nUID: "..data.id.."\nPrzebieg: "..data.mileage.." km\nSilnik: "..data.engine.."\nW przechowalni: "..(data.parking == 0 and "Nie" or "Tak"), cx, cy, 0,0, 0xFFFFFFFF, 0.95, self.font, 'left', 'top', false, false, true);
						elseif data.dataType == 'house' then
							-- TODO
						end
					end
				end
			end
		end
	end

		-- their items MUSTE BE IN OTHER LOOOP
	for i = 1,5 do
		if self.items[i] ~= 0 then
			local data = self.items[i]; 
			local sl = data.slot + 5;

			dxDrawImage(renderData['boxes'][sl][1], renderData['boxes'][sl][2], renderData['boxes'][sl][3], renderData['boxes'][sl][4], data.icon, 0, 0, 0, 0xFFFFFFFF, false);
			if data.value then
				dxDrawText('x'..data.value, renderData['boxes'][sl][1], renderData['boxes'][sl][2] + constStackOffset2, 0, 0, 0xFFFFFFFF, 1.2, self.font);
			end

			if not data.stack and isMouseInPosition(renderData['boxes'][sl][1], renderData['boxes'][sl][2], renderData['boxes'][sl][3], renderData['boxes'][sl][4]) then
				local cx, cy = getCursorPosition();
				local cx, cy = cx * screenX, cy * screenY;

				dxDrawRectangle(cx, cy, renderData['infoWin'][1], renderData['infoWin'][2], 0xFF474747, true);
				if data.dataType == 'vehicle' then
					dxDrawText("\t\t"..self.space.."Informacje:\nPojazd: "..vehicleNames[data.model - 399].."\nUID: "..data.id.."\nPrzebieg: "..data.mileage.." km\nSilnik: "..data.engine.."\nW przechowalni: "..(data.parking == 0 and "Nie" or "Tak"), cx, cy, 0,0, 0xFFFFFFFF, 0.95, self.font, 'left', 'top', false, false, true);
				elseif data.dataType == 'house' then
					-- TODO
				end
			end
		end
	end

	-- buttons
	dxDrawImage(renderData['buttons'][1][1], renderData['buttons'][1][2], renderData['buttons'][1][3], renderData['buttons'][1][4], tex[4], 0, 0, 0, 0xFFFFFFFF, false);
	dxDrawImage(renderData['buttons'][2][1], renderData['buttons'][2][2], renderData['buttons'][2][3], renderData['buttons'][2][4], tex[5], 0, 0, 0, 0xFFFFFFFF, false);
	--dxDrawImage(renderData['buttons'][3][1], renderData['buttons'][3][2], renderData['buttons'][3][3], renderData['buttons'][3][4], tex[1], 0, 0, 0, 0xFFFFFFFF, false);
	-- texts
	dxDrawText("Panel wymiany (z graczem: "..self.secPlayer.name..")", renderData['texts'][1][1], renderData['texts'][1][2], renderData['texts'][1][3], renderData['texts'][1][4], 0xFFFFFFFF, 1.2, self.font);
	--dxDrawText("Panel wymiany (z graczem: "..(self.secPlayer and self.secPlayer.name or "")..")", renderData['texts'][1][1], renderData['texts'][1][2], renderData['texts'][1][3], renderData['texts'][1][4], 0xFFFFFFFF, 1.2, self.font);
	dxDrawText(self.text, renderData['texts'][2][1], renderData['texts'][2][2], renderData['texts'][2][3], renderData['texts'][2][4], self.textColor, 1.2, self.font, 'center', 'top');

	-- items window
	dxDrawRectangle(renderData['win'][1], renderData['win'][2], renderData['win'][3], renderData['win'][4], 0xFF232323, false);
	-- tabs
	dxDrawRectangle(renderData['tabs'][1][1], renderData['tabs'][1][2], renderData['tabs'][1][3], renderData['tabs'][1][4], (self.selectedTab == 1 and 0xFF373737 or 0xFF2D2D2D), false);
	dxDrawText('Pojazdy', renderData['texts'][3][1], renderData['texts'][3][2], renderData['texts'][3][3], renderData['texts'][3][4], 0xFFFFFFFF, 1.05, self.font);
	dxDrawRectangle(renderData['tabs'][2][1], renderData['tabs'][2][2], renderData['tabs'][2][3], renderData['tabs'][2][4], (self.selectedTab == 2 and 0xFF373737 or 0xFF2D2D2D), false);
	dxDrawText('Domki', renderData['texts'][4][1], renderData['texts'][4][2], renderData['texts'][4][3], renderData['texts'][4][4], 0xFFFFFFFF, 1.05, self.font);
	dxDrawRectangle(renderData['tabs'][3][1], renderData['tabs'][3][2], renderData['tabs'][3][3], renderData['tabs'][3][4], (self.selectedTab == 3 and 0xFF373737 or 0xFF2D2D2D), false);
	dxDrawText('Inne', renderData['texts'][5][1], renderData['texts'][5][2], renderData['texts'][5][3], renderData['texts'][5][4], 0xFFFFFFFF, 1.05, self.font);

	-- items
	for k = self.scroll + 1, self.visibleRows * self.columns + self.scroll do
		local row = (k - self.scroll - 1) % self.rows + 1;
		local column = floor((k - self.scroll  - 1) / self.rows);
		if self.pItems[k] then
			local oX, oY = renderData['rowStart'][1] + (renderData['rowStart'][5] * column), renderData['rowStart'][2] - (renderData['rowStart'][7] - row * multiplerY);
			local hover = not isMouseInPosition(oX, oY, renderData['rowStart'][3], renderData['rowStart'][4]);

			dxDrawImage(oX, oY, renderData['rowStart'][3], renderData['rowStart'][4], (hover and self.pItems[k].icon or tex[1]), 0, 0, 0, 0xFFFFFFFF, false);

			-- not stack = tab != 3 
			if not self.stack and not hover then -- FIRST FOR RENDER (STILL SUCK SO I NEED POST GUI)
				local cx, cy = getCursorPosition();
				local cx, cy = cx * screenX, cy * screenY;

				dxDrawRectangle(cx, cy, renderData['infoWin'][1], renderData['infoWin'][2], 0xFF474747, true);
				if self.pItems[k].dataType == 'vehicle' then
					dxDrawText("\t\t"..self.space.."Informacje:\nPojazd: "..vehicleNames[self.pItems[k].model - 399].."\nUID: "..self.pItems[k].id.."\nPrzebieg: "..self.pItems[k].mileage.." km\nSilnik: "..self.pItems[k].engine.."\nW przechowalni: "..(self.pItems[k].parking == 0 and "Nie" or "Tak"), cx, cy, 0,0, 0xFFFFFFFF, 0.95, self.font, 'left', 'top', false, false, true);
				elseif self.pItems[k].dataType == 'house' then
					-- TODO
				end
			end

			if not self.stack then
				if self.pItems[k].selected then
					dxDrawRectangle(oX, oY, renderData['rowStart'][3], renderData['rowStart'][4], 0x96979797, false);
				end
			end

			-- stacks
			if self.stack and hover then
				dxDrawText('x'..self.pItems[k].v, oX, oY + constStackOffset, 0, 0, 0xFFFFFFFF, 0.885, self.font);
			end
		end
	end

	-- edit
	if self.editFrame then
		dxDrawRectangle(renderData['editFrame'][1], renderData['editFrame'][2], renderData['editFrame'][3], renderData['editFrame'][4], 0xFF373737, false);
		dxDrawRectangle(renderData['editFrame'][1], renderData['editFrame'][2], renderData['editFrame'][3], renderData['editFrame'][5], 0xFF232323, false);
		dxDrawText('Informacja', renderData['texts'][6][1], renderData['texts'][6][2], renderData['texts'][6][3], renderData['texts'][6][4], 0xFFFFFFFF, 1.05, self.font, 'center', 'center');
		dxDrawText('Podaj '..(self.stackType == 'm' and 'kwotę, którą chcesz przekazać graczowi.' or 'ilość punktów, które chcesz przekazać graczowi.'), renderData['texts'][6][1], renderData['texts'][7][2], renderData['texts'][6][3], 0, 0xFFFFFFFF, 1.0115, self.font, 'center', 'top');
	end
end

function TradeClass:destructor()
	self:showUI(false);
	self:unloadVehicleNames();

	_G['self'] = nil;

	collectgarbage('collect');
end

function TradeClass:clearItemsData()
	for k,v in pairs(self.pItems) do
		table.remove(self.pItems, k);
	end
	-- new table
	self.pItems = {};
	-- restart scroll position
	self.scroll = 0;
	-- disable stacks
	self.stack = false;
end

function TradeClass:click(btn, state)
	if btn == 'left' and state == 'down' and not self.locked then
		if isMouseInPosition(renderData['buttons'][2][1], renderData['buttons'][2][2], renderData['buttons'][2][3], renderData['buttons'][2][4]) and not self.waitTimer then
			self.text = "Zrezygnowałeś z wymiany.";
			self.textColor = 0xFFFF0000;
		 	triggerServerEvent('tryCancelTrade', resourceRoot, self.secPlayer);
		 	Timer(triggerServerEvent, 1500, 1, 'cancelTrade', resourceRoot, localPlayer);
		 elseif isMouseInPosition(renderData['buttons'][1][1], renderData['buttons'][1][2], renderData['buttons'][1][3], renderData['buttons'][1][4]) and not self.waitTimer then
		 	self.text = "Zaakceptowałeś wymianę."..(self.accepted and '' or 'Drugi gracz jeszcze nie.');
		 	self.textColor = 0xFF00FF00;
		 	triggerServerEvent('infoAboutAccept', resourceRoot, self.secPlayer);
		 	-- LOCK BUTTONS FOR BUG FIX
		 	self.locked = true;

		 	if self.accepted then
		 		Timer(triggerServerEvent, 1500, 1, 'cancelTrade', resourceRoot, localPlayer);
		 	end
		 	-- ACCEPT
		elseif isMouseInPosition(renderData['tabs'][1][1], renderData['tabs'][1][2], renderData['tabs'][1][3], renderData['tabs'][1][4]) and self.selectedTab ~= 1 then
			self:clearItemsData();
			self.selectedTab = 1;
			triggerServerEvent('getClientData', localPlayer, 'vehicles');
		elseif isMouseInPosition(renderData['tabs'][2][1], renderData['tabs'][2][2], renderData['tabs'][2][3], renderData['tabs'][2][4]) and self.selectedTab ~= 2 then
			self:clearItemsData();
			self.selectedTab = 2;
			-- TODO triggerServerEvent('getClientData', localPlayer, 'houses');
		elseif isMouseInPosition(renderData['tabs'][3][1], renderData['tabs'][3][2], renderData['tabs'][3][3], renderData['tabs'][3][4]) and self.selectedTab ~= 3 then
			self:clearItemsData();
			self.selectedTab = 3;
			triggerServerEvent('getClientData', localPlayer, 'others');
		elseif isMouseInPosition(renderData['editFrame'][10], renderData['editFrame'][7], renderData['editFrame'][8], renderData['editFrame'][9]) and self.editFrame then
			self:showEditFrame(false);
		elseif isMouseInPosition(renderData['editFrame'][6], renderData['editFrame'][7], renderData['editFrame'][8], renderData['editFrame'][9]) and self.editFrame then
			local evl = tonumber(exports['rm_editbox']:getText('nField'));
			local var = self.stackType == 'm' and 1 or 2;
			local vl = self.pItems[var].v;
			if evl > 0 and evl <= vl then
				local slot = self:findFreeSlot();

				if slot ~= -1 then
					self.pItems[var].v = vl - evl;
					self.pItems[var].slot = slot;

					self.slots[slot] = {ix = var, tbl={icon = self.pItems[var].icon, stack = true, slot = slot, value = evl}, tab = 3};

					triggerServerEvent('syncItemList', resourceRoot, self.secPlayer, slot, self.slots[slot].tbl);

					self:showEditFrame(false);

					self:lockTimer();
				end
			end
		end

		for k = self.scroll + 1, self.visibleRows * self.columns + self.scroll do
			local row = (k - self.scroll - 1) % self.rows + 1;
			local column = floor((k - self.scroll  - 1) / self.rows);
			if self.pItems[k] and not self.pItems[k].selected then
				local oX, oY = renderData['rowStart'][1] + (renderData['rowStart'][5] * column), renderData['rowStart'][2] - (renderData['rowStart'][7] - row * multiplerY);
				
				if isMouseInPosition(oX, oY, renderData['rowStart'][3], renderData['rowStart'][4]) then
					local slot = self:findFreeSlot();

					if self.stack then
						-- create field before add
						if slot == -1 then
							break;
						end

						if slot ~= -1 and not self.editFrame then
							self:showEditFrame(true);

							self.stackType = (k == 1 and 'm' or 'p');
						end
					else
						if slot == -1 then
							break;
						end

						if slot ~= -1 then
							self.pItems[k].selected = true;
							self.pItems[k].slot = slot;

							if self.pItems[k].dataType == 'vehicle' then
								self.pItems[k].stack = false;
								self.slots[slot] = {ix = k, tbl = self.pItems[k], tab = 1};
							else
								-- TODO houses
							end

							-- SYNC WITH PLAYER
							triggerServerEvent('syncItemList', resourceRoot, self.secPlayer, slot, self.slots[slot].tbl);

							self:lockTimer();

							break;
						end

					end
				end
			end
		end

		if not self.editFrame then -- fix remove item when click accept on edit frame
			for i = 1,5 do
				-- their items
				if self.slots[i] ~= 0 then
					local data = self.slots[i].tbl;
					local sl = data.slot;
					if isMouseInPosition(renderData['boxes'][sl][1], renderData['boxes'][sl][2], renderData['boxes'][sl][3], renderData['boxes'][sl][4]) then
						local tab = self.slots[i].tab;						

						if not data.stack then
							if self.selectedTab == tab then
								self.pItems[self.slots[i].ix].selected = false;
							end
						else
							-- remove item for box
							if self.selectedTab == tab then
								self.pItems[self.slots[i].ix].v = self.pItems[self.slots[i].ix].v + data.value;
							end
						end
						if self.selectedTab == tab then
							self.pItems[self.slots[i].ix].slot = 0;
						end

						-- free slot
						self.slots[i] = 0;

						-- SYNC WITH PLAYER
						triggerServerEvent('syncItemList', resourceRoot, self.secPlayer, sl, 0);

						self:lockTimer();
						break;
					end
				end
			end
		end

	end
end

addEvent('sendPacketData', true);
addEventHandler('sendPacketData', localPlayer, function(data,d)
	local data = data;
	if d ~= 'others' then
		for i = 1,#data do
			data[i].icon = (d == 'vehicles' and tex[6] or tex[7]);
			data[i].dataType = (d == 'vehicles' and 'vehicle' or 'house');
			data[i].selected = false;
			data[i].slot = 0;
		end
	else
		data[1].icon = tex[8];
		data[2].icon = tex[9];
		data[1].slot = 0;
		data[2].slot = 0;

		TradeClass.stack = true;
	end

	-- update selected and slot
	for i = 1,#data do
		for j = 1,5 do
			if TradeClass.slots[j] ~= 0 then
				if TradeClass.slots[j].ix == i and TradeClass.slots[j].tab == TradeClass.selectedTab then
					if not TradeClass.slots[j].stack then -- money and points are ignore
						data[i].selected = true;
					end
					data[i].slot = TradeClass.slots[j].tbl.slot;
				end

				if TradeClass.selectedTab == 3 and TradeClass.slots[j].tab == TradeClass.selectedTab then
					data[i].value = TradeClass.slots[j].tbl.value;
					if data[i].value then
						data[i].v = data[i].v - data[i].value; -- RESET VALUE BUG FIX
					end
				end
			end
		end
	end

	TradeClass.pItems = data;
	TradeClass.rows = #data;
end);

addEvent('declineTrade', true);
addEventHandler('declineTrade', localPlayer, function()
	TradeClass.text = "Gracz "..TradeClass.secPlayer.name.." zrezygnował z wymiany.";
	TradeClass.textColor = 0xFFFF0000;
	Timer(triggerServerEvent, 1500, 1, 'cancelTrade', resourceRoot, localPlayer);
end);

addEvent('acceptTrade', true);
addEventHandler('acceptTrade', localPlayer, function()
	TradeClass.text = "Gracz "..TradeClass.secPlayer.name.." zaakceptował wymianę.";
	TradeClass.textColor = 0xFF00FF00;
	TradeClass.accepted = true;

	if TradeClass.locked then -- locked = localPlayer accepted also
 		for i = 1,5 do
 			if TradeClass.items[i] ~= 0 then
 				local d = TradeClass.items[i];

 				if d.dataType == 'vehicle' then
 					triggerLatentServerEvent('updateClientData', resourceRoot, 'vehicle', localPlayer, TradeClass.secPlayer, d.id); -- for first
 					triggerLatentServerEvent('updateClientData', resourceRoot, 'vehicle', TradeClass.secPlayer, localPlayer, TradeClass.slots[i].tbl.id); -- for second
 				elseif d.dataType == 'house' then
 					-- TODO
 				else
 					if d.stackType and d.stack then
 						local bool = d.stackType == 'm' and 'money' or 'points';
 						triggerLatentServerEvent('updateClientData', resourceRoot, bool, localPlayer, TradeClass.secPlayer, tonumber(TradeClass.items[bool == 'money' and 1 or 2].value)); -- for first
 						triggerLatentServerEvent('updateClientData', resourceRoot, bool, TradeClass.secPlayer, localPlayer, tonumber(TradeClass.slots[bool == 'money' and 1 or 2].tbl.value)); -- for second
 					end
 				end
 			end
 		end

 		Timer(triggerServerEvent, 1500, 1, 'cancelTrade',resourceRoot, localPlayer);
	end
end);

addEvent('syncClientItemList', true);
addEventHandler('syncClientItemList', localPlayer, function(slot, itemTable)
	if itemTable ~= 0 then
		-- declare texture
		if itemTable.dataType == 'vehicle' then
			itemTable.icon = tex[6];
		elseif itemTable.dataType == 'house' then
			-- TODO
		else
			-- money or points
			if TradeClass.stackType and itemTable.stack then
				itemTable.icon = TradeClass.stackType == 'm' and tex[8] or tex[9];
				itemTable.stackType = TradeClass.stackType;
			end
		end
	end

	TradeClass.items[slot] = itemTable;
end);