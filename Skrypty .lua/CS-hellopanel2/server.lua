--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

local timer={}

addEvent("CS:helloPanel2:server",true)
addEventHandler("CS:helloPanel2:server",root,function(plr,type,arg)
    if plr and isElement(plr) then
        if (type=="teleport") then
            if (not arg) then return end
            local x,y,z,rz=arg[1],arg[2],arg[3],arg[4]
            fadeCamera(plr,false,1)
            timer[plr]=setTimer(function(plr,x,y,z,rz)
                if plr and isElement(plr) then
                    setElementPosition(plr,x,y,z)
                    setElementRotation(plr,0,0,rz)
                    setCameraTarget(plr,plr)
                    fadeCamera(plr,true)
                    outputChatBox("#3399FF★#FFFFFF Życzymy miłej gry!",plr,0,0,0,true)
                end
            end,1500,1,plr,x,y,z,rz)
        end
    end
end)

addEventHandler("onPlayerQuit",root,function()
    if timer[source] then
        if isTimer(timer[source]) then killTimer(timer[source]) end
        timer[source]=nil
    end
end)