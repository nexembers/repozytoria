--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

-- triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie wprowadzono żadnej\nwiadomości!"})

local komisy = {
    --{id_domu (z db),  x,y,z(markera do wystawiania opisu),    x,y,z(cuboida),dlugosc,szerokosc,wysokosc(cuboida),    id,x,y,z,rz(bramy)},
    {202,   -1921.58,574.34,35.17,  -1962.24,555.31,35.28,43,33.5,5.5,    969,-1962.44,573.19,31.90,90},
    {203,   -1778.76,-562.20,16.60,  -1808.87,-562.17,16.41,37.5,75,5,    975,-1798.51,-565.91,14.4,0},
    {204,   -2098.80,-5.10,35.32,  -2129.19,-34.50,35.32,32,51,5,  975,-2097.60,-9.9,33.5,90},
    {301,  2458.86,1112.38,10.82,  2437.29,1082.93,10.82,51,51,5,  969,2446.38,1085.91,7.5,180},
    {369,  1700.55,2237.48,11.06,   1677.72,2182.01,10.82,40,56,5, 975,1682.5,2183.199,9,180},
}

local markerstexts = {}
local markersgates = {}
local timer = {}

local ilosc = 0
for _,v in ipairs(komisy) do
    if v[1] then
        local wynik = exports.DB:pobierzTabeleWynikow("SELECT owner,dbid,occ1,occ2 FROM cs_posiadlosci WHERE (dbid=? AND type=?) LIMIT 1",v[1],"komis")
        if wynik and #wynik>0 then
            for _,data in ipairs(wynik) do
                local marker = createMarker(v[2],v[3],v[4]-1,"cylinder",1.25,180,0,0,50,root)
                local shape = createColCuboid(v[5],v[6],v[7]-1.5,v[8],v[9],v[10])
                markerstexts[marker]={dbid=v["dbid"],owner=data["owner"],cuboid=shape,occ1=data["occ1"],occ2=data["occ2"]}

                local markergate = createMarker(v[12],v[13],v[14]-1,"cylinder",8,0,0,0,0,root)
                local gate = createObject(v[11],v[12],v[13],v[14],0,0,v[15])


                markersgates[markergate] = {dbid=v["dbid"],owner=data["owner"],object=gate,position={v[12],v[13],v[14]},occ1=data["occ1"],occ2=data["occ2"]}
            end
        end


        wynik=nil
        ilosc = ilosc + 1
    end
end

addEvent("CS:komisy:setNewOwner",true)
addEventHandler("CS:komisy:setNewOwner",root,function(owner,id)
    if owner and id then
        --[[
        local gate,texts = nil,nil
        for _,v in ipairs(getElementsByType("marker",resourceRoot)) do
            if markersgates[v] and markersgates[v].dbid == id then
                gate=markergates[v]
                outputDebugString("mam gateowy",3)
            end
            if markerstexts[v] and markerstexts[v].dbid == id then
                texts=markerstexts[v]
                outputDebugString("mam textowy",3)
            end
        end
        if gate and texts then
            markerstexts[texts] = {dbid=id,owner=owner,cuboid=markerstexts[texts].cuboid}
            local pos = markersgates[texts].position
            markersgates[texts] = {dbid=id,owner=owner,object=markersgates[texts].gate,position={pos[1],pos[2],pos[3]}}
            outputDebugString("Przeładowano komis samochodowy nr "..id.." - zmiana właściciela na "..owner)
        end]]
        restartResource(getThisResource())
    end
end)

addEventHandler("onMarkerHit",resourceRoot,function(plr,dim)
    if plr and isElement(plr) and getElementType(plr) == "player" and dim then
        --if not getElementData(plr,"admin:rank") then return end

        local marker = source
        if not getPedOccupiedVehicle(plr) then
            if markerstexts[marker] then
                if markerstexts[marker].owner==getElementData(plr,"login") or (markerstexts[marker].occ1 and markerstexts[marker].occ1==getElementData(plr,"login")) or (markerstexts[marker].occ2 and markerstexts[marker].occ2==getElementData(plr,"login")) then
                    triggerClientEvent(plr,"CS:komisy:client",plr,plr,"wystaw",{markerstexts[marker].cuboid})
                    return
                end
            end
        end
        if markersgates[marker] then
            if markersgates[marker].owner==getElementData(plr,"login") or (markersgates[marker].occ1 and markersgates[marker].occ1==getElementData(plr,"login")) or (markersgates[marker].occ2 and markersgates[marker].occ2==getElementData(plr,"login")) then
                moveObject(markersgates[marker].object,3000,markersgates[marker].position[1],markersgates[marker].position[2],markersgates[marker].position[3]-1)
            end
            if markersgates[marker].owner==getElementData(plr,"login") or (markersgates[marker].occ1 and markersgates[marker].occ1==getElementData(plr,"login")) or (markersgates[marker].occ2 and markersgates[marker].occ2==getElementData(plr,"login")) then
                moveObject(markersgates[marker].object,3000,markersgates[marker].position[1],markersgates[marker].position[2],markersgates[marker].position[3]-1)
            end
            if markersgates[marker].owner==getElementData(plr,"login") or (markersgates[marker].occ1 and markersgates[marker].occ1==getElementData(plr,"login")) or (markersgates[marker].occ2 and markersgates[marker].occ2==getElementData(plr,"login")) then
                moveObject(markersgates[marker].object,3000,markersgates[marker].position[1],markersgates[marker].position[2],markersgates[marker].position[3]-1)
            end
        end
    end
end)

addEventHandler("onMarkerLeave",resourceRoot,function(plr)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        local marker = source
        if markersgates[marker] then
            if markersgates[marker].owner==getElementData(plr,"login") or (markersgates[marker].occ1 and markersgates[marker].occ1==getElementData(plr,"login")) or (markersgates[marker].occ2 and markersgates[marker].occ2==getElementData(plr,"login")) then
                moveObject(markersgates[marker].object,3000,markersgates[marker].position[1],markersgates[marker].position[2],markersgates[marker].position[3])
            end
            if markersgates[marker].owner==getElementData(plr,"login") or (markersgates[marker].occ1 and markersgates[marker].occ1==getElementData(plr,"login")) or (markersgates[marker].occ2 and markersgates[marker].occ2==getElementData(plr,"login")) then
                moveObject(markersgates[marker].object,3000,markersgates[marker].position[1],markersgates[marker].position[2],markersgates[marker].position[3])
            end
            if markersgates[marker].owner==getElementData(plr,"login") or (markersgates[marker].occ1 and markersgates[marker].occ1==getElementData(plr,"login")) or (markersgates[marker].occ2 and markersgates[marker].occ2==getElementData(plr,"login")) then
                moveObject(markersgates[marker].object,3000,markersgates[marker].position[1],markersgates[marker].position[2],markersgates[marker].position[3])
            end
        end
    end
end)

addEventHandler("onColShapeLeave",resourceRoot,function(veh)
    if veh and isElement(veh) and getElementType(veh) == "vehicle" then
        if getElementData(veh,"vehicle:opis") then
            removeElementData(veh,"vehicle:opis")
        end
    end
end)

function getVehicleOwnerName (cid)
    if cid then
        local owner = exports['DB']:pobierzTabeleWynikow("SELECT CID, nick FROM cl_characters WHERE CID = ? LIMIT 1", cid)
        return owner[1].nick
    end
end

function findOnlinePlayer(cid)
    if(cid) and (tonumber(cid))then
        for index, value in pairs(getElementsByType("player")) do
            if(value) and (isElement(value))then
                if(tonumber(getElementData(value, "CID"))) == (cid)then
                    return value;
                end
            end
        end
    end
    return false
end

function komis_buyOfflineMethod(buyer, vehicle)
    if(buyer) and (isElement(buyer))then
        if(vehicle) and (isElement(vehicle))then
            local isPrivate = getElementData(vehicle, "veh:dbid");
            if(isPrivate)then
                local getDescription = getElementData(vehicle, "vehicle:opis");
                if(getDescription)then getDescription = string.gsub(getDescription, "#%x%x%x%x%x%x", ""); getDescription = string.gsub(getDescription, "\n", "") end;
                if(getDescription) and (tostring(getDescription)) and (string.find(getDescription, "Kupno offline możliwe"))then
                    local vehiclePrice = {{string.find(getDescription, "Cena pojazdu: ")}, {string.find(getDescription, ".00] PLN")}};
                    if(vehiclePrice) and (tonumber(vehiclePrice[1][2])) and (tonumber(vehiclePrice[2][1]))then
                        vehiclePrice = string.sub(getDescription, vehiclePrice[1][2]+2, vehiclePrice[2][1]-1);
                        if(vehiclePrice) and (tonumber(vehiclePrice))then
                            if(getElementData(vehicle, "vehicle:owner")) == (getElementData(buyer,"CID"))then
                                outputChatBox("Jesteś już właścicielem tego pojazdu", buyer, 200, 200, 200, false);
                                return false;
                            end
                            vehiclePrice = tonumber(vehiclePrice);
                            local taxNumber = tonumber(exports["cs_taxSystem"]:getTaxFromNumber("moneyTrade", vehiclePrice))
                            if(taxNumber) and (tonumber(taxNumber))then vehiclePrice = vehiclePrice; taxNumber = {true, taxNumber} else taxNumber = false end;
                            if(getPlayerMoney(buyer)) >= (vehiclePrice)then
                                if(takePlayerMoney(buyer, vehiclePrice))then
                                    local oldOwner = getElementData(vehicle, "vehicle:owner");
                                    if(oldOwner) and (tonumber(oldOwner))then
                                        local calcPrice = (taxNumber and vehiclePrice - taxNumber[2] or vehiclePrice);
                                        local incomeText = "		⚅ Central Bank of San Andreas ⚅\n		  CalmStory ©2021\n\nNadzór pełni Policja, wysłano poprzez United States Post Office\n=======================================\n\nOdbiorca: "..(getVehicleOwnerName(oldOwner) or "Ty").."\nIdentyfikator klienta "..oldOwner.."\nNadawca: "..(getPlayerName(buyer).." ("..getElementData(buyer,"CID")..")" or "").."\nTytuł transakcji: Zakupiono pojazd z komisu ("..(isPrivate or 0)..") "..(getVehicleName(vehicle) or "").."\nOdbiór przyznano OFFLINE\nPrzelew przychodzący\nWartość przelewu: "..(vehiclePrice or 0).." PLN\nPodatek: doliczono (2%)\n\n=======================================\nPrezes CoRFX (15147)\nKierownik PVK (5)\n- Central Bank Of San Andreas\n- Urząd podatkowy San Andreas"
                                        local findSeller = findOnlinePlayer(oldOwner);
                                        if(findSeller) and (isElement(findSeller))then
                                            if(givePlayerMoney(findSeller, calcPrice))then
                                                outputChatBox("[KOMIS] Otrzymano nową wiadomość, /wiadomosci", findSeller, 200, 200, 200, false);
                                                incomeText = string.gsub(incomeText, "Odbiór przyznano OFFLINE", "Odbiór przyznano ONLINE");
                                            end
                                        else
                                            exports["DB"]:prepareSet("UPDATE `cl_characters` SET `bank` = `bank` + ? WHERE `CID` = ?", calcPrice, oldOwner);
                                        end
                                        setElementData(vehicle,"vehicle:owner",getElementData(buyer,"CID"))
                                        if getElementData(vehicle,"veh:organizacja") then removeElementData(vehicle,"veh:organizacja") end
                                        exports.DB:zapytanie("UPDATE cl_vehicles SET owner=?,organizacja=? WHERE id=? LIMIT 1",getElementData(buyer,"CID"),"",isPrivate)
                                        exports["lss-admin"]:rconView_add("[VEH-buy (KOMIS - OFFLINE)] "..getPlayerName(buyer).." >> id "..isPrivate.." >> cena "..vehiclePrice.." PLN (Old owner: "..(oldOwner or "false")..")")
                                        local insert = exports.DB:zapytanie("INSERT INTO cs_vehicles_transactions_logs (buyer_cid, buyer_name, model, model_name, vehicle_id, price, dealer_name, dealer_cid, sale_date) VALUES(?,?,?,?,?,?,?,?,NOW())", getElementData(buyer, "CID"), getPlayerName(buyer), getElementModel(vehicle), getVehicleNameFromModel(getElementModel(vehicle)), isPrivate, vehiclePrice, oldOwner, oldOwner);
                                        exports["DB"]:prepareSet("INSERT INTO `cs_offlineMessages` (authorCID, readerCID, message, messageSend, authorName) VALUES ('"..getElementData(buyer,"CID").."', ?, ?, NOW(), 'Central Bank of San Andreas') ", tonumber(oldOwner), incomeText)
                                        if(taxNumber) and (taxNumber[1]) and (tonumber(taxNumber[2]))then
                                            exports["cs_taxSystem"]:addToAccount("moneyTrade", taxNumber[2]);
                                        end
                                        setElementData(vehicle, "vehicle:opis", false)
                                        return true;
                                    end
                                end
                            else
                                outputChatBox("Aby zakupić ten pojazd, musisz mieć "..vehiclePrice.." PLN w gotówce", buyer, 200, 200, 200, false);
                            end
                        end
                    end
                else
                    outputChatBox("Ten pojazd nie jest wystawiony jako pojazd do sprzedaży offline", buyer, 200, 200, 200, false);
                end
            else
                outputChatBox("Ten pojazd nie jest wystawiony jako pojazd prywatny", buyer, 200, 200, 200, false);
            end
        end
    end
    return;
end
addEvent("komis:offlineBuy", true); addEventHandler("komis:offlineBuy", root, komis_buyOfflineMethod)

-- function testBuy(player)
--     if(player)then
--         return komis_buyOfflineMethod(player, getPedOccupiedVehicle(player));
--     end
-- end
-- addCommandHandler("komis.testBuy", testBuy)

function findOwner (plr, owner)
    if plr and owner and tonumber(owner) then
        local result = false
       for i,v in ipairs(getElementsByType('player')) do
            if getElementData(v, "CID") == owner then
                 result = v
                break;
            end
        end
        return result;
    end
end

local wystawianie = {}

addEvent("CS:komisy:server",true)
addEventHandler("CS:komisy:server",root,function(plr,typ,data)
    if plr and isElement(plr) then
        if (typ=="wystaw") then
            if data and data.vehicle and data.price then
                local id = string.gsub(split(data.vehicle,",")[1],"ID pojazdu: ","")
                local cena = tonumber(data.price)
                local veh = nil
                for _,v in ipairs(getElementsByType("vehicle")) do
                    if getElementData(v,"veh:dbid") and getElementData(v,"veh:dbid") == tonumber(id) then
                        veh = v
                    end
                end
                if veh and isElement(veh) then
                    local owner = getElementData(veh, "vehicle:owner")
                    owner = findOwner(plr, owner)
                    if owner and isElement(owner) then
                        wystawianie[owner] = {id = id, veh = veh, price = cena, player = plr, data = data}
                        triggerClientEvent(plr,"CS:komisy:client",plr,plr,"ukryj")
                        outputChatBox("Wysłano potwierdzenie do właściciela pojazdu, oczekuj na akceptację.", plr, 255,255,255)
                        outputChatBox("Gracz "..getPlayerName(plr).." chce wystawić twój pojazd id #00ff00"..id.." #ffffff za #00ff00"..cena.." PLN#ffffff w swoim komisie. Aby zatwierdzić wpisz #00ff00/wystaw.zaakceptuj <"..id..">#ffffff.", owner, 255,255,255,true);
                        setTimer(function()
                            if wystawianie[owner] then
                                wystawianie[owner] = nil
                            end
                        end, 1000*60, 1)
                    else
                        outputChatBox("Właściciel pojazdu nie jest aktualnie w grze.", plr, 255,0,0)
                        wystawianie[owner] = nil
                    end
                else
                    outputChatBox("#FF0000★ #FFFFFFNie udało odnaleźć się pojazdu!",plr,255,0,0,true)
                    wystawianie[owner] = nil
                end
            end
        end
    end
end)


function zaakceptujWystawianie (plr, cmd, id)
    if not id or not tonumber(id) then outputChatBox("Nie podano id pojazdu.", plr, 255,0,0) return end
    if not wystawianie[plr] then outputChatBox("Nikt nie wystawiał twojego pojazdu w komisie.", plr, 255,0,0) return end
    if wystawianie[plr].id == id then
        local veh = wystawianie[plr].veh
        local data = wystawianie[plr].data
        local upgrade = "Tuning wizualny: "
        if #getVehicleUpgrades(veh)>0 then
            for i,v in ipairs(getVehicleUpgrades(veh)) do
                if i==#getVehicleUpgrades(veh) then
                    upgrade = upgrade..""..v
                else
                    upgrade = upgrade..""..v..", "
                end
            end
        else
            upgrade = "Tuning wizualny: brak"
        end
        if getElementData(veh,"veh:awd") then
            upgrade = upgrade.."\n\nDodatkowy tuning mechaniczny:\nUM1"
        end
        if getElementData(veh,"veh:zawieszenie") then
            upgrade = upgrade..", regulacja zawieszenia"
        end
        if getElementData(veh,"lpg") then
            upgrade = upgrade..", LPG"
        end
        if getElementData(veh,"bak")>35 then
            upgrade = upgrade..", bak "..math.floor(getElementData(veh,"bak")).."l"
        end
        if getElementData(veh,"vehicle:tm_turbo") then
            upgrade = upgrade.."\nTurbosprężarka: "..getElementData(veh,"vehicle:tm_turbo").." bara"
        end
        if getElementData(veh,"vehicle:tm_suspension") then
            if getElementData(veh,"vehicle:tm_suspension") == 1 then
                upgrade = upgrade.."\nUkład kierowniczy: sportowy"
            elseif getElementData(veh,"vehicle:tm_suspension") == 2 then
                upgrade = upgrade.."\nUkład kierowniczy: wyczynowy"
            end
        end
        if getElementData(veh,"vehicle:tm_tires") then
            if getElementData(veh,"vehicle:tm_tires") == 1 then
                upgrade = upgrade.."\nOgumienie: sportowe"
            elseif getElementData(veh,"vehicle:tm_tires") == 2 then
                upgrade = upgrade.."\nOgumienie: wyczynowe"
            end
        end

        local capacity,defcapacity=getElementData(veh,"capacity"),getElementData(veh,"defcapacity")
        defaultcapacity=""
        if capacity and defcapacity then
            if capacity>defcapacity then
                defaultcapacity = "\n* (Pojemność #81b1d3zwiększona o "..string.format("%.01f",capacity-defcapacity).." dm3 #FFFFFFod domyślnej) *"
            elseif capacity<defcapacity then
                defaultcapacity = "\n* (Pojemność #81b1d3zmniejszona o "..string.format("%.01f",defcapacity-capacity).." dm3 #FFFFFFod domyślnej) *"
            else
                defaultcapacity = ""
            end
        end

        setElementData(veh,"vehicle:opis","Pojazd marki #81b1d3"..getVehicleName(veh).."#FFFFFF (model: #81b1d3"..getElementModel(veh).."#FFFFFF)\nPrzebieg: #81b1d3"..string.format("%.01f",(getElementData(veh,"vehicle:metres")/1000)).." km#FFFFFF\nPojemność silnika: "..string.format("%.01f",getElementData(veh,"capacity")).." dm3 "..defaultcapacity.."\n"..upgrade.."\n\nID pojazdu: #81b1d3"..getElementData(veh,"veh:dbid").."#FFFFFF\nCena pojazdu: [#81b1d3"..math.floor(wystawianie[plr].price)..".00#FFFFFF] PLN"..(data.negociatePrice and " #1458c7[Do negocjacji]#FFFFFF" or "").."\n"..(data.offlineSale and "#124eb0[Kupno offline możliwe]#ffffff" or "Skontaktuj się z właścicielem pojazdu - #81b1d3"..getVehicleOwnerName(getElementData(veh, "vehicle:owner")).."#FFFFFF"))
        triggerClientEvent(wystawianie[plr].player,"CS:powiadomienie",wystawianie[plr].player,wystawianie[plr].player,{"allow","Pojazd został wystawiony\nw komisie samochodowym!"})
        triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"allow","Twój pojazd został wystawiony\nw komisie samochodowym."})
        wystawianie[plr] = nil
    end
end
addCommandHandler("wystaw.zaakceptuj", zaakceptujWystawianie)

outputDebugString("Stworzono "..ilosc.." komisów samochodowych.")


addEventHandler("onPlayerQuit", root, function()
    if wystawianie[source] then
        wystawianie[source] = nil
    end
end)
