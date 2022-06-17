--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

local wynik = nil
local timer = {}

local config = {}
local outside = {}

setGarageOpen(17,true)

setTimer(function()
	exports.DB:zapytanie("UPDATE cs_posiadlosci SET time=time-1 WHERE time>0")
	licznik=0
	for i,v in ipairs(getElementsByType("pickup",resourceRoot)) do
		if config[v] then
			local times = config[v].time
			if v and isElement(v) and times and times>0 then
				config[v].time=times-1
				licznik=licznik+1
				if config[v].time == 0 then
					local id = config[v].id
					outputDebugString("AUTOMAT - Zwolniono dom id "..id..".")
					reloadHouse(id)
				end
			end
		end
	end
	outputDebugString("Zmniejszono godzinę z wynajmu domów (ilość: "..licznik..")")
end,60000*60,0)


function createHouses(result,other)
	if (result) then
		local freehouses = 0
		local busyhouses = 0
		local liczbakomisow = 0
		for i,v in ipairs(result) do
			local dbid,owner,czas,cost,dim,int,lock,typ = v["dbid"],v["owner"],v["time"],v["cost"],v["dim"],v["interior"],v["locked"],v["type"]
			local pos1 = split(v["xyz"],",")
			local pos2 = split(v["in_xyz"],",")
			if (czas>0) then 	-- zajęty dom
				local house = createPickup(pos1[1],pos1[2],pos1[3],3,1272,1000,0)
				local result = nil

				if typ == "komis" then
					liczbakomisow = liczbakomisow+1
					triggerEvent("CS:komisy:setNewOwner",house,owner,dbid)
				elseif typ == "stacja-nos" then
					result_nos = exports.DB:pobierzTabeleWynikow("SELECT nos_price FROM cs_nos_station WHERE house_id = ?", dbid)
				end

				if typ ~= "stacja-nos" then
					config[house] = {free=false,owner=owner,time=czas,id=dbid,cost=cost,lock=lock,pos={pos2[4],pos2[5],pos2[6],dim,int,lock},type=typ}
				else
					config[house] = {free=false,owner=owner,time=czas,id=dbid,cost=cost,lock=lock,pos={pos2[4],pos2[5],pos2[6],dim,int,lock},type=typ,nos_price = result_nos[1].nos_price}
				end

				busyhouses=busyhouses+1
			else 				-- wolny dom
				if (owner~="" or lock==1) then
					exports.DB:zapytanie("UPDATE cs_posiadlosci SET owner=?,locked=?,occ1=NULL,occ2=NULL WHERE dbid=?","",0,dbid)
				end
				local house = createPickup(pos1[1],pos1[2],pos1[3],3,1273,1000,0)
				setElementData(house,"house:free",true)

				config[house] = {free=true,id=dbid,cost=cost,lock=lock,pos={pos2[4],pos2[5],pos2[6],dim,int},type=typ}

				freehouses=freehouses+1
			end
			local out = createMarker(pos2[1],pos2[2],pos2[3]+0.55,"arrow",1,255,255,0,150)
			setElementDimension(out,dim)
			setElementInterior(out,int)

			outside[out] = {id=dbid,pos={pos1[4],pos1[5],pos1[6],0,0}}
		end
		if #result==1 and other then
			outputDebugString("Przeładowano dom o id "..other..".")
		else
			outputDebugString("Stworzono "..freehouses.." wolnych domów i "..busyhouses.." wynajętych domów.")
		end
		if liczbakomisow>0 then outputDebugString("Utworzono "..liczbakomisow.." komisów samochodowych.") end
	end
end

function downloadResults(id)
	if not id then
		wynik = exports.DB:pobierzTabeleWynikow("SELECT dbid,owner,time,cost,xyz,in_xyz,dim,interior,locked,type FROM cs_posiadlosci WHERE (type=? OR type=? OR type=?)","dom","komis", "stacja-nos")
		if (wynik and #wynik>0) then
			createHouses(wynik)
			local result = exports["DB"]:pobierzTabeleWynikow("SELECT id FROM cs_houseGates WHERE houseID = ?",tonumber(id))
			if #result > 0 then
				exports['CS-gatecode']:reloadGates(result)
			end
		end
	else
		wynik = exports.DB:pobierzTabeleWynikow("SELECT dbid,owner,time,cost,xyz,in_xyz,dim,interior,locked,type FROM cs_posiadlosci WHERE ((type=? OR type=? OR type=?) AND dbid=?) LIMIT 1","dom","komis","stacja-nos",id)
		if (wynik and #wynik>0) then
			createHouses(wynik,id)
			local result = exports.DB:pobierzTabeleWynikow("SELECT id FROM cs_houseGates WHERE houseID = ?",tonumber(id))
			if #result > 0 then
				exports['CS-gatecode']:reloadGates(result)
			end
		end
	end
	wynik=nil
end

function reloadHouse(id)
	if (id and tonumber(id)) then
		for _,v in ipairs(getElementsByType("marker",resourceRoot)) do
			if outside[v] and outside[v].id==tonumber(id) then
				outside[v]=nil
				destroyElement(v)
				v=nil
			end
		end
		for _,v in ipairs(getElementsByType("pickup",resourceRoot)) do
			if config[v] and config[v].id==tonumber(id) then
				config[v]=nil
				destroyElement(v)
				v=nil
			end
		end
		downloadResults(id)
	end
end

addCommandHandler("reloadhouse",function(plr,cmd,id)
	if plr and isElement(plr) and getElementType(plr) == "player" and id and tonumber(id) then
		if getElementData(plr,"admin:rank") == "RCON" or getElementData(plr,"admin:rank") == "Globaladministrator" then
			reloadHouse(tonumber(id))
			outputChatBox("* Przeładowano dom o id "..id..".",plr)
		end
	end
end)

function movePlr(plr,data)
	if plr and isElement(plr) and data then
		if timer[plr] and isTimer(timer[plr]) then return end
		if (data[6] and data[6]==1) then triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Ten dom aktualnie\njest zamknięty!"}) return end
		setElementFrozen(plr,true)
		fadeCamera(plr,false)
		timer[plr] = setTimer(function(plr,data)
			if plr and isElement(plr) and data then
				setElementPosition(plr,data[1],data[2],data[3])
				setElementDimension(plr,data[4])
				setElementInterior(plr,data[5])
				setElementFrozen(plr,false)
				fadeCamera(plr,true)
				timer[plr] = nil
			end
		end,1250,1,plr,data)
	end
end

addEventHandler("onPlayerQuit",root,function()
	if timer[source] then
		if isTimer(timer[source]) then
			killTimer(timer[source])
		end
		timer[source]=nil
	end
end)

addEvent("CS-domy:nos-sation:setPrice", true)
addEventHandler("CS-domy:nos-sation:setPrice", root, function(arg1, arg2, arg3)
	if arg1 and arg2 then
		exports.DB:zapytanie("UPDATE cs_nos_station SET nos_price = ? WHERE house_id = ?", arg2, arg1)
		exports["CS-nos-station"]:changeNOSPrice(arg1, arg2)
		config[arg3].nos_price = arg2
		outputChatBox("#00FF00✔ #FFFFFFPomyślnie zmieniono cenę na #00FF00"..arg2.." #FFFFFFPLN.", client, 255, 255, 255, true)
	end
end)

addEvent("CS-domy:nos-sation:setNO2State", true)
addEventHandler("CS-domy:nos-sation:setNO2State", root, function(arg1, arg2, arg3, arg4)
	if arg1 and arg2 and arg3 and arg4 then
		exports.DB:zapytanie("UPDATE `cs_nos_station` SET `station_state` = `station_state` + ? WHERE `house_id` = ?", arg2, arg1)
		takePlayerMoney(client, arg3);
		outputChatBox("#00FF00✔ #FFFFFFZakupiono #00FF00"..arg2.." NO2#FFFFFF do zbiornika, Zaplacono #00FF00"..arg3.." #FFFFFFPLN.", client, 255, 255, 255, true)
		exports["CS-nos-station"]:changeStationState(arg1, math.ceil(arg4 + arg2))
	end
end)


addEvent("CS:domy:server",true)
addEventHandler("CS:domy:server",root,function(plr,option,data)
	if plr and isElement(plr) then
		if (option=="wynajmij") then
			if (data and #data>0) then
				local typ,id,cost,days = data[1],data[2],data[3],data[4]
				if (typ=="Gotówka") then
					for _,v in ipairs(getElementsByType("pickup",resourceRoot)) do
						if config[v] and config[v].id == id then
							if not config[v].owner then
								if getPlayerMoney(plr)<tonumber(cost) then triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie posiadasz wystarczającej\nilości środków na swoim koncie,n\aby móc wykupić dom!"}) return end
								takePlayerMoney(plr,cost)
								exports.DB:zapytanie("UPDATE cs_posiadlosci SET owner=?,time=? WHERE dbid=? LIMIT 1",getElementData(plr,"login"),days*24,id)
								triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"allow","Dom został wykupiony\nna #81b1d3"..days.." dni #FFFFFFza kwotę\n#81b1d3"..cost..".00 PLN#FFFFFF."})
								exports["lss-admin"]:rconView_add("[DOM-KUPNO] "..getPlayerName(plr).." >> dom: "..id.." >> typ: "..typ.." >> dni: "..days.." >> cost: "..cost..".")
								triggerClientEvent(plr,"CS:house:client",plr,plr,"ukryj")
								reloadHouse(id)
							else
								triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Dom został już wykupiony\nprzez kogoś innego!"})
								triggerClientEvent(plr,"CS:house:client",plr,plr,"ukryj")
							end
						end
					end
				end
			end
		elseif (option=="zamknij") then
			if (data and #data>0) then
				local id = data[1]
				exports.DB:zapytanie("UPDATE cs_posiadlosci SET locked=? WHERE dbid=? LIMIT 1",1,id)
				triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"allow","Dom został zamknięty."})
				exports["lss-admin"]:rconView_add("[DOM-ZAMKNIJ] "..getPlayerName(plr).." >> dom: "..id..".")
				reloadHouse(id)
			end
		elseif (option=="otworz") then
			if (data and #data>0) then
				local id = data[1]
				exports.DB:zapytanie("UPDATE cs_posiadlosci SET locked=? WHERE dbid=?",0,id)
				triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"allow","Dom został otworzony."})
				exports["lss-admin"]:rconView_add("[DOM-OTWÓRZ] "..getPlayerName(plr).." >> dom: "..id..".")
				reloadHouse(id)
			end
		elseif (option=="przedluz") then
			if (data and #data>0) then
				local typ,id,cost,days = data[1],data[2],data[3],data[4]
				if (typ=="Gotówka") then
					if getPlayerMoney(plr)<tonumber(cost) then triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie posiadasz wystarczającej\nilości środków na swoim koncie,n\aby móc przedłużyć dom!"}) return end
					takePlayerMoney(plr,cost)
					exports.DB:zapytanie("UPDATE cs_posiadlosci SET time=time+? WHERE (dbid=? AND owner=?) LIMIT 1",days*24,id,getElementData(plr,"login"))
					triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"allow","Dom został przedłużony\nna #81b1d3"..days.." dni #FFFFFFza kwotę\n#81b1d3"..cost..".00 PLN#FFFFFF."})
					triggerClientEvent(plr,"CS:house:client",plr,plr,"ukryj")
					exports["lss-admin"]:rconView_add("[DOM-PRZEDŁUŻ] "..getPlayerName(plr).." >> dom: "..id.." >> typ: "..typ.." >> dni: "..days.." >> cost: "..cost..".")
					reloadHouse(id)
				end
			end
		elseif (option=="zwolnij") then
			if (data and #data>0) then
				local id = data[1]
				exports.DB:zapytanie("UPDATE cs_posiadlosci SET owner=?,time=?,locked=?,occ1=NULL,occ2=NULL WHERE dbid=? LIMIT 1","",0,0,id)
				triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"allow","Dom został pomyślnie zwolniony."})
				triggerClientEvent(plr,"CS:house:client",plr,plr,"ukryj")
				exports["lss-admin"]:rconView_add("[DOM-ZWOLNIJ] "..getPlayerName(plr).." >> dom: "..id..".")
				reloadHouse(id)
			end
		elseif (option=="przepisz") then

		end
	end
end)

addEvent("CS:domy:server:move",true)
addEventHandler("CS:domy:server:move",root,function(plr)
	if plr and isElement(plr) then
		local data = getElementData(plr,"house:cordinates")
		if (data and #data>0) then
			movePlr(plr,data)
		end
	end
end)

addEventHandler("onPickupHit",resourceRoot,function(plr)
	if plr and isElement(plr) and getElementType(plr) == "player" and not getPedOccupiedVehicle(plr) and getElementData(plr,"CID") then
		if getElementData(plr,"player:job") and getElementData(plr,"player:job")=="kurier" then return end
		local data = config[source]
		if not data then return end
		if config[source].free==true then
			local id,cost = config[source].id,config[source].cost
			setElementData(plr,"house:cordinates",data.pos)
			triggerClientEvent(plr,"CS:house:client",plr,plr,"pokaz",{"wolny",id,cost})
		else
			local id = config[source].id
			setElementData(plr,"house:cordinates",data.pos)
			local owner,czas,cost,lock,type = config[source].owner,config[source].time,config[source].cost,config[source].lock, config[source].type
			if(string.find(owner, ","))then
				local own = split(owner, ",")
				for index, value in ipairs(own)do
					if(value) == getElementData(plr,"login")then
						owner = getElementData(plr,"login");
					end
				end
			end
			if (owner and owner==getElementData(plr,"login")) then
				if type ~= "stacja-nos" then
					triggerClientEvent(plr,"CS:house:client",plr,plr,"pokaz",{"wlasciciel",id,czas,cost,lock,type})
				else
					local dbNos = exports.DB:pobierzTabeleWynikow("SELECT * FROM `cs_nos_station` WHERE `house_id` = ?", tonumber(id));
					if(dbNos) and (#dbNos) > (0)then
						triggerClientEvent(plr,"CS:house:client",plr,plr,"pokaz",{"wlasciciel",id,czas,cost,lock,type,config[source].nos_price,source,dbNos[1].station_state, 9, 5000})
					end
				end
			else
				triggerClientEvent(plr,"CS:house:client",plr,plr,"pokaz",{"zajety",id,owner,czas})
			end
		end
	end
end)

addEventHandler("onMarkerHit",resourceRoot,function(plr,dim)
	if plr and isElement(plr) and getElementType(plr) == "player" and not getPedOccupiedVehicle(plr) and getElementData(plr,"CID") and dim then
		if outside[source] then
			local data = outside[source].pos
			if (data and #data>0) then
				movePlr(plr,data)
			end
		end
	end
end)

addEventHandler("onPickupLeave",resourceRoot,function(plr)
	if plr and isElement(plr) and getElementType(plr)=="player" then
		if getElementData(plr,"house:cordinates") then
			removeElementData(plr,"house:cordinates")
		end
		triggerClientEvent(plr,"CS:house:client",plr,plr,"ukryj")
	end
end)

-- always in the end of this code
-- this line will create all houses and set theirs type: free or busy
downloadResults(nil)
