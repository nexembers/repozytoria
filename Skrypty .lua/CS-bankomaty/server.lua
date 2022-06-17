--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

addEventHandler("onResourceStart",resourceRoot,function()
	local result = exports.DB:pobierzTabeleWynikow("SELECT posXYZ,rotXYZ,dim,bliprespawn FROM cl_bankomaty")
	if (result and #result>0) then
		for _,v in ipairs(result) do
			local posXYZ = v["posXYZ"]
			local posXYZ = split(posXYZ,",")
			local x,y,z = posXYZ[1],posXYZ[2],posXYZ[3]

			local rotXYZ = v["rotXYZ"]
			local rotXYZ = split(rotXYZ,",")
			local rx,ry,rz = rotXYZ[1],rotXYZ[2],rotXYZ[3]

			local dim = v["dim"]

			local bankomat = createObject(2618,x,y,z-1,rx,ry,rz) -- obiekt
			setElementDimension(bankomat,dim)
			local marker = createMarker(x,y,z-0.5,"cylinder",1.5,255,0,0,0,root)
            setElementDimension(marker,dim)
            if v["bliprespawn"]==1 then
                local blip = createBlip(x,y,z,52,2,255,0,0,255,0.35,350,getRootElement())
                setElementDimension(blip,dim)
            end
		end
	end
end)

addEventHandler("onMarkerHit",resourceRoot,function(plr,dim)
    if plr and isElement(plr) and getElementType(plr) == "player" and dim then
        if getPedOccupiedVehicle(plr) then return end
        if not getElementData(plr,"CID") then return end
        if not getElementData(plr,"bankmoney") then return end

        --if getElementData(plr,"admin:rank") ~= "RCON" then outputChatBox("Bankomaty w trakcie przerabiania!",plr,255,0,0,true) return end

        triggerClientEvent(plr,"CS:bankomaty:client",plr,plr,"pokaz")
    end
end)

addEvent("CS:bankomaty:server",true)
addEventHandler("CS:bankomaty:server",root,function(plr,konto,typ,data)
    if plr and isElement(plr) then
        if not konto and typ then
            if (typ=="pobierzdane") then
                if (data=="organizacja") then
                    local wynik = exports.DB:pobierzTabeleWynikow("SELECT money FROM cs_organizacje WHERE organizacja=? LIMIT 1",getElementData(plr,"organizacja"))
                    if wynik and #wynik>0 then
                        local bankmoney = nil
                        for _,v in ipairs(wynik) do
                            bankmoney = v["money"]
                        end
                        if bankmoney then
                            triggerClientEvent(plr,"CS:bankomaty:client",plr,plr,"kontoorganizacji",bankmoney)
                        else
                            outputChatBox("#FF0000★ #FFFFFFWystąpił błąd podczas pobierania danych.",plr,0,0,0,true)
                        end
                    else
                        outputChatBox("#FF0000★ #FFFFFFTwoja organizacja nie posiada utworzonego konta organizacyjnego. Utwórz spawn organizacji, a konto zostanie automatycznie utworzone.",plr,0,0,0,true)
                    end
                elseif (data=="biznes") then
                    local biznes = getElementData(plr,"biznes")
                    if not biznes then outputChatBox("#FF0000★ #FFFFFFNie należysz do żadnego biznesu!",plr,0,0,0,true) return end
                    local wynik = exports.DB:pobierzTabeleWynikow("SELECT money FROM cs_biznesy WHERE biznes=? LIMIT 1",biznes.biznes)
                    if wynik and #wynik>0 then
                        local bankmoney = nil
                        for _,v in ipairs(wynik) do
                            bankmoney = v["money"]
                        end
                        if bankmoney then
                            triggerClientEvent(plr,"CS:bankomaty:client",plr,plr,"kontobiznesu",bankmoney)
                        else
                            outputChatBox("#FF0000★ #FFFFFFWystąpił błąd podczas pobierania danych.",plr,0,0,0,true)
                        end
                    else
                        outputChatBox("#FF0000★ #FFFFFFTwój biznes nie posiada utworzonego konta biznesowego. Utwórz spawn biznesu, a konto zostanie atuomatycznie utworzone.",plr,0,0,0,true)
                    end
                elseif (data=="company") then
                    local result = exports.DB:pobierzTabeleWynikow("SELECT company_Account FROM cl_characters WHERE CID = ? LIMIT 1", getElementData(plr, "CID"))
                    if result and #result > 0 then
                        if result[1].company_Account then
                            triggerClientEvent(plr,"CS:bankomaty:client",plr,plr,"company_Account",result[1].company_Account)
                        end
                    end
                elseif (data=="admin") then
                    local result = exports.DB:pobierzTabeleWynikow("SELECT taxAccountValue FROM cs_taxSystem WHERE taxPrefix = ? LIMIT 1", "moneyTrade")
                    if result and #result > 0 then
                        if result[1].taxAccountValue then
                            triggerClientEvent(plr,"CS:bankomaty:client",plr,plr,"admin_Account",result[1].taxAccountValue)
                        end
                    end
                end
            end
            return
        end
        if (konto=="prywatne") then
            if not data then outputChatBox("#FF0000★ #FFFFFFWystąpił błąd podczas przekazywania danych. Spróbuj ponownie za chwilę!",plr,0,0,0,true) return end
            if data < 1 or data>=1000000 then outputChatBox("#FF0000★ #FFFFFFWystąpił błąd podczas przekazywania danych. Spróbuj ponownie za chwilę!",plr,0,0,0,true) return end
            if (typ=="wyplata") then
                if getElementData(plr,"bankmoney")<data then
                    triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie posiadasz wystarczającej ilości\ngotówki na swoim koncie\nbankowym, aby móc ją wypłacić!"})
                    return
                end
                setElementData(plr,"bankmoney",getElementData(plr,"bankmoney")-tonumber(data))
                givePlayerMoney(plr,tonumber(data))
                exports["lss-admin"]:rconView_add("[BANKOMAT-WYPŁATA] "..getPlayerName(plr).." >> "..data.." PLN.")
                exports.DB:zapytanie("INSERT INTO cs_bankomatytransakcje SET CID=?,login=?,nick=?,typ=?,kwota=?,inne=?",getElementData(plr,"CID"),getElementData(plr,"login"),getPlayerName(plr),"wypłata",tonumber(data),"konto prywatne")
            elseif (typ=="wplata") then
                if getPlayerMoney(plr)<data then
                    triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie posiadasz wystarczającej ilości\ngotówki na swoim koncie,\naby móc ją wpłacić na swoje\nkonto bankowe!"})
                    return
                end
                takePlayerMoney(plr,tonumber(data))
                setElementData(plr,"bankmoney",getElementData(plr,"bankmoney")+tonumber(data))
                exports["lss-admin"]:rconView_add("[BANKOMAT-WPŁATA] "..getPlayerName(plr).." >> "..data.." PLN.")
                exports.DB:zapytanie("INSERT INTO cs_bankomatytransakcje SET CID=?,login=?,nick=?,typ=?,kwota=?,inne=?",getElementData(plr,"CID"),getElementData(plr,"login"),getPlayerName(plr),"wpłata",tonumber(data),"konto prywatne")
            end
        elseif (konto=="organizacja") then
            if not data then outputChatBox("#FF0000★ #FFFFFFWystąpił błąd podczas przekazywania danych. Spróbuj ponownie za chwilę!",plr,0,0,0,true) return end
            if data < 1 or data>=1000000 then outputChatBox("#FF0000★ #FFFFFFWystąpił błąd podczas przekazywania danych. Spróbuj ponownie za chwilę!",plr,0,0,0,true) return end
            if (typ=="wyplata") then
                if getElementData(plr,"organizacja:ranga:typ") then
                    if getElementData(plr,"organizacja:ranga:typ") < 2 then
                        outputChatBox("#FF0000★ #FFFFFFJedynie lider organizacji ma dostęp do wypłaty pieniędzy!",plr,0,0,0,true)
                        return
                    end
                    local wynik = exports.DB:pobierzTabeleWynikow("SELECT money FROM cs_organizacje WHERE organizacja=? LIMIT 1",getElementData(plr,"organizacja"))
                    if wynik and #wynik>0 then
                        for _,v in ipairs(wynik) do
                            if v["money"] < tonumber(data) then
                                triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie posiadasz wystarczającej ilości\ngotówki na koncie organizacji,\naby móc ją wpłacić na swoje\nkonto bankowe!"})
                                return
                            end
                            exports.DB:zapytanie("UPDATE cs_organizacje SET money=? WHERE organizacja=? LIMIT 1",v["money"]-tonumber(data),getElementData(plr,"organizacja"))
                            exports["lss-admin"]:rconView_add("[BANKOMAT-ORG-WYPŁATA] "..getPlayerName(plr).." >> "..data.." PLN.")
                            triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"allow","Wypłacono #008000"..data..".00 PLN#FFFFFF\nz konta organizacyjnego!"})
                            givePlayerMoney(plr,tonumber(data))
                            triggerClientEvent(plr,"CS:bankomaty:client",plr,plr,"pokaz")
                            exports.DB:zapytanie("INSERT INTO cs_bankomatytransakcje SET CID=?,login=?,nick=?,typ=?,kwota=?,inne=?",getElementData(plr,"CID"),getElementData(plr,"login"),getPlayerName(plr),"wypłata",tonumber(data),getElementData(plr,"organizacja"))
                        end
                    else
                        outputChatBox("#FF0000★ #FFFFFFNie udało sie pobrać wyniku z bazy danych! Spróbuj ponownie później!",plr,0,0,0,true)
                    end
                else
                    outputChatBox("#FF0000★ #FFFFFFBrak nadanej rangi w organizacji!",plr,0,0,0,true)
                end
            elseif (typ=="wplata") then
                if getPlayerMoney(plr)<data then
                    triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie posiadasz wystarczającej ilości\ngotówki na swoim koncie,\naby móc ją wpłacić na swoje\nkonto bankowe!"})
                    return
                end

                takePlayerMoney(plr,tonumber(data))
                exports["lss-admin"]:rconView_add("[BANKOMAT-ORG-WPŁATA] "..getPlayerName(plr).." >> "..data.." PLN.")

                local wynik = exports.DB:pobierzTabeleWynikow("SELECT money FROM cs_organizacje WHERE organizacja=? LIMIT 1",getElementData(plr,"organizacja"))
                if wynik and #wynik>0 then
                    for _,v in ipairs(wynik) do
                        exports.DB:zapytanie("UPDATE cs_organizacje SET money=? WHERE organizacja=? LIMIT 1",v["money"]+tonumber(data),getElementData(plr,"organizacja"))
                        triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"allow","Wpłacono #008000"..data..".00 PLN#FFFFFF\nna konto organizacyjne!"})
                        triggerClientEvent(plr,"CS:bankomaty:client",plr,plr,"pokaz")
                        exports["lss-admin"]:rconView_add("[BANKOMAT-ORG-WPŁATA] "..getPlayerName(plr).." >> saldo org po: "..v["money"]+tonumber(data)..".00 PLN")
                        exports.DB:zapytanie("INSERT INTO cs_bankomatytransakcje SET CID=?,login=?,nick=?,typ=?,kwota=?,inne=?",getElementData(plr,"CID"),getElementData(plr,"login"),getPlayerName(plr),"wpłata",tonumber(data),getElementData(plr,"organizacja"))
                    end
                else
                    outputChatBox("#FF0000★ #FFFFFFNie udało sie pobrać wyniku dotyczącego organizacji z bazy danych! Złóż wniosek na forum w dziale pomoc!",plr,0,0,0,true)
                end

            end
        elseif (konto=="biznes") then
            if not data then outputChatBox("#FF0000★ #FFFFFFWystąpił błąd podczas przekazywania danych. Spróbuj ponownie za chwilę!",plr,0,0,0,true) return end
            if data < 1 or data>=1000000 then outputChatBox("#FF0000★ #FFFFFFWystąpił błąd podczas przekazywania danych. Spróbuj ponownie za chwilę!",plr,0,0,0,true) return end
            local biznes = getElementData(plr,"biznes")
            if not biznes then outputChatBox("#FF0000★ #FFFFFFNie należysz do żadnego biznesu!",plr,0,0,0,true) return end
            if (typ=="wyplata") then
                if biznes.lider then
                    if biznes.lider < 2 then
                        outputChatBox("#FF0000★ #FFFFFFJedynie lider biznesu ma dostęp do wypłaty pieniędzy!",plr,0,0,0,true)
                        return
                    end
                    local wynik = exports.DB:pobierzTabeleWynikow("SELECT money FROM cs_biznesy WHERE biznes=? LIMIT 1",biznes.biznes)
                    if wynik and #wynik>0 then
                        for _,v in ipairs(wynik) do
                            if v["money"] < tonumber(data) then
                                triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie posiadasz wystarczającej ilości\ngotówki na koncie biznesowym,\naby móc ją wpłacić na swoje\nkonto bankowe!"})
                                return
                            end
                            exports.DB:zapytanie("UPDATE cs_biznesy SET money=? WHERE biznes=? LIMIT 1",v["money"]-tonumber(data),getElementData(plr,"biznes").biznes)
                            exports["lss-admin"]:rconView_add("[BANKOMAT-BIZ-WYPŁATA] "..getPlayerName(plr).." >> "..data.." PLN.")
                            triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"allow","Wypłacono #008000"..data..".00 PLN#FFFFFF\nz konta biznesowego!"})
                            givePlayerMoney(plr,tonumber(data))
                            exports.DB:zapytanie("INSERT INTO cs_bankomatytransakcje SET CID=?,login=?,nick=?,typ=?,kwota=?,inne=?",getElementData(plr,"CID"),getElementData(plr,"login"),getPlayerName(plr),"wypłata",tonumber(data),getElementData(plr,"biznes").biznes)
                            triggerClientEvent(plr,"CS:bankomaty:client",plr,plr,"pokaz")
                        end
                    else
                        outputChatBox("#FF0000★ #FFFFFFNie udało sie pobrać wyniku z bazy danych! Spróbuj ponownie później!",plr,0,0,0,true)
                    end
                else
                    outputChatBox("#FF0000★ #FFFFFFBrak nadanej rangi w biznesie!",plr,0,0,0,true)
                end
            elseif (typ=="wplata") then
                if getPlayerMoney(plr)<data then
                    triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie posiadasz wystarczającej ilości\ngotówki na swoim koncie,\naby móc ją wpłacić na swoje\nkonto bankowe!"})
                    return
                end

                takePlayerMoney(plr,tonumber(data))
                exports["lss-admin"]:rconView_add("[BANKOMAT-BIZ-WPŁATA] "..getPlayerName(plr).." >> "..data.." PLN.")

                local wynik = exports.DB:pobierzTabeleWynikow("SELECT money FROM cs_biznesy WHERE biznes=? LIMIT 1",getElementData(plr,"biznes").biznes)
                if wynik and #wynik>0 then
                    for _,v in ipairs(wynik) do
                        exports.DB:zapytanie("UPDATE cs_biznesy SET money=? WHERE biznes=? LIMIT 1",v["money"]+tonumber(data),getElementData(plr,"biznes").biznes)
                        triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"allow","Wpłacono #008000"..data..".00 PLN#FFFFFF\nna konto biznesowe!"})
                        triggerClientEvent(plr,"CS:bankomaty:client",plr,plr,"pokaz")
                        exports.DB:zapytanie("INSERT INTO cs_bankomatytransakcje SET CID=?,login=?,nick=?,typ=?,kwota=?,inne=?",getElementData(plr,"CID"),getElementData(plr,"login"),getPlayerName(plr),"wpłata",tonumber(data),getElementData(plr,"biznes").biznes)
                        exports["lss-admin"]:rconView_add("[BANKOMAT-BIZ-WPŁATA] "..getPlayerName(plr).." >> saldo biznesu po: "..v["money"]+tonumber(data)..".00 PLN")
                    end
                else
                    outputChatBox("#FF0000★ #FFFFFFNie udało sie pobrać wyniku dotyczącego biznesu z bazy danych! Złóż wniosek na forum w dziale pomoc!",plr,0,0,0,true)
                end

            end
        elseif (konto=="firma") then
            if (typ=="wyplata") then
                local wynik = exports.DB:pobierzTabeleWynikow("SELECT company_Account FROM cl_characters WHERE CID = ? LIMIT 1", getElementData(plr, "CID"))
                if wynik and #wynik > 0 then
                    if wynik[1].company_Account < tonumber(data) then
                        triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie posiadasz wystarczającej ilości\ngotówki na koncie firmwoym,\naby móc ją wpłacić na swoje\nkonto bankowe!"})
                        return
                    end
                    exports.DB:zapytanie("UPDATE cl_characters SET company_Account = ? WHERE CID = ? LIMIT 1", wynik[1].company_Account - tonumber(data), getElementData(plr,"CID"))
                    exports.DB:zapytanie("INSERT INTO cs_bankomatytransakcje SET CID=?,login=?,nick=?,typ=?,kwota=?,inne=?",getElementData(plr,"CID"),getElementData(plr,"login"),getPlayerName(plr),"wypłata", tonumber(data), "firmowe")
                    exports["lss-admin"]:rconView_add("[BANKOMAT-FIR-WYPŁATA] "..getPlayerName(plr).." >> "..data.." PLN.")
                    triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"allow","Wypłacono #008000"..data..".00 PLN#FFFFFF\nz konta firmowego!"})
                    givePlayerMoney(plr,tonumber(data))
                    triggerClientEvent(plr,"CS:bankomaty:client",plr,plr,"pokaz")
                end
            end
        elseif (konto=="admin") then
            if not data then outputChatBox("#FF0000★ #FFFFFFWystąpił błąd podczas przekazywania danych. Spróbuj ponownie za chwilę!",plr,0,0,0,true) return end
            if data < 1 or data>=1000000 then outputChatBox("#FF0000★ #FFFFFFWystąpił błąd podczas przekazywania danych. Spróbuj ponownie za chwilę!",plr,0,0,0,true) return end
            local rank = getElementData(plr,"admin:rank")
            if rank ~= "RCON" and rank ~= "Globaladministrator" then outputChatBox("#FF0000★ #FFFFFFNie masz uprawnień do tego konta!",plr,0,0,0,true) return end
            if (typ=="wyplata") then
                    local wynik = exports.DB:pobierzTabeleWynikow("SELECT taxAccountValue FROM cs_taxSystem WHERE taxPrefix=? LIMIT 1","moneyTrade")
                    if wynik and #wynik>0 then
                        for _,v in ipairs(wynik) do
                            if v["taxAccountValue"] < tonumber(data) then
                                triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Brak wystarczającej ilości \ngotówki na koncie administracyjnym!"})
                                return
                            end
                            exports.DB:zapytanie("UPDATE cs_taxSystem SET taxAccountValue=? WHERE taxPrefix=? LIMIT 1",v["taxAccountValue"]-tonumber(data),"moneyTrade")
                            exports["lss-admin"]:rconView_add("[BANKOMAT-ADM-WYPŁATA] "..getPlayerName(plr).." >> "..data.." PLN.")
                            exports.DB:zapytanie("INSERT INTO cs_bankomatytransakcje SET CID=?,login=?,nick=?,typ=?,kwota=?,inne=?",getElementData(plr,"CID"),getElementData(plr,"login"),getPlayerName(plr),"wypłata",tonumber(data),"konto administracyjne")
                            triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"allow","Wypłacono #008000"..data..".00 PLN#FFFFFF\nz konta administracyjnego!"})
                            givePlayerMoney(plr,tonumber(data))
                            triggerClientEvent(plr,"CS:bankomaty:client",plr,plr,"pokaz")
                        end
                    else
                        outputChatBox("#FF0000★ #FFFFFFNie udało sie pobrać wyniku z bazy danych! Spróbuj ponownie później!",plr,0,0,0,true)
                    end
            elseif (typ=="wplata") then
                if getPlayerMoney(plr)<data then
                    triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie posiadasz wystarczającej ilości\ngotówki na swoim koncie,\naby móc ją wpłacić na swoje\nkonto bankowe!"})
                    return
                end

                takePlayerMoney(plr,tonumber(data))
                exports["lss-admin"]:rconView_add("[BANKOMAT-ADM-WPŁATA] "..getPlayerName(plr).." >> "..data.." PLN.")

                local wynik = exports.DB:pobierzTabeleWynikow("SELECT taxAccountValue FROM cs_taxSystem WHERE taxPrefix=? LIMIT 1","moneyTrade")
                if wynik and #wynik>0 then
                    for _,v in ipairs(wynik) do
                        exports.DB:zapytanie("UPDATE cs_taxSystem SET taxAccountValue=? WHERE taxPrefix=? LIMIT 1",v["taxAccountValue"]+tonumber(data),"moneyTrade")
                        triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"allow","Wpłacono #008000"..data..".00 PLN#FFFFFF\nna konto administracyjne!"})
                        triggerClientEvent(plr,"CS:bankomaty:client",plr,plr,"pokaz")
                        exports["lss-admin"]:rconView_add("[BANKOMAT-ADM-WPŁATA] "..getPlayerName(plr).." >> saldo administracji po: "..v["taxAccountValue"]+tonumber(data)..".00 PLN")
                        exports.DB:zapytanie("INSERT INTO cs_bankomatytransakcje SET CID=?,login=?,nick=?,typ=?,kwota=?,inne=?",getElementData(plr,"CID"),getElementData(plr,"login"),getPlayerName(plr),"wpłata",tonumber(data),"konto administracyjne")
                    end
                else
                    outputChatBox("#FF0000★ #FFFFFFNie udało sie pobrać wyniku dotyczącego konta administracyjnego z bazy danych! Złóż wniosek na forum w dziale pomoc!",plr,0,0,0,true)
                end

            end
        end
    end
end)
