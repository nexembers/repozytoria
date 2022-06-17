--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

function findPlayer(plr,cel)
    local target=nil
    if (tonumber(cel) ~= nil) then target=getElementByID("p"..cel) else
        for _,v in ipairs(getElementsByType("player")) do
            if string.find(string.gsub(getPlayerName(v):lower(),"#%x%x%x%x%x%x",""),cel:lower(),1,true) then
                if (target) then outputChatBox("Znaleziono wiecej niz jednego gracza o pasujacym nicku, podaj wiecej liter.", plr) return nil end
				target = v
            end
        end
    end return target
end

--KOD NA FRAKCJĘ

local fractions = {
	--{"skrot_frakcji",x,y,z,dimension,interior,r,g,b},
		{"Policja",1908.60,715.40,80.10,200,0,0,0,255},
		{"Policja",-456.66,385.17,2373.74,443,0,0,0,255}, -- SPSA
		{"PSP",943.08,1700.99,10.85,0,0,255,0,0},
		{"PSP",1325.86,381.61,19.56,0,0,255,0,0}, --sgsp
		{"SD",1457.80,-1716.93,122.52,9445,0,255,150,0},
		{"Policja",-299.102, 1015.833, 19.767,656,0,0,0,255}, -- SWAT
		{"Policja",235.43,76.75,1005.04,0,6,0,0,255}, -- SWAT
		{"Policja", 1536.9853515625, -1674.8037109375, 9838.5546875,234,0,0,0,255}, -- KGP
		{"PRM", 277.388671875, -112.791015625, 976.85626220703, 0, 3, 0,255,255}
}

local blipscolor = {
	["Policja"]={0,0,200},
	["PSP"]={255,0,0},
	["SD"]={255,150,0},
	["PRM"]={0,255,255},
}

local payments 	= {

};

local config = {}
addEventHandler("onResourceStart",resourceRoot,function()
	for _,v in ipairs(fractions) do
		if v[1] and tostring(v[1]) and v[2] and v[3] and v[4] and v[5] then
			local marker = createMarker(v[2],v[3],v[4]-1,"cylinder",1.4,v[7],v[8],v[9],100,root)
			if not config[marker] then config[marker]={} end
			setElementDimension(marker,v[5])
			setElementInterior(marker,v[6])
			config[marker].frakcja=tostring(v[1])
		end
	end
end)

addEventHandler("onMarkerHit",resourceRoot,function(plr)
	if plr and isElement(plr) and getElementType(plr) == "player" then
		if getElementData(plr,"CID") then
			takeAllWeapons(plr)
			if config[source] then
				if getElementData(plr,"frakcja") and getElementData(plr,"frakcja") == config[source].frakcja then
					if getElementData(plr, "player:job") then outputChatBox("Zakończ pracę dorywczą, aby wejść na służbę!", plr, 255,255,255) return end
					if not isPedInVehicle(plr) then
						triggerClientEvent(plr,"frakcja:showGUI:rozpoczecie",plr,plr)
					end
				else
					triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Ten marker nie należy\ndo Twojej frakcji!"})
				end
			end
		end
	end
end)

addEvent("frakcja:etapySluzby",true)
addEventHandler("frakcja:etapySluzby",root,function(plr,etap)
	if plr and isElement(plr) and getElementType(plr) == "player" then
		if getElementData(plr,"frakcja") then
			if getElementData(plr,"CID") then
				if etap == "zakoncz" then
					removeElementData(plr,"frakcja:S1")
					triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"info","Zakończono służbę we frakcji\n"..getElementData(plr,"frakcja").."."})
					exports["lss-admin"]:rconView_add("[FRAKCJA-SŁUŻBA] "..getPlayerName(plr).." zakończył/a służbę, frakcja "..getElementData(plr,"frakcja")..".")
					setElementData(plr,"dm:status", false)
					setElementModel(plr,getElementData(plr,"skin"))
					exports.playerblips:setBlip(plr,"setcolor",{255,255,255})
				elseif etap == "rozpocznij" then
					setElementData(plr,"frakcja:S1",true)
					triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"info","Rozpoczęto służbę we frakcji\n"..getElementData(plr,"frakcja").."."})
					exports["lss-admin"]:rconView_add("[FRAKCJA-SŁUŻBA] "..getPlayerName(plr).." rozpoczął/ęła służbę, frakcja "..getElementData(plr,"frakcja")..".")

					local frakcja = getElementData(plr,"frakcja")
					if blipscolor[frakcja] then
						local r,g,b = blipscolor[frakcja][1],blipscolor[frakcja][2],blipscolor[frakcja][3]
						exports.playerblips:setBlip(plr,"setcolor",{r,g,b})
					end
				end
			end
		end
	end
end)


local config = {}

addEventHandler("onMarkerHit",resourceRoot,function(plr)
	if plr and isElement(plr) and getElementType(plr) == "player" then
		if config[source] then
			if getElementData(plr,"frakcja") then
				triggerClientEvent(plr,"frakcja:showGUI:rozpoczecie",plr,plr,true)
			else
				triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie należysz do żadnej\nfrakcji, a więc nie możesz\nodebrać wypłaty!"})
			end
		end
	end
end)

--czat frakcyjny (jedna frakcja)
addCommandHandler("Frakcja",function(plr,_,...)
	if ... then
		if getElementData(plr,"frakcja") and (getElementData(plr,"frakcja:S1") or getElementData(plr, "admin:rank") == "Globaladministrator" or getElementData(plr, "admin:rank") == "RCON") then
			local tresc = table.concat({...}," ")
			local tresc = string.gsub(tresc, "#%x%x%x%x%x%x","")
			exports["lss-admin"]:gameView_add(getElementData(plr,"frakcja").." "..getPlayerName(plr)..": "..tresc)
			for i,v in ipairs (getElementsByType("player")) do
				if getElementData(v,"frakcja") and (getElementData(v,"frakcja:S1") or getElementData(v, "admin:rank") == "Globaladministrator" or getElementData(v, "admin:rank") == "RCON")then
					if getElementData(v,"frakcja") == getElementData(plr,"frakcja") then
						if getElementData(plr, "frakcja") == "PSP" then
							outputChatBox("#aaaaaa[#ff0000"..getElementData(plr,"frakcja").."#aaaaaa]#ffffff "..getPlayerName(plr).." #aaaaaa["..getElementData(plr,"id").."]#ffffff: "..tresc,v,r,g,b,true)
						elseif getElementData(plr, "frakcja") == "Policja" then
							outputChatBox("#aaaaaa[#0000ff"..getElementData(plr,"frakcja").."#aaaaaa]#ffffff "..getPlayerName(plr).." #aaaaaa["..getElementData(plr,"id").."]#ffffff: "..tresc,v,r,g,b,true)
						elseif getElementData(plr, "frakcja") == "PRM" then
							outputChatBox("#aaaaaa[#00ffaa"..getElementData(plr,"frakcja").."#aaaaaa]#ffffff "..getPlayerName(plr).." #aaaaaa["..getElementData(plr,"id").."]#ffffff: "..tresc,v,r,g,b,true)
						elseif getElementData(plr, "frakcja") == "SD" then
							outputChatBox("#aaaaaa[#ff4000"..getElementData(plr,"frakcja").."#aaaaaa]#ffffff "..getPlayerName(plr).." #aaaaaa["..getElementData(plr,"id").."]#ffffff: "..tresc,v,r,g,b,true)
						end
						triggerClientEvent(v,"odtworzDzwiek:czatFrakcyjny",v,v)
					end
				end
			end
		end
	end
end)

--czat służbowy (wszystkie frakcje)

addCommandHandler("Sluzby",function(plr,_,...)
	if ...  then
		if (getElementData(plr,"frakcja") and getElementData(plr,"frakcja:S1")) or getElementData(plr, "admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator"  then
			local tresc=table.concat({...}," ")
			tresc=string.gsub(tresc,"#%x%x%x%x%x%x","")
			exports["lss-admin"]:gameView_add("[SŁUŻBY] "..getPlayerName(plr)..": "..tostring(tresc))
			tresc = string.gsub(tresc,"997","#0000ff997#ffffff")
			tresc = string.gsub(tresc,"998","#ff0000998#ffffff")
			tresc = string.gsub(tresc,"999","#00ffaa999#ffffff")
			tresc = string.gsub(tresc,"981","#ff4000981#ffffff")
			for _,v in ipairs(getElementsByType("player")) do
				if (getElementData(v,"frakcja") and getElementData(v,"frakcja:S1")) or getElementData(v, "admin:rank") == "RCON"  or getElementData(v, "admin:rank") == "Globaladministrator" then
					if getElementData(plr, "admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
						outputChatBox("#aaaaaa[SŁUŻBY] #800000"..getPlayerName(plr).." #aaaaaa["..getElementData(plr,"id").."]#ffffff: "..tresc, v,255,255,255,true)
					elseif getElementData(plr, "frakcja") == "PSP" then
						outputChatBox("#aaaaaa[SŁUŻBY] #FF0000"..getPlayerName(plr).." #aaaaaa["..getElementData(plr,"id").."]#ffffff: "..tresc, v,255,255,255,true)
					elseif getElementData(plr, "frakcja") == "Policja" then
						outputChatBox("#aaaaaa[SŁUŻBY] #0000ff"..getPlayerName(plr).." #aaaaaa["..getElementData(plr,"id").."]#ffffff: "..tresc, v,255,255,255,true)
					elseif getElementData(plr, "frakcja") == "PRM" then
						outputChatBox("#aaaaaa[SŁUŻBY] #00ffaa"..getPlayerName(plr).." #aaaaaa["..getElementData(plr,"id").."]#ffffff: "..tresc, v,255,255,255,true)
					elseif getElementData(plr, "frakcja") == "SD" then
						outputChatBox("#aaaaaa[SŁUŻBY] #ee6600"..getPlayerName(plr).." #aaaaaa["..getElementData(plr,"id").."]#ffffff: "..tresc, v,255,255,255,true)
					end
					triggerClientEvent(v,"odtworzDzwiek:czatSluzbowy",v,v)
				end
			end
		end
	end
end)
for i,v in ipairs(getElementsByType("player")) do
	bindKey(v,"u","up","chatbox","Sluzby")
	bindKey(v,"j","up","chatbox","Frakcja")
end
addEventHandler("onPlayerLogin",root,function()
	bindKey(source,"u","up","chatbox","Sluzby")
	bindKey(source,"j","up","chatbox","Frakcja")
end)

function s2AUTO(plr)
	if plr and isElement(plr) then
		if getElementData(plr,"frakcja") and getElementData(plr,"frakcja:S1") then
			setElementData(plr,"frakcja:S2",true)
			removeElementData(plr,"frakcja:S1")
			outputChatBox("* Przeszedłeś w tryb chwilowej przerwy w służbie!",plr)
			exports.playerblips:setBlip(plr,"setcolor",{255,255,255})
			exports["lss-admin"]:rconView_add("[AUTO S2] "..getPlayerName(plr))
		end
	end
end
addEvent("s2",true)
addEventHandler("s2",root,s2AUTO)

function s2(plr,cmd)
	if plr and isElement(plr) then
		if getElementData(plr,"frakcja") and getElementData(plr,"frakcja:S1") then
			setElementData(plr,"frakcja:S2",true)
			removeElementData(plr,"frakcja:S1")
			outputChatBox("* Przeszedłeś w tryb chwilowej przerwy w służbie!",plr)
			exports.playerblips:setBlip(plr,"setcolor",{255,255,255})
			exports["lss-admin"]:rconView_add("[S2] "..getPlayerName(plr))
		end
	end
end
addCommandHandler("s2",s2)
addCommandHandler("S2",s2)

function s1(plr,cmd)
	if plr and isElement(plr) then
		local frakcja = getElementData(plr,"frakcja")
		if frakcja and getElementData(plr,"frakcja:S2") then
			setElementData(plr,"frakcja:S1",true)
			removeElementData(plr,"frakcja:S2")
			outputChatBox("* Powróciłeś w tryb służby!",plr)
			exports["lss-admin"]:rconView_add("[S3] "..getPlayerName(plr))
			if blipscolor[frakcja] then
				local r,g,b = blipscolor[frakcja][1],blipscolor[frakcja][2],blipscolor[frakcja][3]
				exports.playerblips:setBlip(plr,"setcolor",{r,g,b})
			end
		end
	end
end
addCommandHandler("s1",s1)
addCommandHandler("S1",s1)

local timer = {}
addCommandHandler("ukryjblip",function(plr,cmd)
	if plr and isElement(plr) then
		if getElementData(plr,"frakcja") and getElementData(plr,"frakcja") == "Policja" and getElementData(plr,"frakcja:S1") then
			if timer[plr] and isTimer(timer[plr]) then outputChatBox("#FF0000★ #FFFFFFPoczekaj chwilę przed ponownym użyciem tej komendy!",plr,0,0,0,true) return end
			timer[plr] = setTimer(function(plr) timer[plr]=nil end,3000,1,plr)
			exports.playerblips:setBlip(plr,"destroy")
			outputChatBox("#00FF00★ #FFFFFFTwoje oznaczenie zostało ukryte. Jeśli chcesz je przywrócić, użyj komendy #FFFF00/pokazblip#FFFFFF.",plr,0,0,0,true)
		end
	end
end)

addCommandHandler("pokazblip",function(plr,cmd)
	if plr and isElement(plr) then
		if getElementData(plr,"frakcja") and getElementData(plr,"frakcja") == "Policja" and getElementData(plr,"frakcja:S1") then
			if timer[plr] and isTimer(timer[plr]) then outputChatBox("#FF0000★ #FFFFFFPoczekaj chwilę przed ponownym użyciem tej komendy!",plr,0,0,0,true) return end
			timer[plr] = setTimer(function(plr) timer[plr]=nil end,3000,1,plr)

			local frakcja = getElementData(plr,"frakcja")
			local r,g,b = blipscolor[frakcja][1],blipscolor[frakcja][2],blipscolor[frakcja][3]
			exports.playerblips:setBlip(plr,"setcolor",{r,g,b})
			outputChatBox("#00FF00★ #FFFFFFTwoje oznaczenie zostało stworzone. Jeśli chcesz je usunąć, użyj komendy #FFFF00/ukryjblip#FFFFFF.",plr,0,0,0,true)
		end
	end
end)

addCommandHandler("usunminuty",function(plr,cmd)
	if getElementData(plr,"admin:rank") == "RCON" or getPlayerName(plr) == "Console" then
		for i,v in ipairs(getElementsByType("player")) do
			setElementData(v,"frakcja:minuty:week",0)
		end
		outputServerLog("Minuty frakcyjne zostały usunięte!")
		exports.DB:zapytanie("UPDATE cl_characters SET frakcja_minuty_week=0 WHERE 1=1")
	end
end)

addCommandHandler("minuty", function(plr,cmd)
	if getElementData(plr, "frakcja") then
		local result = exports.DB:pobierzTabeleWynikow("SELECT * FROM `cl_wyplatyfrakcje` WHERE `ranga`=? and `frakcja`=? LIMIT 1",getElementData(plr,'frakcja:ranga'),getElementData(plr,"frakcja"))
		for i,v in ipairs(result) do
			outputChatBox("Frakcja: "..getElementData(plr,"frakcja"),plr,255,255,255)
			outputChatBox("Stopień: "..getElementData(plr,"frakcja:ranga"),plr,255,255,255)
			outputChatBox("Minuty: "..getElementData(plr,'frakcja:minuty'),plr,255,255,255)
			outputChatBox("Minuty w tym tygodniu: "..getElementData(plr,"frakcja:minuty:week"),plr,255,255,255)
			outputChatBox("Wypłata za godzinę: "..v['wyplata'].." PLN/h",plr,255,255,255)
			outputChatBox("Doświadczenie za godzinę: "..(v["exp"] * 60), plr,255,255,255)
			outputChatBox("Do wypłacenia: "..string.format("%.02f", (getElementData(plr,"frakcja:minuty")/60)*v['wyplata']).." PLN",plr,255,255,255)
			outputChatBox("Doświadczenie do odebrania: "..(getElementData(plr, "frakcja:minuty") * v["exp"]),plr,255,255,255)
		end
	end
end)

addCommandHandler("smint", function(plr, cmd, arg)
	if getElementData(plr, "admin:rank") == "RCON" then
		setElementData(plr, "frakcja:minuty", tonumber(arg))
	end
end)

function loadPayouts()
	local allPayments = exports["DB"]:prepareSet("SELECT * FROM `cl_wyplatyfrakcje`")
	if(allPayments) and (#allPayments) > (0)then
		for index, value in ipairs(allPayments) do
			if(value)then
				if(not payments[value.frakcja])then
					payments[value.frakcja] = {};
				end
				payments[value.frakcja][value.ranga] = {value.wyplata, value.exp};
				outputDebugString("Loaded payment ["..value.frakcja.."]["..value.ranga.."] = "..value.wyplata)
			end
		end
	end
	return;
end; addEventHandler("onResourceStart", resourceRoot, loadPayouts);

function getPlayers()
	local returnCids = {}
	for index, value in ipairs(getElementsByType("player")) do
		local cid = getElementData(value, "CID");
		if(value) and (isElement(value)) and (cid) and (tonumber(cid)) and (getElementData(value, "frakcja"))then
			returnCids[tonumber(cid)] = value;
		end
	end
	if(returnCids)then
		return returnCids
	end;
	return false;
end

function faction_payOutMinutes(user, command, secretKey, factions)
	if(command) and (secretKey) and (factions)then
		if(user) and (getPlayerName(user)) == ("Console") and (secretKey) == ("mm2j@IJFnwe29I$24dsfdvvwPIoKM#") and (factions) == ("all")then
			local allPlayersFaction = exports["DB"]:prepareSet("SELECT CID,login,frakcja,frakcja_ranga,frakcja_minuty,f_blockade,frakcja_minuty_week,nick FROM `cl_characters` WHERE `frakcja` NOT LIKE '' AND `frakcja_ranga` NOT LIKE ''")
			-- outputDebugString("#allPlayersFaction = "..#allPlayersFaction)
			if(allPlayersFaction) and (#allPlayersFaction) > (0)then
				local allPlayers = getPlayers();
				local taxPercentage = tonumber(exports["cs_taxSystem"]:getTaxValue("moneyTrade"));
				for index, value in ipairs(allPlayersFaction) do
					if(value) and (value.CID)then
						if(allPlayers[tonumber(value.CID)]) and (isElement(allPlayers[tonumber(value.CID)]))then
							-- online player
							if(payments[value.frakcja])then
								local getPayment = payments[value.frakcja][value.frakcja_ranga];
								local weekMinutes = getElementData(allPlayers[tonumber(value.CID)], "frakcja:minuty");
								if(getPayment) and (getPayment) and (tonumber(getPayment[1])) and (weekMinutes) and (tonumber(weekMinutes)) and (weekMinutes) > (0)then
									local addExp = getPayment[2] * value.frakcja_minuty;
									exports["cs_levelingSystem"]:addPlayerExperience(allPlayers[tonumber(value.CID)], addExp);
									getPayment = weekMinutes * (getPayment[1]/60); getPayment = math.floor(getPayment);
									local tax = (getPayment * taxPercentage)/100; getPayment = getPayment - tax
									if(getPayment) < (1)then return false end;
									givePlayerMoney(allPlayers[tonumber(value.CID)], getPayment);
									setElementData(allPlayers[tonumber(value.CID)], "frakcja:minuty", 0);
									setElementData(allPlayers[tonumber(value.CID)], "frakcja:minuty:week", 0);
									exports["cs_taxSystem"]:addToAccount("moneyTrade", tax);
									triggerClientEvent(allPlayers[tonumber(value.CID)],"CS:powiadomienie",allPlayers[tonumber(value.CID)],allPlayers[tonumber(value.CID)],{"money","Otrzymano z wypłaty frakcyjnej\n"..getPayment.." PLN"})
									exports["lss-admin"]:rconView_add("[FACTION ONLINE PAYMENT] [CID: "..value.CID.."] (login: "..value.login..") ordered "..getPayment+tax.." - ("..taxPercentage.."% tax) = "..getPayment.." PLN for "..weekMinutes.." minutes this week")
									local incomeText = "		⚅ Central Bank of San Andreas ⚅\n		  CalmStory ©2021\n\nNadzór pełni Policja, wysłano poprzez United States Post Office\n=======================================\n\nOdbiorca: "..value.nick.."\nIdentyfikator klienta "..value.CID.."\nNadawca: "..value.frakcja.."\nOdbiór przyznano ONLINE\nPrzelew przychodzący\nWartość przelewu: "..getPayment + tax.." PLN - "..taxPercentage.."%\nFinalna kwota wynosi "..getPayment.." PLN\n\n=======================================\nPrezes CoRFX (15147)\nKierownik PVK (5)\n- Central Bank Of San Andreas\n- Urząd podatkowy San Andreas"
									exports["DB"]:prepareSet("INSERT INTO `cs_offlineMessages` (authorCID, readerCID, message, messageSend, authorName) VALUES ('15147', ?, ?, NOW(), 'Central Bank of San Andreas') ", tonumber(value.CID), incomeText)
								end
							end
						else
							-- offline player
							outputDebugString(user)
							if(payments[value.frakcja]) and (value.frakcja_minuty) > (0)then
							outputDebugString("FRACTION 1")
								local getPayment = payments[value.frakcja][value.frakcja_ranga];
								if(getPayment) and (getPayment) and (tonumber(getPayment[1]))then
									outputDebugString("FRACTION 2")
									local addExp = getPayment[2] * value.frakcja_minuty;
									getPayment = value.frakcja_minuty * (getPayment[1]/60); getPayment = math.floor(getPayment);
									local tax = (getPayment * taxPercentage)/100; getPayment = getPayment - tax
									if(getPayment) < (1)then outputDebugString("FRACTION 3") return false end;
									exports["lss-admin"]:rconView_add("[FACTION OFFLINE PAYMENT] [CID: "..value.CID.."] (login: "..value.login..") ordered "..getPayment+tax.." - ("..taxPercentage.."% tax) = "..getPayment.." PLN for "..value.frakcja_minuty_week.." minutes this week")
									exports["DB"]:prepareSet("UPDATE `cl_characters` SET `bank` = `bank` + ?, `frakcja_minuty` = 0, `frakcja_minuty_week` = 0, `f_blockade` = 0, `player_Exp` = `player_Exp` + ? WHERE `CID` = ? ", getPayment, addExp, tonumber(value.CID))
									local incomeText = "		⚅ Central Bank of San Andreas ⚅\n		  CalmStory ©2021\n\nNadzór pełni Policja, wysłano poprzez United States Post Office\n=======================================\n\nOdbiorca: "..value.nick.."\nIdentyfikator klienta "..value.CID.."\nNadawca: "..value.frakcja.."\nOdbiór przyznano OFFLINE\nPrzelew przychodzący\nWartość przelewu: "..getPayment + tax.." PLN - "..taxPercentage.."%\nFinalna kwota wynosi "..getPayment.." PLN\n\n=======================================\nPrezes CoRFX (15147)\nKierownik PVK (5)\n- Central Bank Of San Andreas\n- Urząd podatkowy San Andreas"
									exports["DB"]:prepareSet("INSERT INTO `cs_offlineMessages` (authorCID, readerCID, message, messageSend, authorName) VALUES ('15147', ?, ?, NOW(), 'Central Bank of San Andreas') ", tonumber(value.CID), incomeText)
									exports["cs_taxSystem"]:addToAccount("moneyTrade", tax);
								end
							end
						end
					end
				end
			end
		end
	end
	return;
end
addCommandHandler("factions_.PayOutfactionMinutes", faction_payOutMinutes);

function fact_payManual(login)
		if(login) and (tostring(login))then
			local allPlayersFaction = exports["DB"]:prepareSet("SELECT CID,login,frakcja,frakcja_ranga,frakcja_minuty,f_blockade,frakcja_minuty_week,nick FROM `cl_characters` WHERE `frakcja` NOT LIKE '' AND `frakcja_ranga` NOT LIKE '' AND `login` like ?", login)
			if(allPlayersFaction) and (#allPlayersFaction) > (0)then
				local allPlayers = getPlayers();
				local taxPercentage = tonumber(exports["cs_taxSystem"]:getTaxValue("moneyTrade"));
				if(#allPlayersFaction) > (1)then return false end;
				for index, value in ipairs(allPlayersFaction) do
					if(value) and (value.CID)then
						if(allPlayers[tonumber(value.CID)]) and (isElement(allPlayers[tonumber(value.CID)]))then
							-- online player
							if(payments[value.frakcja])then
								local getPayment = payments[value.frakcja][value.frakcja_ranga];
								local weekMinutes = getElementData(allPlayers[tonumber(value.CID)], "frakcja:minuty");
								if(getPayment) and (getPayment) and (tonumber(getPayment[1])) and (weekMinutes) and (tonumber(weekMinutes)) and (weekMinutes) > (0)then
									local addExp = getPayment[2] * value.frakcja_minuty;
									if(value.f_blockade) == (0)then
										exports["cs_levelingSystem"]:addPlayerExperience(allPlayers[tonumber(value.CID)], addExp);
									end
									getPayment = weekMinutes * (getPayment[1]/60); getPayment = math.floor(getPayment);
									local tax = (getPayment * taxPercentage)/100; getPayment = getPayment - tax
									if(getPayment) < (1)then return false end;
									givePlayerMoney(allPlayers[tonumber(value.CID)], getPayment);
									setElementData(allPlayers[tonumber(value.CID)], "frakcja:minuty", 0);
									setElementData(allPlayers[tonumber(value.CID)], "frakcja:minuty:week", 0);
									exports["cs_taxSystem"]:addToAccount("moneyTrade", tax);
									triggerClientEvent(allPlayers[tonumber(value.CID)],"CS:powiadomienie",allPlayers[tonumber(value.CID)],allPlayers[tonumber(value.CID)],{"money","Otrzymano z wypłaty frakcyjnej\n"..getPayment.." PLN"})
									exports["lss-admin"]:rconView_add("[FACTION ONLINE PAYMENT] [CID: "..value.CID.."] (login: "..value.login..") ordered "..getPayment+tax.." - ("..taxPercentage.."% tax) = "..getPayment.." PLN for "..weekMinutes.." minutes this week")
									local incomeText = "		⚅ Central Bank of San Andreas ⚅\n		  CalmStory ©2021\n\nNadzór pełni Policja, wysłano poprzez United States Post Office\n=======================================\n\nOdbiorca: "..value.nick.."\nIdentyfikator klienta "..value.CID.."\nNadawca: "..value.frakcja.."\nOdbiór przyznano ONLINE\nPrzelew przychodzący\nWartość przelewu: "..getPayment + tax.." PLN - "..taxPercentage.."%\nFinalna kwota wynosi "..getPayment.." PLN\n\n=======================================\nPrezes CoRFX (15147)\nKierownik PVK (5)\n- Central Bank Of San Andreas\n- Urząd podatkowy San Andreas"
									exports["DB"]:prepareSet("INSERT INTO `cs_offlineMessages` (authorCID, readerCID, message, messageSend, authorName) VALUES ('15147', ?, ?, NOW(), 'Central Bank of San Andreas') ", tonumber(value.CID), incomeText)
									return true
								else
									return true
								end
							end
						else
							-- offline player
							if(payments[value.frakcja]) and (value.frakcja_minuty) >= (0)then
								local getPayment = payments[value.frakcja][value.frakcja_ranga];
								if(getPayment) and (tonumber(getPayment[1]))then
									local addExp = getPayment[2] * value.frakcja_minuty;
									getPayment = value.frakcja_minuty * (getPayment[1]/60); getPayment = math.floor(getPayment);
									local tax = (getPayment * taxPercentage)/100; getPayment = getPayment - tax
									if(getPayment) < (0)then return false end;
									exports["lss-admin"]:rconView_add("[FACTION OFFLINE PAYMENT] [CID: "..value.CID.."] (login: "..value.login..") ordered "..getPayment+tax.." - ("..taxPercentage.."% tax) = "..getPayment.." PLN for "..value.frakcja_minuty_week.." minutes this week")
									exports["DB"]:prepareSet("UPDATE `cl_characters` SET `bank` = `bank` + ?, `frakcja_minuty` = 0, `frakcja_minuty_week` = 0, `f_blockade` = 0 AND `player_Exp` = ? WHERE `CID` = ? ", getPayment, addExp, tonumber(value.CID))
									local incomeText = "		⚅ Central Bank of San Andreas ⚅\n		  CalmStory ©2021\n\nNadzór pełni Policja, wysłano poprzez United States Post Office\n=======================================\n\nOdbiorca: "..value.nick.."\nIdentyfikator klienta "..value.CID.."\nNadawca: "..value.frakcja.."\nOdbiór przyznano OFFLINE\nPrzelew przychodzący\nWartość przelewu: "..getPayment + tax.." PLN - "..taxPercentage.."%\nFinalna kwota wynosi "..getPayment.." PLN\n\n=======================================\nPrezes CoRFX (15147)\nKierownik PVK (5)\n- Central Bank Of San Andreas\n- Urząd podatkowy San Andreas"
									exports["DB"]:prepareSet("INSERT INTO `cs_offlineMessages` (authorCID, readerCID, message, messageSend, authorName) VALUES ('15147', ?, ?, NOW(), 'Central Bank of San Andreas') ", tonumber(value.CID), incomeText)
									exports["cs_taxSystem"]:addToAccount("moneyTrade", tax);
									return true
								else
									return true
								end
							end
						end
					end
				end
				return false
			end
			return false
		end
	return false
end

function payoutByLogin(player, command, login)
	if(player) and (isElement(player)) and (getPlayerName(player):lower() == "console" or getElementData(player, "admin:rank")) == ("RCON")then 
		if(login) and (tostring(login))then 
			outputDebugString("BTW: "..login, 0, 0, 100, 255)
			fact_payManual(login);
		end
	end
	return false;
end; addCommandHandler("fac_payoutByLogin", payoutByLogin)
