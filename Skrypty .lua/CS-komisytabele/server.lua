--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

local config = {}

function downloadResultMarkers()
    config={}
    local wynik = exports.DB:pobierzTabeleWynikow("SELECT dbid,owner,komisinfoxyz,komisinfo,occ1,occ2 FROM cs_posiadlosci WHERE komisinfoxyz IS NOT NULL")
    for i,v in ipairs(getElementsByType("marker",resourceRoot)) do
        if v and isElement(v) then
	    destroyElement(v)
	  if(config[v])then
            config[v]=nil
	  end
            v=nil
        end
    end
	config = {};

    if wynik and #wynik>0 then
        for _,v in ipairs(wynik) do
            local pos = split(v["komisinfoxyz"],",")
            local x,y,z = pos[1],pos[2],pos[3]
            local marker = createMarker(x,y,z-1,"cylinder",1.25,255,0,0,150)
            config[marker]={owner=v["owner"],text=v["komisinfo"],dbid=v["dbid"],marker=marker,occ1=v["occ1"],occ2=v["occ2"]}
        end
    end

    wynik=nil
end
downloadResultMarkers()
setTimer(function() downloadResultMarkers() end,60000*15,0)


addEventHandler("onMarkerHit",resourceRoot,function(plr,dim)
    if plr and isElement(plr) and getElementType(plr)=="player" then
        if not dim then return end

        if config[source] then
            if getElementData(plr,"login") and (config[source].owner==getElementData(plr,"login")) or (config[source].occ1 and config[source].occ1==getElementData(plr,"login")) or (config[source].occ2 and config[source].occ2==getElementData(plr,"login")) then
                triggerClientEvent(plr,"CS:komisytabele:client",plr,plr,"owner",{config[source].owner,config[source].text,config[source].dbid,config[source].marker})
            else
                triggerClientEvent(plr,"CS:komisytabele:client",plr,plr,"customer",{config[source].owner,config[source].text})
            end
        end
    end
end)

addEvent("CS:komisytabele:server",true)
addEventHandler("CS:komisytabele:server",root,function(plr,typ,data)
    if plr and isElement(plr) then
        if (typ=="new-description") then
            if not data or #data<=0 then return end
            local result=exports.DB:zapytanie("UPDATE cs_posiadlosci SET komisinfo=? WHERE dbid=? LIMIT 1",data[2],data[1])
            if result then
                outputChatBox("#00FF00★ #FFFFFFUdało się zaktualizować opis komisu samochodowego!",plr,0,0,0,true)
                config[data[3]].text=data[2]
            end
            result=nil
        end
    end
end)
