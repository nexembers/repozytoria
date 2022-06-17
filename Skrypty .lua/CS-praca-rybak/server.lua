--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

local config={}
local timer={}

local starts = {
    --{"miasto",    x,y,z,},
    --{"LS",2913.23,-1970.29,1.32}, -- LS
    {"LV",1639.50,604.23,7.78}, -- LV
}

local sellers = {
    --{2917.06,-1986.49,1.32}, -- LS
    {1653.85,605.28,7.78}, -- LV
}

local buyers = {
    --{2916.03,-1973.72,1.32}, -- LS
    {1647.96,604.17,7.78},-- LV
}

for _,v in ipairs(starts) do
    local marker = createMarker(v[2],v[3],v[4]-1,"cylinder",1.25,100,150,200,50,root)
    config[marker]={info="rozpoczynanie",miasto=v[1]}
end

for _,v in ipairs(sellers) do
    local marker = createMarker(v[1],v[2],v[3]-1,"cylinder",1.25,200,200,0,50,root)
    config[marker]={info="sprzedaz"}
end

for _,v in ipairs(buyers) do
    local marker = createMarker(v[1],v[2],v[3]-1,"cylinder",1.25,0,200,0,50,root)
    config[marker]={info="kupno"}
end

function math.float(min,max)
    return math.random() + math.random(min,max)
end

local stoppracarybak=false
addCommandHandler("stoppracarybak",function(plr,cmd)
    if plr and isElement(plr) then
        if getElementData(plr,'admin:rank')~="RCON" then return end
        stoppracarybak=true
        outputChatBox("Zastopowano mozliwość rozpoczynania pracy na rybaku!",plr)
    end
end)

addEventHandler("onMarkerHit",resourceRoot,function(plr,dim)
    if plr and isElement(plr) and getElementType(plr) == "player" and dim then
        local marker = source
        if config[marker] then
            if config[marker].info=="rozpoczynanie" then
                if stoppracarybak then outputChatBox("Praca rybaka chwilowo jest modernizowana!", plr) return end
                triggerClientEvent(plr,"CS:praca:rybak:client",plr,plr,"pokaz",config[marker].miasto)
            elseif config[marker].info=="sprzedaz" then
                if not config[plr] then return end
                zapisDB(plr)
                if getElementData(plr,"player:job") and getElementData(plr,"player:job")=="rybak" then
                    local wynik = exports.DB:pobierzTabeleWynikow("SELECT karas,karp,dorsz,losos,halibut,wegorz,szczupak FROM cs_rybak WHERE CID=? LIMIT 1",getElementData(plr,"CID"))
                    if wynik and #wynik>0 then
                        triggerClientEvent(plr,"CS:praca:rybak:client",plr,plr,"sprzedazryb",wynik)
                    end
                else
                    outputChatBox("#FF0000★#FFFFFF Nie posiadasz rozpoczętej pracy rybaka, więc nie możesz zakupić przynęt!",plr,0,0,0,true)
                end
            elseif config[marker].info=="kupno" then
                if not config[plr] then return end
                if getElementData(plr,"player:job") and getElementData(plr,"player:job")=="rybak" then
                    if config[plr].przynety then
                        triggerClientEvent(plr,"CS:praca:rybak:client",plr,plr,"kupnoprzynet",config[plr].przynety)
                    else
                        outputChatBox("#FF0000★#FFFFFF Wystąpił błąd związany z wyświetleniem panelu zakupu przynęt!",plr,0,0,0,true)
                    end
                else
                    outputChatBox("#FF0000★#FFFFFF Nie posiadasz rozpoczętej pracy rybaka, więc nie możesz zakupić przynęt!",plr,0,0,0,true)
                end
            end
        end
    end
end)

function togglesControls(plr,tryb)
	toggleControl(plr,"enter_exit",tryb)
	toggleControl(plr,"sprint",tryb)
	toggleControl(plr,"jump",tryb)
    toggleControl(plr,"crouch",tryb)
    setPedWalkingStyle(plr,0)
end

function statusOfJob(plr,typ,data)
    if plr and isElement(plr) then
        if (typ=="przynety") then
            if not config[plr] then config[plr]={} end
            local wynik = exports.DB:pobierzTabeleWynikow("SELECT przynety FROM cs_rybak WHERE CID=? LIMIT 1",getElementData(plr,"CID"))
            if wynik and #wynik>0 then
                triggerClientEvent(plr,"CS:praca:rybak:client",plr,plr,"przynety-wczytaj",wynik[1].przynety)
                config[plr].przynety=wynik[1].przynety
            else
                exports.DB:zapytanie("INSERT INTO cs_rybak SET login=?,nick=?,CID=?",getElementData(plr,"login"),getPlayerName(plr),getElementData(plr,"CID"))
                config[plr].przynety=0
                triggerClientEvent(plr,"CS:praca:rybak:client",plr,plr,"przynety-wczytaj",0)
            end
            togglesControls(plr,false)
            giveWeapon(plr,7,1,true)
        elseif (typ=="zakoncz") then
            takeWeapon(plr,7)
            statusOfJob(plr,"zakonczprace")
            removeElementData(plr,"player:job")
        elseif (typ=="buy-przynety") then
            if data and #data>0 then
                local count,cost = data[1],data[2]
                if getPlayerMoney(plr)<cost then return end
                takePlayerMoney(plr,tonumber(cost))
                
                exports.DB:zapytanie("UPDATE cs_rybak SET przynety=przynety+? WHERE CID=? LIMIT 1",tonumber(count),getElementData(plr,"CID"))
                config[plr].przynety = config[plr].przynety + tonumber(count)

                triggerClientEvent(plr,"CS:praca:rybak:client",plr,plr,"actualing-przynety",config[plr].przynety)

                outputChatBox("#00FF00★ #FFFFFFZakupiono #FFFF00"..count.."#FFFFFF przynęt za kwotę #008000"..cost..".00 PLN#FFFFFF.",plr,0,0,0,true)
            end
        elseif (typ=="losing") then
            if timer[plr] and isTimer(timer[plr]) then return end
            if not data or #data==0 then return end
            if not config[plr] then return end
            config[plr].przynety = config[plr].przynety-1
            setElementFrozen(plr,true)
            setElementRotation(plr,0,0,data[1])
            setPedAnimation(plr,"SWORD","sword_IDLE")
            outputChatBox("#FFFF00★ #FFFFFFPoczekaj chwilę! Trwa połów ryb.",plr,0,0,0,true)
            timer[plr] = setTimer(function(plr)
                if plr and isElement(plr) then

                    setElementFrozen(plr,false)
                    setPedAnimation(plr,false)

                    losujRybe(plr)
                    losujCP(plr)

                    if config[plr].przynety % 15 == 0 then
                        zapisDB(plr)
                    end

                    triggerClientEvent(plr,"CS:praca:rybak:client",plr,plr,"next-point",config[plr].przynety)
                    timer[plr]=nil
                end
            end,data[2],1,plr)
        elseif (typ=="zakonczprace") then
            zapisDB(plr)
            if timer[plr] and isTimer(timer[plr]) then killTimer(timer[plr]) timer[plr]=nil end
            if config[plr] then config[plr]=nil end
            removeElementData(plr,"player:job")
            takeWeapon(plr,7)
            togglesControls(plr,true)
        elseif (typ=="sprzedazryb") then
            local wynik = exports.DB:pobierzTabeleWynikow("SELECT karas,karp,dorsz,losos,halibut,wegorz,szczupak FROM cs_rybak WHERE CID=? LIMIT 1",getElementData(plr,"CID"))
            if wynik and #wynik>0 then
		if wynik[1].karas > 0 or wynik[1].karp > 0 or wynik[1].dorsz > 0 or wynik[1].losos > 0 or wynik[1].halibut > 0 or wynik[1].wegorz > 0 or wynik[1].szczupak > 0 then
                local costofall = 0
                for _,v in ipairs(wynik) do
                    local cashkaras = v["karas"]*cashfromfish["karas"]
                    local cashkarp = v["karp"]*cashfromfish["karp"]
                    local cashdorsz = v["dorsz"]*cashfromfish["dorsz"]
                    local cashlosos = v["losos"]*cashfromfish["losos"]
                    local cashhalibut = v["halibut"]*cashfromfish["halibut"]
                    local cashwegorz = v["wegorz"]*cashfromfish["wegorz"]
                    local cashszczupak = v["szczupak"]*cashfromfish["szczupak"]
                    costofall = cashkaras+cashkarp+cashdorsz+cashlosos+cashhalibut+cashwegorz+cashszczupak
                end
                --outputChatBox("Łącznie: "..costofall,plr)
                local result = exports.DB:zapytanie("UPDATE cs_rybak SET karas=?,karp=?,dorsz=?,losos=?,halibut=?,wegorz=?,szczupak=? WHERE CID=? LIMIT 1",0,0,0,0,0,0,0,getElementData(plr,"CID"))
                if result then
                    triggerEvent("CS:wyplatapraca",plr,plr,"rybak",costofall)
                end
		else
			outputChatBox("* Nie posiadasz ryb!", plr)
		end
                result=nil
            end
            wynik=nil
        end
    end
end
addEvent("CS:praca:rybak:server",true)
addEventHandler("CS:praca:rybak:server",root,statusOfJob)

function losujCP(plr)
    if plr and isElement(plr) then
        local rnd = math.random(1,6)
        if rnd == 1 then
            local rnd = math.random(1,3)
            setElementData(plr,"calm:points",getElementData(plr,"calm:points")+rnd)
            outputChatBox("#00FF00★ #FFFFFFWylosowano "..rnd.." punktów CP!",plr,0,0,0,true)
        end
    end
end

function losujRybe(plr)
    if plr and isElement(plr) then
        local szansa = math.random(1,100)
        if losingfish[szansa] then
            if losingfish[szansa]=="karas" then
                if not config[plr].karas then config[plr].karas=0 end
                config[plr].karas = config[plr].karas + math.float(0,1)
                outputChatBox("#FFFF00★ #FFFFFFUdało się złowić karasia!",plr,0,0,0,true)
            elseif losingfish[szansa]=="karp" then
                if not config[plr].karp then config[plr].karp=0 end
                config[plr].karp = config[plr].karp + math.float(0,1)
                outputChatBox("#FFFF00★ #FFFFFFUdało się złowić karpia!",plr,0,0,0,true)
            elseif losingfish[szansa]=="dorsz" then
                if not config[plr].dorsz then config[plr].dorsz=0 end
                config[plr].dorsz = config[plr].dorsz + math.float(0,1)
                outputChatBox("#FFFF00★ #FFFFFFUdało się złowić dorsza!",plr,0,0,0,true)
            elseif losingfish[szansa]=="losos" then
                if not config[plr].losos then config[plr].losos=0 end
                config[plr].losos = config[plr].losos + math.float(0,1)*0.96
                outputChatBox("#FFFF00★ #FFFFFFUdało się złowić łososia!",plr,0,0,0,true)
            elseif losingfish[szansa]=="halibut" then
                if not config[plr].halibut then config[plr].halibut=0 end
                config[plr].halibut = config[plr].halibut + math.float(0,1)*0.93
                outputChatBox("#FFFF00★ #FFFFFFUdało się złowić halibuta!",plr,0,0,0,true)
            elseif losingfish[szansa]=="wegorz" then
                if not config[plr].wegorz then config[plr].wegorz=0 end
                config[plr].wegorz = config[plr].wegorz + math.float(0,1)*0.9
                outputChatBox("#FFFF00★ #FFFFFFUdało się złowić węgorza!",plr,0,0,0,true)
            elseif losingfish[szansa]=="szczupak" then
                if not config[plr].szczupak then config[plr].szczupak=0 end
                config[plr].szczupak = config[plr].szczupak + math.float(0,1)*0.85
                outputChatBox("#FFFF00★ #FFFFFFUdało się złowić szczupaka!",plr,0,0,0,true)
            elseif losingfish[szansa]=="brak" then
                local rndelse = math.random(1,7)
                if rndelse==1 then
                    outputChatBox("#FF9900★ #FFFFFFWyłowiono buta z dna...",plr,0,0,0,true)
                elseif rndelse==2 then
                    outputChatBox("#FF9900★ #FFFFFFWyłowiono puszkę z dna...",plr,0,0,0,true)
                elseif rndelse==3 then
                    outputChatBox("#FF9900★ #FFFFFFWyłowiono kalosza z dna...",plr,0,0,0,true)
                elseif rndelse==4 then
                    outputChatBox("#FF9900★ #FFFFFFWyłowiono kawałek płótna z dna...",plr,0,0,0,true)
                else
                    outputChatBox("#FF9900★ #FFFFFFPrzynęta została zerwana - ryba za mocno szarpnęła...",plr,0,0,0,true)
                end
            end
        end
    end
end

local configtime = {}

function zapisDB(plr)
    if plr and isElement(plr) then

        if not configtime[plr] then configtime[plr]={} end
        if not configtime[plr].time then configtime[plr].time=getTickCount()-5000 end
        if configtime[plr].time+5000>getTickCount() then return end
        configtime[plr].time=getTickCount()

        if not config[plr] then return end
        if not config[plr].karas then config[plr].karas=0 end
        if not config[plr].karp then config[plr].karp=0 end
        if not config[plr].dorsz then config[plr].dorsz=0 end
        if not config[plr].losos then config[plr].losos=0 end
        if not config[plr].halibut then config[plr].halibut=0 end
        if not config[plr].wegorz then config[plr].wegorz=0 end
        if not config[plr].szczupak then config[plr].szczupak=0 end
        if config[plr].karas>0 or config[plr].dorsz>0 or config[plr].losos>0 or config[plr].halibut>0 or config[plr].wegorz>0 or config[plr].szczupak>0 then
            exports.DB:zapytanie("UPDATE cs_rybak SET przynety=?,karas=karas+?,karp=karp+?,dorsz=dorsz+?,losos=losos+?,halibut=halibut+?,wegorz=wegorz+?,szczupak=szczupak+? WHERE CID=? LIMIT 1",
            tonumber(config[plr].przynety),config[plr].karas,config[plr].karp,config[plr].dorsz,config[plr].losos,config[plr].halibut,config[plr].wegorz,config[plr].szczupak,getElementData(plr,"CID"))
            config[plr].karas,config[plr].karp,config[plr].dorsz,config[plr].losos,config[plr].halibut,config[plr].wegorz,config[plr].szczupak=0,0,0,0,0,0,0
        else
            exports.DB:zapytanie("UPDATE cs_rybak SET przynety=? WHERE CID=? LIMIT 1",tonumber(config[plr].przynety),getElementData(plr,"CID"))
        end
    end
end

addEventHandler("onPlayerQuit",root,function()
    --statusOfJob(source,"zakonczprace")
    if timer[source] and isTimer(timer[source]) then killTimer(timer[source]) end
    if timer[source] then timer[source]=nil end
    if config[source] then config[source]=nil end
    if configtime[source] then configtime[source]=nil end
end)