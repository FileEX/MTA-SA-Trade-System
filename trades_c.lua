--[[
	Author: FileEX
]]

local CTrade;

local function Class(b, plr)
	if b then
		if not CTrade then
			CTrade = TradeClass();
		end
		CTrade:showUI(true);
		CTrade:SyncPlayer(plr);
	else
		if not CTrade then
			CTrade = TradeClass();
		end
		CTrade:showUI(false);
		CTrade:destructor();
		CTrade = nil;
	end
end

addEvent('onTradeUI', true);
addEventHandler('onTradeUI', localPlayer, function(b, p)
	Class(b, p);
end);

addEvent('tradeOffert', true)
addEventHandler('tradeOffert', resourceRoot, function(target)
	outputChatBox('Gracz '..target.name..' proponuje Ci wymianę. Aby zaakceptować wpisz /'..acceptCmd..' lub zignoruj tą propozycję.', 255, 255, 255);

	local timer = Timer(function(target)
		-- check if player is still online
		if Player(target.name) then
			triggerServerEvent('ignoreTrade', resourceRoot, target, localPlayer);
		end
		removeCommandHandler(acceptCmd);
	end, waitTime * 1000, 1, target);

	addCommandHandler(acceptCmd, function(cmd)
		triggerServerEvent('acceptTrade', resourceRoot, target, localPlayer);
		removeCommandHandler(acceptCmd);
		if timer.valid then
			timer:destroy();
		end

		Class(true, target);
	end);
end);

addEventHandler('onClientPlayerQuit', root, function()
	if CTrade and CTrade ~= nil then
		if source == localPlayer then
			triggerServerEvent('cancelTrade', resourceRoot, CTrade.secPlayer, true, localPlayer.name);
		elseif source == CTrade.secPlayer then
			triggerServerEvent('cancelTrade', resourceRoot, localPlayer, true, CTrade.secPlayer.name); -- info player
			CTrade:destructor(); -- debug errors fix
		end
	end
end);