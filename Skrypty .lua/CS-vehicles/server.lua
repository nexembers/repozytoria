--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--
local timer1 = {}
local timer2 = {}
local timer3 = {}
local wynik = {}


addEvent("przechowalnia:pojazd",true)
addEventHandler("przechowalnia:pojazd",root,function(veh)
	if veh and isElement(veh) then
		if isElementInWater(veh) then
			if getVehicleType(veh) == "Boat" or getVehicleType(veh) == "Helicopter" or getVehicleType(veh) == "Plane" then return end
			if getElementData(veh,"veh:dbid") then
				exports.DB:zapytanie("UPDATE cl_vehicles SET storage=? WHERE id=?",1,getElementData(veh,"veh:dbid"))
				triggerEvent("saveVehiclesData:privateVehicles",veh,getElementData(veh,"veh:dbid"))
				timer1[veh] = setTimer(function(veh)
					if veh and isElement(veh) then
						destroyElement(veh)
						timer1[veh] = nil
					end
				end,1000,1,veh)
			end
		end
	end
end)

addEvent("createVehicle:priv",true)
addEventHandler("createVehicle:priv",root,function(plr,model,przebieg,class,capacity,x,y,z,variant1,variant2)
	if model and tonumber(model) and przebieg and tonumber(przebieg) and class and tostring(class) ~= "" and capacity and x and y and z then
		if plr and isElement(plr) and tonumber(getElementData(plr,"CID")) then
			exports.DB:zapytanie("INSERT INTO cl_vehicles (owner,model,przebieg,storage,class,capacity,variant,variant2) VALUES (?,?,?,?,?,?,?,?)",getElementData(plr,"CID"),model,tonumber(przebieg),1,class,capacity,variant1 or 0, variant2 or 0)
			triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"info","Zakupiony pojazd znajduje się\nw przechowalni pojazdów."})
			if isPedInVehicle(plr) then removePedFromVehicle(plr) end
			setElementPosition(plr,x or -1964.32,y or 434.82,z or 35.17)
		end
	end
end)


addEventHandler("onPlayerVehicleExit",getRootElement(),function(theVehicle,leftSeat,jackerPlayer)
	if(theVehicle) and (isElement(theVehicle))then
		if leftSeat == 0 and not jackerPlayer then
			setVehicleLocked(theVehicle,false)
			setElementData(theVehicle,"veh:ostatnikierowca",getPlayerName(source) or "niezidentyfikowano")
			local time = getRealTime()
			local hours = time.hour
			local minutes = time.minute
			local monthday = time.monthday
			local month = time.month
			local year = time.year
			local formattedTime = string.format("%04d-%02d-%02d %02d:%02d", year+1900, month + 1, monthday, hours, minutes)
			setElementData(theVehicle,"veh:activity",formattedTime)
			if(wasEventCancelled())then return false end;
			local id = getElementData(theVehicle,"veh:dbid") or nil;
			if(id) and (tonumber(id))then
				-- local tab = {
				-- 	pos = {getElementPosition(theVehicle)};
				-- 	rot = {getElementRotation(theVehicle)};
				-- };
				-- tab.pos[1], tab.pos[2], tab.pos[3] = string.format("%.02f", tab.pos[1]), string.format("%.02f", tab.pos[2]), string.format("%.02f", tab.pos[3]);
				-- tab.rot[1], tab.rot[2], tab.rot[3] = string.format("%.02f", tab.rot[1]), string.format("%.02f", tab.rot[2]), string.format("%.02f", tab.rot[3]);
				--outputDebugString(tab.pos[1].." | "..tab.pos[2].." | "..tab.pos[3].." | "..tab.rot[1].." | "..tab.rot[2].." | "..tab.rot[3]);
				zapiszPojazd(theVehicle);
				-- exports["DB"]:prepareSet("UPDATE cl_vehicles SET x=?, y=?, z=?, rx=?, ry=?, rz=? WHERE id=?", tab.pos[1], tab.pos[2], tab.pos[3], tab.rot[1], tab.rot[2], tab.rot[3], tonumber(id));
				tab = nil;
				return true;
			end; id = nil;
		end
	end
end)


local keys = {}

function stworzPojazd(wynik)
	for _,v in ipairs(wynik) do
		if v["storage"] == 0 and v["police_parking"] == 0 and v["destroy"] == 0 then
			local x,y,z,rx,ry,rz = v["x"],v["y"],v["z"],v["rx"],v["ry"],v["rz"]
			if x=="" or y=="" or z=="" then x,y,z,rx,ry,rz=0,0,0,0,0,0 end
			local vehicle = createVehicle(v["model"],x,y,z,rx or 0,ry or 0,rz or 0,"CS "..v["id"])
			if v["manual"] == 1 then
				setElementFrozen(vehicle,true)
			end

			if v["opis"] ~= "" then
				setElementData(vehicle,"vehicle:opis",tostring(v["opis"]))
			end

			if v["platetext"]~="" then
				setVehiclePlateText(vehicle,v["platetext"])
			end

			setVehicleVariant(vehicle,tonumber(v["variant"]),tonumber(v["variant2"]))
			if v["pj"] > 3 then
				setVehiclePaintjob(vehicle, 0)
				setElementData(vehicle, "vehicle:custom_pj", v["pj"])
			else
				setVehiclePaintjob(vehicle,v["pj"])
			end
			exports["cs_handlingLoader"]:setVehicleBasicHandling(vehicle)
			setElementData(vehicle,"vehicle:owner",tonumber(v["owner"]))
			setElementData(vehicle,"veh:dbid",tonumber(v["id"]))
			setVehicleColor(vehicle,v["r"],v["g"],v["b"],v["r2"],v["g2"],v["b2"], v["r3"], v["g3"], v["b3"], v["r4"], v["g4"], v["b4"])
			setElementData(vehicle,"bak",v["bak"])
			setElementData(vehicle,"paliwo",v["paliwo"])
			setElementData(vehicle,"vehicle:metres",v["przebieg"]*1000)

			setElementData(vehicle,"vehicle:class",v["class"] or 0)

			setElementHealth(vehicle,v["uszkodzenia"])

			if v["statuskol"] and v["statuskol"] ~= "" and v["statuskol"] ~= " " then wheelstates=split(v["statuskol"],",") setVehicleWheelStates(vehicle,unpack(wheelstates)) else setVehicleWheelStates(vehicle,0,0,0,0) end
			if v["statuspaneli"] and v["statuspaneli"] ~= "0,0,0,0,0,0,0" then panelstates=split(v["statuspaneli"],",") for i,v in ipairs(panelstates) do setVehiclePanelState(vehicle,i-1,tonumber(v)) end end
			if v["statusdrzwi"] then doorstates=split(v["statusdrzwi"],",") for i,v in ipairs(doorstates) do setVehicleDoorState(vehicle,i-1,tonumber(v)) end end

			setVehicleHeadLightColor(vehicle,v["lightr"],v["lightg"],v["lightb"])
			setElementData(vehicle,"veh:ostatnikierowca",v["ostatni"])
			setElementData(vehicle, "veh:activity", v['last_date'])
			local customUpgrades = split(v["customUpgrades"], ",");
			local nos = {v["nos_type"], v["nos_quant"], v["nos_state"]}

			if(tonumber(nos[1])) > (0)then
				setElementData(vehicle, "nos", {quant = tonumber(nos[2]), type = tonumber(nos[1]), state = tonumber(nos[3])})
			end

			setElementData(vehicle,"capacity",v["capacity"] + tonumber(customUpgrades[1]))
			if v["organizacja"] ~= "" then
				setElementData(vehicle,"veh:organizacja",v["organizacja"])
			end

			if v["biznes"] ~= "" then
				setElementData(vehicle,"veh:biznes",v["biznes"])
			end

			addVehicleUpgrade(vehicle,v["up0"])
			addVehicleUpgrade(vehicle,v["up1"])
			addVehicleUpgrade(vehicle,v["up2"])
			addVehicleUpgrade(vehicle,v["up3"])
			addVehicleUpgrade(vehicle,v["up4"])
			addVehicleUpgrade(vehicle,v["up5"])
			addVehicleUpgrade(vehicle,v["up6"])
			addVehicleUpgrade(vehicle,v["up7"])
			addVehicleUpgrade(vehicle,v["up8"])
			addVehicleUpgrade(vehicle,v["up9"])
			addVehicleUpgrade(vehicle,v["up10"])
			addVehicleUpgrade(vehicle,v["up11"])
			addVehicleUpgrade(vehicle,v["up12"])
			addVehicleUpgrade(vehicle,v["up13"])
			addVehicleUpgrade(vehicle,v["up14"])
			addVehicleUpgrade(vehicle,v["up15"])
			addVehicleUpgrade(vehicle,v["up16"])

			timer2[vehicle] = setTimer(function(vehicle)
				if vehicle and isElement(vehicle) then
					if v["tm_masa"] == 1 then
						triggerEvent("SC:tuningmechaniczny:ustaw",vehicle,vehicle,"masa")
					end
					if v["tm_zawieszenie"] == 1 then
						triggerEvent("SC:tuningmechaniczny:ustaw",vehicle,vehicle,"zawieszenie")
					end
					if v["tm_lpg"] == 1 then
						setElementData(vehicle,"lpg",true)
						setElementData(vehicle,"lpg:stan",v["tm_lpgstan"])
						setElementData(vehicle,"lpg:butla",v["tm_lpgbutla"])
					end
					if v["tm_awd"] > 0 then
						triggerEvent("SC:tuningmechaniczny:ustaw",vehicle,vehicle,"awd", v["tm_awd"])
					end
					if v["tm_turbo"] > 0 then
						setElementData(vehicle, "vehicle:tm_turbo", v["tm_turbo"] + customUpgrades[2])
					end
					if v["tm_suspension"] == 1 or v["tm_suspension"] == 2 then
						exports["CS-newmech"]:addNewMechanicalTuneToVehicle("sterring", vehicle, v["tm_suspension"])
					end
					if v["tm_sterring"] >= 1 then
						--exports["CS-newmech"]:addNewMechanicalTuneToVehicle("sterring", vehicle, v["tm_suspension"])
					end
					if v["tm_tires"] == 1 or v["tm_tires"] == 2 then
						exports["CS-newmech"]:addNewMechanicalTuneToVehicle("tires", vehicle, v["tm_tires"])
					end
					if tonumber(v["tm_wheelDistance"]) == 1 or tonumber(v["tm_wheelDistance"]) == 2 then
						triggerEvent("applyWheelDistanceToVehicle", vehicle, vehicle, tonumber(v["tm_wheelDistance"]));
					end
					if tonumber(v["tm_abs"]) == 1  then
						setVehicleHandling(vehicle, "ABS", true);
					end
					if tonumber(v["tm_moresterring"]) == 1  then
						triggerEvent("applyBetterSterringLock", vehicle, vehicle, tonumber(v["tm_moresterring"]));
					end
					if v["tm_windshieldmask"] and (tonumber(v["tm_windshieldmask"]) == (1) or tonumber(v["tm_windshieldmask"]) == (2)) then
						exports["windshield_shader"]:export_applyWindshieldMask(vehicle, v["tm_windshieldmask"]);
					end
					if v["tm_brakes"] and (tonumber(v["tm_brakes"]) == (1)) then
						setVehicleHandling(vehicle,"brakeDeceleration",getOriginalHandling(getElementModel(vehicle)).brakeDeceleration + 3);
					end
					if v["pj"] > 3 then
						triggerClientEvent(root, "vehicle:add_paintjob", root, "add", vehicle, v["pj"])
					end
				end
				timer2[vehicle]=nil
			end,2000,1,vehicle)

			local klucze = v["klucze"] -- klucze nadawane po getElementData(player,"login")
			if klucze then
				if string.len(klucze)>=2 then
					if keys[vehicle] then keys[vehicle]=nil end
					if not keys[vehicle] then keys[vehicle]={} end

					if string.find(klucze,",") then
						klucze = split(klucze,",")
						for _,v in ipairs(klucze) do
							keys[vehicle][v]=true
						end
					else
						keys[vehicle][klucze]=true
					end
				end
			end

		end
	end
end

function findVehicleByID(id)
	if not id or not tonumber(id) then return end
	for _,v in ipairs(getElementsByType("vehicle",resourceRoot)) do
		if getElementData(v,"veh:dbid") == tonumber(id) then
			return v
		end
	end
	return false
end
addEvent("CS:privateCars:findVehicleByID",true)
addEventHandler("CS:privateCars:findVehicleByID",root,findVehicleByID)


function keysSettings(typ,veh,login)
	if not typ or not login then return end
	if (typ=="add-key") then
		if not veh then return end
		if not keys[veh] then keys[veh]={} end
		keys[veh][login]=true
	elseif (typ=="remove-key") then
		if not keys[veh] then return end
		if keys[veh][login] then
			keys[veh][login]=nil
		end
	elseif (typ=="remove-all-keys") then
		if not keys[veh] then return end
		keys[veh]=nil
	end
end
addEvent("CS:privateCars:keysSettings",true)
addEventHandler("CS:privateCars:keysSettings",root,keysSettings)

function createVehicles(id)
	if id and tonumber(id) and tonumber(id) > 0 then
		local wynik = exports.DB:pobierzTabeleWynikow("SELECT * FROM cl_vehicles WHERE id=?",tonumber(id))
		if (wynik and #wynik>0) then
			stworzPojazd(wynik)
		end
		wynik=nil
	else
		local wynik = exports.DB:pobierzTabeleWynikow("SELECT * FROM cl_vehicles WHERE storage=? AND police_parking=? AND destroy=?",0,0,0)
		if (wynik and #wynik>0) then
			stworzPojazd(wynik)
		end
		wynik=nil
	end
end
addEvent("createVehicle:privateVehicle:script",true)
addEventHandler("createVehicle:privateVehicle:script",root,createVehicles)

addEventHandler("onVehicleStartEnter",resourceRoot,function(plr,seat)
	if seat == 0 then
		local veh = source
		if veh and isElement(veh) then
			local CID = getElementData(plr,"CID")
			if CID then
				if tonumber(CID) == tonumber(getElementData(veh,"vehicle:owner")) then return end

				if getElementData(veh,"veh:organizacja") then
					if getElementData(veh,"veh:organizacja") == getElementData(plr,"organizacja") then return end
				end

				if getElementData(veh,"veh:biznes") then
					if getElementData(plr,"biznes") then
						if getElementData(veh,"veh:biznes") == getElementData(plr,"biznes").biznes then return end
					end
				end

				if keys[veh] then
					if keys[veh][getElementData(plr,"login")] then return end
				end

			end
			cancelEvent()
			outputChatBox("#FF0000★ #FFFFFFNie posiadasz kluczyków do tego pojazdu!",plr,0,0,0,true)
		else
			cancelEvent()
		end
	end
end)

function zapiszPojazd(veh)
	if not veh then return end
	local x,y,z = getElementPosition(veh)

	local pos = getElementData(veh,"veh:pos")
	if pos then
		if pos[1] == math.floor(x) and pos[2] == math.floor(y) then return end
	end

	local x,y,z = string.format("%.02f",x),string.format("%.02f",y),string.format("%.02f",z)
	local rx,ry,rz = getElementRotation(veh)
	local rx,ry,rz = string.format("%.02f",rx),string.format("%.02f",ry),string.format("%.02f",rz)
	local przebieg = getElementData(veh,"vehicle:metres") / 1000 or 0
	local przebieg = string.format("%.02f",przebieg)
	local paliwo,bak = (getElementData(veh,"paliwo") or 0),(getElementData(veh,"bak") or 0)
	local r,g,b,r2,g2,b2,r3,g3,b3,r4,g4,b4  = getVehicleColor(veh,true)
	local v1, v2 = getVehicleVariant(veh)
	local vprew = getElementData(veh, "variantPreview");
	if(vprew) and (vprew[1]) and (vprew[2])then
		v1, v2 = vprew[1], vprew[2]
	end
	local nos = {}
	if getElementData(veh, "nos") then
		local data = getElementData(veh, "nos")
		nos = {type = data.type, quant = data.quant, state = data.state};
	else
		nos = {type = 0, quant = 0, state = 0};
	end

	local up0 = getVehicleUpgradeOnSlot(veh,0) or 0 -- hood
	local up1 = getVehicleUpgradeOnSlot(veh,1) or 0 -- vent
	local up2 = getVehicleUpgradeOnSlot(veh,2) or 0 -- spoiler
	local up3 = getVehicleUpgradeOnSlot(veh,3) or 0 -- sideskirt
	local up4 = getVehicleUpgradeOnSlot(veh,4) or 0 -- front bullbars
	local up5 = getVehicleUpgradeOnSlot(veh,5) or 0 -- rear bullbars
	local up6 = getVehicleUpgradeOnSlot(veh,6) or 0 -- headlights
	local up7 = getVehicleUpgradeOnSlot(veh,7) or 0 -- roof
	local up8 = getVehicleUpgradeOnSlot(veh,8) or 0 -- nitro
	local up9 = getVehicleUpgradeOnSlot(veh,9) or 0 -- hydraulics
	local up10 = getVehicleUpgradeOnSlot(veh,10) or 0 -- stereo
	local up11 = getVehicleUpgradeOnSlot(veh,11) or 0
	local up12 = getVehicleUpgradeOnSlot(veh,12) or 0 -- wheels
	local up13 = getVehicleUpgradeOnSlot(veh,13) or 0 -- exhaust
	local up14 = getVehicleUpgradeOnSlot(veh,14) or 0 -- front bumper
	local up15 = getVehicleUpgradeOnSlot(veh,15) or 0 -- rear bumper
	local up16 = getVehicleUpgradeOnSlot(veh,16) or 0 -- misc
	local uszkodzenie = getElementHealth(veh)
	uszkodzenie = math.floor(uszkodzenie)
	if uszkodzenie < 301 then uszkodzenie = 301 end
	local wheelstates=table.concat({getVehicleWheelStates(veh)},",")
	panelstates={} for i=0,6 do table.insert(panelstates,getVehiclePanelState(veh,i)) end
	local panelstates=table.concat(panelstates,",")
	doorstates={} for i=0,5 do table.insert(doorstates,getVehicleDoorState(veh,i)) end
	local doorstates=table.concat(doorstates,",")

	if isElementFrozen(veh) then reczny=1 else reczny=0 end
	local stanlpg = getElementData(veh,"lpg:stan") or 0

	exports.DB:prepareSet("UPDATE cl_vehicles SET tm_lpgstan=?,ostatni=?, last_date=?,przebieg=?, x=?, y=?, z=?, rx=?, ry=?, rz=?, manual=?, bak=?, variant=?, variant2=?, paliwo=?, r=?,g=?,b=?,r2=?,g2=?,b2=?, up0=?,up1=?,up2=?,up3=?,up4=?,up5=?,up6=?,up7=?,up8=?,up9=?,up10=?,up11=?,up12=?,up13=?,up14=?,up15=?,up16=?,uszkodzenia=?,statusdrzwi=?,statuskol=?,statuspaneli=?,opis=?,nos_type=?,nos_quant=?,nos_state=? WHERE id=? LIMIT 1",stanlpg,getElementData(veh,"veh:ostatnikierowca") or "brak", getElementData(veh, "veh:activity") or "brak",przebieg,x,y,z,rx,ry,rz,reczny or 1,bak,v1,v2,paliwo,r,g,b,r2,g2,b2,up0,up1,up2,up3,up4,up5,up6,up7,up8,up9,up10,up11,up12,up13,up14,up15,up16,uszkodzenie,doorstates,wheelstates,panelstates,(getElementData(veh,"vehicle:opis") or ""), nos.type, nos.quant, nos.state, getElementData(veh,"veh:dbid"))

	setElementData(veh,"veh:pos",{math.floor(x),math.floor(y)},false)
end

local timerveh = {}

function saveVehiclesData(id)
	if id and tonumber(id) then
		--[[for _,veh in ipairs(getElementsByType("vehicle",resourceRoot)) do
			if getElementData(veh,"veh:dbid") == tonumber(id) then
				outputDebugString("Wykonano zapis pojazdu o id "..id.."!")
				zapiszPojazd(veh)
			end
		end]]
		local veh = findVehicleByID(tonumber(id))
		if veh and isElement(veh) then
			if getElementData(veh,"veh:dbid") then
				outputDebugString("Wykonano zapis pojazdu o id "..id.."!")
				zapiszPojazd(veh)
			end
		end
	else
		for _,veh in ipairs(getElementsByType("vehicle",resourceRoot)) do
			if(isElement(veh))then
				zapiszPojazd(veh)
				if isElementInWater(veh) and not getVehicleOccupant(veh,0) then
					if getVehicleType(veh) == "Boat" or getVehicleType(veh) == "Helicopter" or getVehicleType(veh) == "Plane" then return end
					if getElementData(veh,"veh:dbid") then
						exports.DB:zapytanie("UPDATE cl_vehicles SET storage=? WHERE id=?",1,getElementData(veh,"veh:dbid"))
						triggerEvent("saveVehiclesData:privateVehicles",veh,getElementData(veh,"veh:dbid"))
						timerveh[veh] = setTimer(function(veh)
							if veh and isElement(veh) then
								if keys[veh] then keys[veh]=nil end
								destroyElement(veh)
								timerveh[veh]=nil
							end
						end,1000,1,veh)
					end
				end
			end
		end
		outputDebugString("Wykonano zapis pojazdów prywatnych!")
	end
end
setTimer(function()
	saveVehiclesData(nil)
end,60000*5,0)
addEvent("saveVehiclesData:privateVehicles",true)
addEventHandler("saveVehiclesData:privateVehicles",root,saveVehiclesData)

addEventHandler("onResourceStop",resourceRoot,function()
	saveVehiclesData(nil)
end)

addEventHandler("onResourceStart",resourceRoot,function()
	createVehicles(nil)
end)

function returnBlip (plr)
	if keys then
		triggerClientEvent(plr, "CL-vehiclesgui:createBlipKeys", plr, plr, keys)
	end
end
addEvent("CL-vehicles:returnBlip", true)
addEventHandler("CL-vehicles:returnBlip", root, returnBlip)
