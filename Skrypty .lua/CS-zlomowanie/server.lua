--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

local wynik=nil

local markers = {
	--{x,y,z,dim,int},
	{-1852.51,-1698.84,40.87,0,0},
	{-1848.52,-1677.13,21.76,0,0},
}

for _,v in ipairs(markers) do
	local marker = createMarker(v[1],v[2],v[3]-1,"cylinder",4,100,150,200,50,root)
	setElementDimension(marker,v[4] or 0)
	setElementInterior(marker,v[5] or 0)
end

addEventHandler("onMarkerHit",resourceRoot,function(plr,dim)
	if plr and isElement(plr) and getElementType(plr)=="player" and dim then
		local veh = getPedOccupiedVehicle(plr)
		if veh and isElement(veh) then
			if getVehicleController(veh)==plr then
				if not getElementData(veh,"veh:dbid") then triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie możesz zezłomować\npojazdu, który nie jest prywatny!"}) return end
				if getElementData(veh,"vehicle:owner")~=getElementData(plr,"CID") then triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie jesteś właścicielem\ntego pojazdu!"}) return end
				wynik=exports.DB:pobierzTabeleWynikow("SELECT destroy FROM cs_pojemnosci WHERE (model=? AND destroy>0)",getElementModel(veh))
				if (wynik and #wynik>0) then
					for _,v in ipairs(wynik) do
						triggerClientEvent(plr,"CS:zlomowaniepojazdow:client",plr,plr,"pokaz",{getElementData(veh,"veh:dbid"),getElementModel(veh),v["destroy"]})
					end
				else
					triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Tego pojazdu nie da się\nzezłomować!"})
				end
				wynik=nil
			end
		end
	end
end)

addEvent("CS:zlomowaniepojazdow:server",true)
addEventHandler("CS:zlomowaniepojazdow:server",root,function(plr,typ,dane)
	if plr and isElement(plr) then
		if (typ=="zlomowanie") then
			local data=dane
			if (data and #data>0) then
				local id,model,cost = data[1],data[2],data[3]
				if not cost and cost<0 then return end
				if not getPedOccupiedVehicle(plr) then return end
				exports.DB:zapytanie("UPDATE cl_vehicles SET destroy=?,owner=? WHERE (owner=? AND id=?) LIMIT 1",1,1,getElementData(plr,"CID"),id)
				givePlayerMoney(plr,cost)
				exports["lss-admin"]:rconView_add("[ZŁOMOWANIE] "..getPlayerName(plr).." >> "..id.." (model: "..model..") >> dostał "..cost.." PLN.")
				destroyElement(getPedOccupiedVehicle(plr))
				triggerClientEvent(plr,"CS:zlomowaniepojazdow:client",plr,plr,"ukryj")
				triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"allow","Zezłomowano pojazd o #81b1d3id "..id.."#FFFFFF.\nOtrzymujesz #81b1d3"..cost..".00 PLN#FFFFFF."})
			end
		end
	end
end)