--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

-- triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie wprowadzono żadnej\nwiadomości!"})

function isVehicleEmpty( vehicle )
	if not isElement( vehicle ) or getElementType( vehicle ) ~= "vehicle" then
		return true
	end

	local passengers = getVehicleMaxPassengers( vehicle )
	if type( passengers ) == 'number' then
		for seat = 0, passengers do
			if getVehicleOccupant( vehicle, seat ) then
				return false
			end
		end
	end
	return true
end

local vehs = {
    --{x,y,z,rx,ry,rz},
    {-1392.47,-223.67,14.34,0.23,359.75,315},
    {-1379.92,-236.84,14.32,0.26,359.62,315},
    {-1362.47,-253.02,14.32,0.26,359.83,315},
    {-1345.69,-269.09,14.32,0.27,359.69,315},
    {-1302.12,-265.74,14.34,0.23,359.79,315},
    {-1316.86,-250.61,14.33,0.26,359.92,315},
    {-1330.61,-236.41,14.32,0.27,359.43,315},
    {-1345.21,-223.19,14.32,0.26,359.64,315},
    {-1360.81,-205.90,14.36,0.17,359.43,315},
}

for _,v in ipairs(vehs) do
    local veh = createVehicle(487,v[1],v[2],v[3],v[4],v[5],v[6],"KONTENERY")
    setVehicleColor(veh,255,255,255,0,0,0)
    setElementFrozen(veh,true)
    setElementData(veh,"veh:reczny",true)
end

local statusoff = false

addCommandHandler("stoppracakontenery",function(plr,cmd)
    if plr and isElement(plr) then
        if getElementData(plr,"admin:rank") ~= "RCON" then return end
        statusoff=true
        outputChatBox("Zastopowano możliwość rozpoczynania pracy kontenerów.",plr)
    end
end)

addEventHandler("onVehicleStartEnter",resourceRoot,function(plr,seat)
    if seat == 0 then
        if statusoff then
            triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Możliwość rozpoczynania pracy\nzostała tymczasowo wstrzymana!"})
            cancelEvent()
            return
        end

        if getElementData(plr,"player:job") then
            triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Posiadasz rozpoczętą pracę!\nZakończ ją, aby móc pracować\nw tym miejscu!"})
            cancelEvent()
            return
        end
    end
end)

addEventHandler("onVehicleEnter",resourceRoot,function(plr,seat)
    if seat==0 then
        triggerClientEvent(plr,"CS:praca:kontenery:client",plr,plr,"pokazzaladunek")
        setElementData(plr,"player:job","kontenery")
    end
end)

addEventHandler("onVehicleExit",resourceRoot,function(plr,seat)
    if seat == 0 then
        triggerClientEvent(plr,"CS:praca:kontenery:client",plr,plr,"zakonczprace")
        triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"info","Praca została zakończona."})
    end
end)

setTimer(function()
    for _,v in ipairs(getElementsByType("vehicle",resourceRoot)) do
        if isVehicleEmpty(v) then
            respawnVehicle(v)
            fixVehicle(v)
            setElementFrozen(v,true)
            if not getElementData(v,"veh:reczny") then
                setElementData(v,"veh:reczny",true)
            end
            setVehicleEngineState(v,false)
            setVehicleLocked(v,false)
        end
    end
end,60000,0)

addEventHandler("onPlayerQuit",root,function()
    triggerClientEvent(source,"CS:praca:kontenery:client",source,source,"zakonczprace")
end)