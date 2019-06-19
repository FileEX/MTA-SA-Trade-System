--[[
	Author: FileEX
]]

addEvent('getClientData', true);
addEventHandler('getClientData', root, function(d)
	if d == 'vehicles' then
		local q = exports['rm_mysql']:zapytanie('SELECT * FROM rm_vehicles WHERE ownerUID = ?', client:getData('user:uid'));
		triggerLatentClientEvent(client, 'sendPacketData', client, q, d);
	elseif d == 'houses' then
		-- TODO
	elseif d == 'others' then
		local money = client:getData('user:money') or 0;
		local points = client:getData('user:ppoints') or 0;

		triggerClientEvent(client, 'sendPacketData', client, {{v = money}, {v = points}}, d);
	end
end);

addEvent('updateClientData', true);
addEventHandler('updateClientData', root, function(t, p, tr, i)
	if t == 'vehicle' then
		exports['rm_mysql']:zapytanie('UPDATE rm_vehicles SET ownerUID=? WHERE id=? LIMIT 1;', tr:getData('user:uid'), i);
		print(p.name, 'dal auto o id ', i, 'dla', tr.name);
	elseif t == 'house' then
		-- TODO
	elseif t == 'money' then
		p:setData('user:money', p:getData('user:money') - i);
		tr:setData('user:money', tr:getData('user:money') + i);
		print(p.name, 'dal', tr.name, i, 'kasy');
	elseif t == 'points' then -- POINTS
		p:setData('user:ppoints', p:getData('user:ppoints') - i);
		tr:setData('user:ppoints', tr:getData('user:ppoints') + i);
		print(p.name, 'dal', tr.name, i, 'pointsow');
	end
end);

addCommandHandler(tradeCmd, function(plr, cmd, target)
	if not target then
		plr:outputChat('Użyj /'..tradeCmd..' <nick>', 255, 255, 255);
	return end

	local targetElement;

	if not tonumber(target) then
		if target ~= plr.name and target ~= plr.name:lower() and target ~= plr.name:upper() then
			targetElement = Player(target);
		else
			plr:outputChat('Nie możesz rozpocząć wymiany ze samym sobą.', 255, 255, 255);
			return;
		end
	else
		if tonumber(target) ~= plr:getData('id') then
			targetElement = findPlayerById(tonumber(target));
		else
			plr:outputChat('Nie możesz rozpocząć wymiany ze samym sobą', 255, 255, 255);
			return;
		end
	end

	if not targetElement then
		plr:outputChat('Nie znaleziono gracza o podanym nicku lub id.', 255, 255, 255);
	return end

	if plr:getData('sendOffert') then
		plr:outputChat('Jedna propozycja wymiany jest już w toku.', 255, 255, 255);
	return end;

	plr:outputChat('Oczekuj na decyzję gracza...', 255, 255, 255);
	triggerClientEvent(targetElement, 'tradeOffert', resourceRoot, plr);
	plr:setData('sendOffert', true, false);
end);

addEvent('ignoreTrade', true);
addEventHandler('ignoreTrade', root, function(plr, target)
	plr:outputChat('Gracz '..target.name..' nie zareagował na twoją propozycję wymiany.', 255, 255, 255);
	plr:removeData('sendOffert');
end);

addEvent('acceptTrade', true);
addEventHandler('acceptTrade', root, function(plr, target)
	triggerClientEvent(plr, 'onTradeUI', plr, true, target);
end);

addEvent('cancelTrade', true);
addEventHandler('cancelTrade', root, function(plr, quit, name)
	triggerClientEvent(plr, 'onTradeUI', plr, false);
	if quit then
		plr:outputChat('Gracz '..name..' opuścił serwer.', 255, 255, 255);
	end

	plr:removeData('sendOffert');
end);

addEvent('tryCancelTrade', true);
addEventHandler('tryCancelTrade', root, function(plr)
	triggerClientEvent(plr, 'declineTrade', plr);
	-- client maybe is target or localPlayer
	if plr:getData('sendOffert') then
		plr:removeData('sendOffert');
	end
end);

addEvent('infoAboutAccept', true);
addEventHandler('infoAboutAccept', root, function(plr)
	triggerClientEvent(plr, 'acceptTrade', plr);
end);

addEvent('syncItemList', true);
addEventHandler('syncItemList', root, function(target, slot, itemTable)
	triggerClientEvent(target, 'syncClientItemList', target, slot, itemTable);
end);