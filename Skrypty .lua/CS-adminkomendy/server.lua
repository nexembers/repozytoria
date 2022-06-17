--[[
@Autor: NeX (Krystian Janas)
@Copyright: Calm Story/Life MTA, NeX, 2016/2017/20[...]
@Zakazuje się rozpowszechniania bądź używania zasoby bez zgody pierwotnego autora zasobu (NeX).
@By dostać zgodę na używanie zasobu, zgłoś się do autora zasobu.
@Po uzyskaniu zgody na używanie zasobu, autor powinien pozostać bez naruszenia.

Po złamaniu zasad rozpowszechniania zasobu bądź naruszenia zmiany autora zasobu, zastrzegam możliwość zgłoszenia sprawy na Policję
pod względem "Naruszenia Majątkowych Praw Autorskich".

@Kontakt: postofficeNeX@gmail.com
]]--



local timer5 = {}
local timer6 = {}
local timer8 = {}

function findPlayer(plr,cel)
    local target=nil
    if (tonumber(cel) ~= nil) then
        target=getElementByID("p"..cel)
    else -- podano fragment nicku
        for _,thePlayer in ipairs(getElementsByType("player")) do
            if string.find(string.gsub(getPlayerName(thePlayer):lower(),"#%x%x%x%x%x%x", ""), cel:lower(), 1, true) then
                if (target) then
                    outputChatBox("Znaleziono wiecej niz jednego gracza o pasujacym nicku, podaj wiecej liter.", plr)
                    return nil
                end
                target=thePlayer
            end
        end
    end
    return target
end

local config = {}
addCommandHandler("sp",function(plr,cmd)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if not getElementData(plr,"admin:rank") then return end
        if not config[plr] then config[plr]={} end
        local x,y,z = getElementPosition(plr)
        config[plr].pos = {x,y,z}
        outputChatBox("#FFFF00★ #FFFFFFZapisano pozycję. Wczytaj ją za pomocą komendy /lp.",plr,0,0,0,true)
    end
end)

addCommandHandler("devmode",function()
	if getElementData(localPlayer,"admin:rank") ~= "RCON" and getElementData(localPlayer, "admin:rank") ~= "Globaladministrator" then return end
	setDevelopmentMode(true)
	outputChatBox("* Tryb /devmode dla RCON został włączony. Komendy przydatne: /showcol 1")
end)


addCommandHandler("ping",function(plr,cmd,text)
    if timer5[plr] and isTimer(timer5[plr]) then return end
    timer5[plr] = setTimer(function() end,250,1)
    if getElementData(plr,"admin:rank") then
        if text and tostring(text) then
            local cel = findPlayer(plr,text)
            if cel then
                outputChatBox("Ping gracza: "..getPlayerPing(cel),plr)
                exports["lss-admin"]:rconView_add("[PLAYER-PING] "..getPlayerName(plr).." >> "..getPlayerName(cel)..".")
            end
        else
            local rx,ry,rz = getElementRotation(plr)
            if isPedInVehicle(plr) then
                setElementRotation(getPedOccupiedVehicle(plr),rx,ry,rz+180)
                local x,y,z = getElementPosition(getPedOccupiedVehicle(plr))
                setElementPosition(getPedOccupiedVehicle(plr),x,y,z+1.5)
                exports["lss-admin"]:rconView_add("[FLIP] "..getPlayerName(plr).." obrócił swój pojazd.")
            end
        end
    end
end)



addCommandHandler("raporty",function(plr,cmd)
    if plr and isElement(plr) and getElementData(plr,"admin:rank") then
        local cid = getElementData(plr,"CID")
        local wynik = exports.DB:pobierzTabeleWynikow("SELECT  all_deleted, count FROM cs_reports WHERE (cid=?)",cid)
            for i,v in ipairs(wynik) do
                outputChatBox("Ilość raportów w sumie: "..v['all_deleted'],plr)
                outputChatBox("Ilość raportów w tym tygodniu: "..v['count'],plr)
            end
        end
end)

addCommandHandler("lp",function(plr,cmd)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if not getElementData(plr,"admin:rank") then return end
        if not config[plr] then outputChatBox("#FF0000★ #FFFFFFNie posiadasz zapisanej pozycji! Zapisz ją za pomocą komendy /sp!",plr,0,0,0,true) return end
        if not config[plr].pos then outputChatBox("#FF0000★ #FFFFFFNie posiadasz zapisanej pozycji! Zapisz ją za pomocą komendy /sp!",plr,0,0,0,true) return end
        setElementPosition(plr,config[plr].pos[1],config[plr].pos[2],config[plr].pos[3])
        outputChatBox("#FFFF00★ #FFFFFFWczytano zapisaną pozycję.",plr,0,0,0,true)
    end
end)

addCommandHandler("sc",function(plr,cmd,r,g,b,r2,g2,b2)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"CID") then
            local ranga = getElementData(plr,"admin:rank")
            if ranga then
                if ranga == "Globalmoderator" or ranga == "Administrator" or ranga == "Globaladministrator" or ranga == "RCON" then
                    if getPedOccupiedVehicle(plr) and isPedInVehicle(plr) then
                        if r and g and b then
                            setVehicleColor(getPedOccupiedVehicle(plr),r,g,b)
                            exports["lss-admin"]:rconView_add("[SC: RGB] "..getPlayerName(plr)..", "..r..","..g..","..b..".")
                            outputChatBox("* Ustawiono kolor RGB dla tego pojazdu!",plr,0,255,0,true)
                        end
                        if r and g and b and r2 and g2 and b2 then
                            setVehicleColor(getPedOccupiedVehicle(plr),r,g,b,r2,g2,b2)
                            exports["lss-admin"]:rconView_add("[SC: RGB-R2G2B2] "..getPlayerName(plr)..", "..r..","..g..","..b..","..r2..","..g2..","..b2.." >> "..getVehiclePlateText(getPedOccupiedVehicle(plr)))
                            outputChatBox("* Ustawiono kolor RGB i R2G2B2 dla tego pojazdu!",plr,0,255,0,true)
                        end
                    end
                end
            end
        end
    end
end)

function vehicle_takeOutFromGarage(player, command, vehID)
    if(player) and (isElement(player))then
        if(getElementData(player, "CID")) and (vehID) and (tonumber(vehID))then
            local ranga = getElementData(player,"admin:rank")
            if ranga then
                if ranga == "Moderator" or ranga == "Globalmoderator" or ranga == "Administrator" or ranga == "Globaladministrator" or ranga == "RCON" then
                    local findVeh = exports["CS-vehicles"]:findVehicleByID(tonumber(vehID))
                    if(findVeh) and (isElement(findVeh))then
                        return outputChatBox(" Pojazd ten jest już na mapie! ", player, 255, 255, 255, false);
                    end
                    exports.DB:zapytanie("UPDATE cl_vehicles SET storage=0 WHERE id=? LIMIT 1", tonumber(vehID))
                    exports["CS-vehicles"]:createVehicles(tonumber(vehID))
                    local pozycja = {getElementPosition(player)};
                    local v = exports["CS-vehicles"]:findVehicleByID(tonumber(vehID))
                    if v and isElement(v) then
                        setElementPosition(v,pozycja[1],pozycja[2],pozycja[3])
                        setElementRotation(v,0,0,0)
                        setElementFrozen(v,false)
                        if getElementModel(v)==522 then
                            setVehicleVariant(v,2,3)
                        end
                        if getElementData(v,"vehicle:opis") then
                            if string.find(getElementData(v,"vehicle:opis"),"Pojazd marki") then
                                removeElementData(v,"vehicle:opis")
                            end
                        end
                        if isElementFrozen(v) then
                            setElementFrozen(v,false)
                            removeElementData(v,"veh:reczny")
                        end
                        exports["lss-admin"]:rconView_add("[ADMIN - WZP] Player "..getPlayerName(player).." taked out vehicle ID: "..tonumber(vehID).." from garage.");
                        triggerClientEvent(player,"CS:powiadomienie",player,player,{"allow","Pojazd o id "..tonumber(vehID).." został\nwyciągnięty z przechowalni!"})
                    end
                end
            end
        end
    end
end; addCommandHandler("wzp", vehicle_takeOutFromGarage)

function deleteVehicleFromSalon(player, command, ...)
    if player and isElement(player) and getElementType(player) == "player" then
        if getElementData(player,"CID") then
            local ranga = getElementData(player,"admin:rank")
            if ranga or ranga == "Globaladministrator" or ranga == "RCON" then
                if(isPedInVehicle(player))then
                    if(getElementData(getPedOccupiedVehicle(player), "vehicle:salon"))then
                        if(exports["DB"]:prepareSet("DELETE FROM `vehicleAutoDealerCars` WHERE `vehicleModel` = ?", getElementModel(getPedOccupiedVehicle(player))))then
                            exports["lss-admin"]:rconView_add("[SALON VEHICLE DELETE] Player "..getPlayerName(player).." deleted manual salon vehicle ("..getElementModel(getPedOccupiedVehicle(player))..")");
                            outputChatBox("Vehicle deleted", player, 230, 230, 230);
                            destroyElement(getPedOccupiedVehicle(player));
                        end
                    else
                        outputChatBox("Vehicle is not from salon resource", player, 230, 230, 230);
                    end
                end
            end
        end
    end
    return false;
end; addCommandHandler("salonVehicle.delete", deleteVehicleFromSalon)


function houseTpInterior(plr, cmd, int)
    if getElementData(plr, "admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
        if not int or not tonumber(int) then return end
        local posIn = exports["DB"]:pobierzTabeleWynikow("SELECT `in_xyz` FROM `cs_posiadlosci` WHERE `interior` = ? LIMIT 1",int)
        if not posIn or #posIn ~= 1 then outputChatBox("Nie istnieje taki interior", plr, 255,0,0) return end
        setElementInterior(plr, int)
        local pos = split(posIn[1].in_xyz, ",")
        setElementPosition(plr, pos[1], pos[2], pos[3])
    end
end
addCommandHandler("tp.int", houseTpInterior)


function createHouse(player, command, ...)
    if player and isElement(player) and getElementType(player) == "player" then
        if getElementData(player,"CID") then
            local ranga = getElementData(player,"admin:rank")
            if ranga or ranga == "Globaladministrator" or ranga == "RCON" then
                local helpText = ">> Incorrect format for /"..command.." | Expected /"..command.." \"houseCostPerDay\";\"houseInterior\";\"enterPos\"";
                text = table.concat({...}," ")
                if(not text) or (string.len(text)) < (1)then
                    outputChatBox(helpText, player, 230, 230, 230);
                    return false;
                end
                local indicators = {
                    value = 0,
                    list  = {

                    };
                };
                for i = 1, string.len(text) do
                    if(indicators.value) == (0)then
                        local findA, findB = string.find(text, ";");
                        if(findA) and (findB)then
                            table.insert(indicators.list, {findA, findB}); indicators.value = indicators.value + 1;
                        else
                            outputChatBox(helpText, player, 230, 230, 230);
                            return;
                        end
                    elseif(indicators.value) > (0)then
                        local findA, findB = string.find(text, ";", indicators.list[#indicators.list][2]+1);
                        if(findA) and (findB)then
                            table.insert(indicators.list, {findA, findB}); indicators.value = indicators.value + 1;
                        else
                            break;
                        end
                    end
                end
                if(indicators.value) < (2)then
                    outputChatBox(helpText, player, 230, 230, 230);
                    return false;
                end
                local houseCost = string.sub(text, 1, indicators.list[1][2]-1);
                local interior = string.sub(text, indicators.list[1][2]+1, indicators.list[2][2]-1);
                local houseXyz = string.sub(text, indicators.list[2][2]+1, #indicators.list > 2 and indicators.list[3][2]-1 or string.len(text)):gsub(", ", ","); houseXyz = split(houseXyz, ",");
                local pos = {getElementPosition(player)}; pos[1], pos[2], pos[3] = string.format("%.2f", pos[1]), string.format("%.2f", pos[2]), string.format("%.2f", pos[3]);
                pos[4], pos[5], pos[6] = houseXyz[1], houseXyz[2], houseXyz[3]; houseXyz = table.concat(pos, ",");
                local posIn = exports["DB"]:prepareSet("SELECT `in_xyz` FROM `cs_posiadlosci` WHERE `interior` = ? LIMIT 1",interior)
                if(posIn) and (#posIn) > (0) and (posIn[1])then
                    local validDim = exports["DB"]:prepareSet("SELECT `dbid` FROM `cs_posiadlosci` ORDER BY `dbid` DESC LIMIT 1")
                    if(validDim) and (validDim[1])then
                        if(exports["DB"]:prepareSet("INSERT INTO `cs_posiadlosci` (cost, xyz, dim, in_xyz, interior, type) VALUES (?, ?, ?, ?, ?, 'dom')", houseCost, houseXyz, validDim[1].dbid+1, posIn[1].in_xyz, interior))then
                            outputChatBox("House added", player, 230, 230, 230);
                            executeCommandHandler("reloadhouse", player, validDim[1].dbid+1);
                            exports["lss-admin"]:rconView_add("[CREATE HOUSE] Player "..getPlayerName(player).." created house "..(validDim[1].dbid+1).." (cost "..houseCost..")");
                        end
                    else
                        outputChatBox("No valid dimension found", player, 230, 230, 230);
                    end
                else
                    outputChatBox("House with interior "..interior.." not found", player, 230, 230, 230);
                end
            end
        end
    end
    return false;
end; addCommandHandler("createHouse", createHouse)

function houseEditor(player, command, arg1, arg2)
    if player and isElement(player) and getElementType(player) == "player" then
        if getElementData(player,"CID") then
            local ranga = getElementData(player,"admin:rank")
            if ranga or ranga == "Globaladministrator" or ranga == "RCON" then
                if(command) and (command) == ("setHouseCost")then
                    if(arg1) and (tonumber(arg1)) and (arg2) and (tonumber(arg2))then
                        arg1 = tonumber(arg1);  arg2 = tonumber(arg2);
                        if(arg1) < (1) or (arg2) < (1) or (arg2) > (5000)then
                            outputChatBox("Incorrect format. Use /"..command.." [houseId] [houseCostPerDay]", player, 230, 230, 230);
                            return;
                        end
                        if(exports["DB"]:prepareSet("UPDATE `cs_posiadlosci` SET `cost` = ? WHERE `dbid` = ?", tonumber(arg2), tonumber(arg1)))then
                            outputChatBox("Changed cost of house "..arg1.." to "..arg2, player, 230, 230, 230);
                            executeCommandHandler("reloadhouse", player, arg1);
                            exports["lss-admin"]:rconView_add("[HOUSE EDITOR] Player "..getPlayerName(player).." changed cost for house "..tonumber(arg1).." to "..tonumber(arg2).." PLN");
                        end
                    else
                        outputChatBox("Incorrect format. Use /"..command.." [houseId] [houseCostPerDay]", player, 230, 230, 230);
                    end
                elseif(command) and (command) == ("setHouseOwner")then
                    if(arg1) and (tonumber(arg1)) and (arg2) and (tostring(arg2))then
                        arg1 = tonumber(arg1);
                        if(arg1) < (1)then
                            outputChatBox("Incorrect format. Use /"..command.." [houseId] [houseOwnerLogin]", player, 230, 230, 230);
                            return;
                        end
                        if(exports["DB"]:prepareSet("UPDATE `cs_posiadlosci` SET `owner` = ? WHERE `dbid` = ?", arg2, tonumber(arg1)))then
                            outputChatBox("Changed houseOwner of house "..arg1.." to "..arg2, player, 230, 230, 230);
                            executeCommandHandler("reloadhouse", player, arg1);
                            exports["lss-admin"]:rconView_add("[HOUSE EDITOR] Player "..getPlayerName(player).." changed houseOwner for house "..tonumber(arg1).." to "..arg2.."");
                        end
                    else
                        outputChatBox("Incorrect format. Use /"..command.." [houseId] [houseOwnerLogin]", player, 230, 230, 230);
                    end
                elseif(command) and (command) == ("setHouseTime")then
                    if(arg1) and (tonumber(arg1)) and (arg2) and (tonumber(arg2))then
                        arg1 = tonumber(arg1);  arg2 = tonumber(arg2);
                        if(arg1) < (1) or (arg2) < (1) or (arg2) > (50000)then
                            outputChatBox("Incorrect format. Use /"..command.." [houseId] [houseTimeInHour]", player, 230, 230, 230);
                            return;
                        end
                        if(exports["DB"]:prepareSet("UPDATE `cs_posiadlosci` SET `time` = ? WHERE `dbid` = ?", tonumber(arg2), tonumber(arg1)))then
                            outputChatBox("Changed houseTime of house "..arg1.." to "..arg2, player, 230, 230, 230);
                            executeCommandHandler("reloadhouse", player, arg1);
                            exports["lss-admin"]:rconView_add("[HOUSE EDITOR] Player "..getPlayerName(player).." changed houseTime for house "..tonumber(arg1).." to "..tonumber(arg2).." hours");
                        end
                    else
                        outputChatBox("Incorrect format. Use /"..command.." [houseId] [houseTimeInHour]", player, 230, 230, 230);
                    end
                elseif(command) and (command) == ("setHousePosition")then
                    if(arg1) and (tonumber(arg1)) and (arg2) and (tostring(arg2))then
                        arg1 = tonumber(arg1);
                        if(arg1) < (1)then
                            outputChatBox("Incorrect format. Use /"..command.." [houseId] [houseExitPos]", player, 230, 230, 230);
                            return;
                        end
                        local pos = {getElementPosition(player)}; pos[1], pos[2], pos[3] = string.format("%.2f", pos[1]), string.format("%.2f", pos[2]), string.format("%.2f", pos[3]);
                        local unPackString = split(arg2:gsub(", ", ","), ","); pos[4], pos[5], pos[6] = unPackString[1], unPackString[2], unPackString[3]; arg2 = table.concat(pos, ",");
                        if(exports["DB"]:prepareSet("UPDATE `cs_posiadlosci` SET `xyz` = ? WHERE `dbid` = ?", arg2, tonumber(arg1)))then
                            outputChatBox("Changed housePosition of house "..arg1.." to "..arg2, player, 230, 230, 230);
                            executeCommandHandler("reloadhouse", player, arg1);
                            exports["lss-admin"]:rconView_add("[HOUSE EDITOR] Player "..getPlayerName(player).." changed housePosition for house "..tonumber(arg1).." to "..arg2.."");
                        end
                    else
                        outputChatBox("Incorrect format. Use /"..command.." [houseId] [houseExitPos]", player, 230, 230, 230);
                    end
                elseif(command) and (command) == ("deleteHouse")then
                    if(arg1) and (tonumber(arg1))then
                        arg1 = tonumber(arg1);
                        if(arg1) < (1)then
                            outputChatBox("Incorrect format. Use /"..command.." [houseId]", player, 230, 230, 230);
                            return;
                        end
                        if(exports["DB"]:prepareSet("DELETE FROM `cs_posiadlosci` WHERE `dbid` = ?", tonumber(arg1)))then
                            outputChatBox("House "..arg1.." removed", player, 230, 230, 230);
                            executeCommandHandler("reloadhouse", player, arg1);
                            exports["lss-admin"]:rconView_add("[HOUSE EDITOR] Player "..getPlayerName(player).." removed house "..tonumber(arg1));
                        end
                    else
                        outputChatBox("Incorrect format. Use /"..command.." [houseId]", player, 230, 230, 230);
                    end
                end
            end
        end
    end
    return false;
end; addCommandHandler("setHouseCost", houseEditor); addCommandHandler("setHouseOwner", houseEditor); addCommandHandler("setHouseTime", houseEditor); addCommandHandler("setHousePosition", houseEditor); addCommandHandler("deleteHouse", houseEditor);

function createUpdate(player, command, ...)
    if player and isElement(player) and getElementType(player) == "player" then
        if getElementData(player,"CID") then
            local ranga = getElementData(player,"admin:rank")
            if ranga or ranga == "Globaladministrator" or ranga == "RCON" then
                local helpText = ">> Incorrect format for /"..command.." | Expected /"..command.." \"updateHeader\";\"updateDescription\"[;\"forum link\" (Opcjonalnie)]";
                text = table.concat({...}," ")
                if(not text) or (string.len(text)) < (1)then
                    outputChatBox(helpText, player, 230, 230, 230);
                    return false;
                end
                local indicators = {
                    value = 0,
                    list  = {

                    };
                };
                for i = 1, string.len(text) do
                    if(indicators.value) == (0)then
                        local findA, findB = string.find(text, ";");
                        if(findA) and (findB)then
                            table.insert(indicators.list, {findA, findB}); indicators.value = indicators.value + 1;
                        else
                            outputChatBox(helpText, player, 230, 230, 230);
                            return;
                        end
                    elseif(indicators.value) > (0)then
                        local findA, findB = string.find(text, ";", indicators.list[#indicators.list][2]+1);
                        if(findA) and (findB)then
                            table.insert(indicators.list, {findA, findB}); indicators.value = indicators.value + 1;
                        else
                            break;
                        end
                    end
                end
                if(indicators.value) < (1)then
                    outputChatBox(helpText, player, 230, 230, 230);
                    return false;
                end
                if(indicators.value) == (2)then
                    if(string.len(text)-indicators.list[#indicators.list][2]) < (1)then
                        outputChatBox(">> Forum link cannot be NULL", player, 230, 230, 230);
                        return false;
                    end
                else
                    if(string.len(text)-indicators.list[#indicators.list][2]) < (1)then
                        outputChatBox(">> Update description cannot be NULL", player, 230, 230, 230);
                        return false;
                    end
                end
                outputChatBox(">> Detected "..indicators.value.." (;)characters, posting new update (Uses forum link: "..(indicators.value == 2 and "YES" or "NO")..")", player, 230, 230, 230);

                local header = string.sub(text, 1, indicators.list[1][2]-1);
                local description = string.sub(text, indicators.list[1][2]+1, #indicators.list > 1 and indicators.list[2][2]-1 or string.len(text));
                local forumLink = #indicators.list > 1 and string.sub(text, indicators.list[2][2]+1, string.len(text)) or "";

                local postData = {
                    content = "<@&829087080877260801>",
                    embeds = {
                        {
                        title = header,
                        description = description,
                        color = 1473930,
                        footer = {
                            text = "CalmStory MTA:SA | inowerdevelopment@gmail.com",
                        },

                        author = {
                            name = "Nowe ogłoszenie od zarządu CalmStory",
                            icon_url = "https://www.calmstory.pl/uploads/monthly_2021_04/VS5ZuGw.png.6c5ef403a832d14b7cc71b86e8baf038.png"
                        },
                    },
                    },
                }

                postData = toJSON(postData)
                postData = postData:sub(2, postData:len() - 1)

                local sendOptions = {
                    headers = {
                        ["Content-Type"] = "application/json"
                    },
                    postData = postData
                }
                 fetchRemote("https://discord.com/api/webhooks/828684347519270924/HZht2MOR-ggapIEY4UlQfRjPWG47hUEh722wHAF_Vn9Kj74lo586lWyC_PIlQDbr-n8n", sendOptions, callBack)


                exports["DB"]:prepareSet("INSERT INTO `a_updatesDB` (header, updateText, updateLink) VALUES (?, ?, ?)", header, description, forumLink);
                outputChatBox("#bbbbbd[ #2366ad☱ #bbbbbd] #4076e3"..header:upper().."#ffffff >> #6e99ff"..description,root,255,255,255,true)
                executeCommandHandler("reloadupdates", player)
            end
        end
    end
end; addCommandHandler("createUpdate", createUpdate)

function createDiscordAnnouncement(callPlayer, callCommand, ...)
    if callPlayer and isElement(callPlayer) and getElementType(callPlayer) == "player" then
        if getElementData(callPlayer,"CID") then
            local ranga = getElementData(callPlayer,"admin:rank")
            if ranga or ranga == "Globaladministrator" or ranga == "RCON" then
                local callDescription = table.concat({...}," ");
                if(callDescription) and (tostring(callDescription)) and (callDescription) ~= ("")then
                    local postData = {
                        content = "<@&829087080877260801>",
                        embeds = {
                            {
                            title = header,
                            description = callDescription,
                            color = 1473930,
                            footer = {
                                text = "CalmStory MTA:SA | inowerdevelopment@gmail.com",
                            },

                            author = {
                                name = "Ogłoszenie wydane przez "..getPlayerName(callPlayer),
                                icon_url = "https://www.calmstory.pl/uploads/monthly_2021_04/VS5ZuGw.png.6c5ef403a832d14b7cc71b86e8baf038.png"
                            },
                        },
                        },
                    }

                    postData = toJSON(postData)
                    postData = postData:sub(2, postData:len() - 1)

                    local sendOptions = {
                        headers = {
                            ["Content-Type"] = "application/json"
                        },
                        postData = postData
                    }
                    fetchRemote("https://discord.com/api/webhooks/845041430955294761/U4QoEnhv62cv3NxxuRoEDeIRyCRP7CAp2kvXnp7WcCHzlqqqxA-4RoWTa2vXlVSZw-3k", sendOptions, callBack)
                    outputChatBox("Created discord announcement",callPlayer,255,255,255,true)
                end
            end
        end
    end
    return false;
end; addCommandHandler("cda", createDiscordAnnouncement);

function callBack()
    return true;
end

addCommandHandler("set.skin", function(plr,cmd,target,id)
    if plr and isElement(plr) then
        if target and id and tonumber(id) then
            if getElementData(plr, "admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
                local target = findPlayer(plr, target)
                if target then
                    setElementModel(target, tonumber(id))
                    exports['lss-admin']:rconView_add("[SET-SKIN] "..getPlayerName(plr).." >> "..getPlayerName(target).." id: "..id)
                end
            end
        end
    end
end)



addCommandHandler("tt",function(plr,cmd,text)
    if timer5[plr] and isTimer(timer5[plr]) then return end
    timer5[plr] = setTimer(function() end,250,1)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"CID") then
            if getElementData(plr,"admin:rank") then
                if text and tostring(text) then
                    local cel = findPlayer(plr,text)
                    if cel and isElement(cel) then
                        if getElementData(cel,"admin:rank") == "RCON" then
                            if getElementData(plr,"admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
                            else
                                outputChatBox("Nie możesz teleportować się do Administratorów RCON!",plr,255,0,0)
                                return
                            end
                        end

                        if getElementData(cel,"admin:rank") == "Globaladministrator" then
                            if getElementData(plr,"admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
                            else
                                outputChatBox("Nie możesz teleportować się do Globaladministratorów!",plr,255,0,0)
                                return
                            end
                        end
                        if getElementData(plr,"frakcja:S1") == true then
                            triggerEvent("s2",plr, plr)
                        end
                        if(triggerClientEvent(plr, "onMultitaskCustomDetach", plr, plr))then
                            local x,y,z = getElementPosition(cel)
                            local dim,int = getElementDimension(cel),getElementInterior(cel)
                            local vehcel = getPedOccupiedVehicle(cel)
                            if not vehcel  then
                                setElementPosition(plr,x+2,y,z)
                                setElementDimension(plr,dim)
                                setElementInterior(plr,int)
                            else
                                local iloscmiejsc = 0
                                for _,_ in pairs(getVehicleOccupants(vehcel)) do
                                    iloscmiejsc = iloscmiejsc + 1
                                end
                                local iloscautko = getVehicleMaxPassengers(vehcel) + 1
                                if iloscmiejsc >= iloscautko then
                                    setElementPosition(plr,x+2,y,z)
                                    setElementDimension(plr,dim)
                                    setElementInterior(plr,int)
                                else
                                    local dim,int = getElementDimension(vehcel),getElementInterior(vehcel)
                                    for i=0,getVehicleMaxPassengers(vehcel) do
                                        if i~=0 then
                                            if not getVehicleOccupant(vehcel,i) then
                                                warpPedIntoVehicle(plr,vehcel,i)
                                                setElementDimension(plr,dim)
                                                setElementInterior(plr,int)
                                                return
                                            end
                                        end
                                    end
                                end
                            end
                            if getElementData(plr, "strzelnica:dm") then
                                removeElementData(plr, "strzelnica:dm");
                            end
                                outputChatBox("* Przeniosłeś się do gracza "..getPlayerName(cel)..".",plr)
                            exports["lss-admin"]:rconView_add("[TT] "..getPlayerName(plr).." DO "..getPlayerName(cel)..".")
                        end
                    else
                        outputChatBox("Nie znaleziono podanego gracza!",plr,255,0,0)
                    end
                end
            end
        end
    end
end)



addCommandHandler("th",function(plr,cmd,text)
    if timer5[plr] and isTimer(timer5[plr]) then return end
    timer5[plr] = setTimer(function() end,250,1)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"CID") then
            if getElementData(plr,"admin:rank") then
                if text and tostring(text) then
                    local cel = findPlayer(plr,text)
                    if cel then
                        if getElementData(cel,"admin:rank") == "RCON" then
                            if getElementData(plr,"admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator"  then
                            else
                                outputChatBox("Nie możesz teleportować do siebie Administratorów RCON!",plr,255,0,0)
                                return
                            end
                        end
                        if isPedInVehicle(cel) then
                            removePedFromVehicle(cel)
                        end
                        if getElementDimension(cel) == 50 and getElementInterior(cel) == 4 then
                            outputChatBox("Gracz znajduje się na strzelnicy!",plr,255,0,0,true)
                            return
                        end
                        if(triggerClientEvent(cel, "onMultitaskCustomDetach", cel, cel))then
                            local x,y,z = getElementPosition(plr)
                            local dim,int = getElementDimension(plr),getElementInterior(plr)
                            setElementPosition(cel,x+1,y,z)
                            setElementDimension(cel,dim)
                            setElementInterior(cel,int)
                            if getElementData(cel, "strzelnica:dm") then
                                removeElementData(cel, "strzelnica:dm");
                            end
                            outputChatBox("* Przeniosłeś gracza "..getPlayerName(cel).." do siebie.",plr)
                            outputChatBox("* Zostałeś/aś przeniesiony/a przez "..getPlayerName(plr)..".",cel)
                            exports["lss-admin"]:rconView_add("[TH] "..getPlayerName(cel).." DO "..getPlayerName(plr)..".")
                        end
                    else
                        outputChatBox("Nie znaleziono podanego gracza!",plr,255,0,0)
                    end
                end
            end
        end
    end
end)

addCommandHandler("global",function(plr,cmd,...)
    if timer5[plr] and isTimer(timer5[plr]) then return end
    timer5[plr] = setTimer(function() end,250,1)
    if ... then
        local text = table.concat({...}," ")
        if text and tostring(text) and tostring(text) ~= "" and tostring(text) ~= " " then
            if getElementData(plr,"admin:rank") == "RCON" then
                outputChatBox("#A52A2A>> "..string.gsub(text,"#%x%x%x%x%x%x",""),root,255,255,255,true)
                exports["lss-admin"]:rconView_add("[G] "..getPlayerName(plr).." >> "..tostring(text)..".")
            elseif getElementData(plr, "admin:rank") == "Globaladministrator" then
                outputChatBox("#3498db>> "..string.gsub(text,"#%x%x%x%x%x%x",""),root,255,255,255,true)
                exports["lss-admin"]:rconView_add("[G] "..getPlayerName(plr).." >> "..tostring(text)..".")
            elseif getElementData(plr,"admin:rank") == "Administrator" then
                outputChatBox(">> "..string.gsub(text,"#%x%x%x%x%x%x",""),root,232,42,31,true)
                exports["lss-admin"]:rconView_add("[G] "..getPlayerName(plr).." >> "..tostring(text)..".")
            elseif getElementData(plr,"admin:rank") == "Globalmoderator" then
                outputChatBox(">> "..string.gsub(text,"#%x%x%x%x%x%x",""),root,0,142,2,true)
                exports["lss-admin"]:rconView_add("[G] "..getPlayerName(plr).." >> "..tostring(text)..".")
            elseif getElementData(plr,"admin:rank") == "Moderator" then
                outputChatBox(">> "..string.gsub(text,"#%x%x%x%x%x%x",""),root,76,234,94,true)
                exports["lss-admin"]:rconView_add("[G] "..getPlayerName(plr).." >> "..tostring(text)..".")
            end
        end
    end
end)

--RCON 162,155,254 Admin: 232,42,31 Globalmoderator (0,142,2) modzi 76,234,94

addCommandHandler("inv",function(plr,cmd)
    if timer5[plr] and isTimer(timer5[plr]) then return end
    timer5[plr] = setTimer(function() end,500,1)
    if getElementData(plr,"admin:rank") then
        if getElementAlpha(plr) > 0 then
            setElementAlpha(plr,0)
            exports["lss-admin"]:rconView_add("[INV ON] "..getPlayerName(plr)..".")
            exports.playerblips:setBlip(plr,"destroy")
        else
            setElementAlpha(plr,255)
            exports["lss-admin"]:rconView_add("[INV OFF] "..getPlayerName(plr)..".")
            exports.playerblips:setBlip(plr,"create")
        end
    end
end)


timer={}
addCommandHandler("spec",function(plr,cmd,cel)
    if timer5[plr] and isTimer(timer5[plr]) then return end
    timer5[plr] = setTimer(function() end,500,1)
    if getElementData(plr,"admin:rank") then
        if cel then
            local target=findPlayer(plr,cel)
            if target then
                if getElementData(target,"admin:rank") == "RCON" then
                    if getElementData(plr,"admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator"  then
                    else
                        outputChatBox("Nie możesz specować Administratorów RCON!",plr,255,0,0)
                        return
                    end
                end
                if getElementData(plr,"frakcja:S1") == true then
                    triggerEvent("s2",plr, plr)
                end
                local x,y,z = getElementPosition(target)
                setCameraTarget(plr)
                removePedFromVehicle(plr)
                setElementFrozen(plr,true)
                setElementPosition(plr,x+5,y+5,z-50)

                setElementInterior(plr,getElementInterior(target))
                setCameraInterior(plr,getElementInterior(target))
                setElementDimension(plr,getElementDimension(target))
                if timer[plr] and isTimer(timer[plr]) then
                    killTimer(timer[plr])
                end
                timer[plr] = setTimer(function(plr,target)
                    setElementPosition(plr,-5735.76,-819.83,474.36+7500)
                    if getCameraTarget(plr) ~= target then
                        setCameraTarget(plr,target)
                    end
                end,2000,1,plr,target)
                setCameraTarget(plr,target)
                setCameraTarget(plr,target)
                exports.playerblips:setBlip(plr,"destroy")
                exports["lss-admin"]:rconView_add("[SPEC] "..getPlayerName(target).." PRZEZ "..getPlayerName(plr)..".")
            else
                outputChatBox("Nie znaleziono gracza o podanym ID/nicku!",plr,255,0,0)
            end
        end
    end
end)

addCommandHandler("specoff",function(plr,cmd)
    if timer5[plr] and isTimer(timer5[plr]) then return end
    timer5[plr] = setTimer(function() end,500,1)
    if getElementData(plr,"admin:rank") then
        setElementPosition(plr,-6416.386, -166.766, 9.909)
        setElementInterior(plr,0)
        setElementDimension(plr,0)
        setElementFrozen(plr,false)
        setCameraTarget(plr,plr)
        exports.playerblips:setBlip(plr,"setcolor",{255, 255, 255})
        exports["lss-admin"]:rconView_add("[SPECOFF] "..getPlayerName(plr)..".")
        if timer[plr] and isTimer(timer[plr]) then
            killTimer(timer[plr])
        end
    end
end)


maxstring = 260
function outputChatBoxSplitted(text,target,c1,c2,c3,ca)
    if string.len(text) < maxstring then outputChatBox(text,target,c1,c2,c3,ca) return end
    local t=""
    for i,v in string.gmatch(text,"(.)") do
        if string.len(t)>0 and string.len(t)+string.len(i)>=maxstring then
            outputChatBox(t,target,c1,c2,c3,ca) t=" "
        end t=t..i
    end
    if string.len(t)>0 and t~=" " then outputChatBox(t,target,c1,c2,c3,ca) end
end


addCommandHandler("admins",function(plr,cmd)
    if timer5[plr] and isTimer(timer5[plr]) then return end
    timer5[plr] = setTimer(function() timer5[plr]=nil end,500,1)
    local moderatorzy = {}
    local globalmoderatorzy = {}
    local administratorzy = {}
    local globaladministratorzy = {}
    local rconi = {}
    local dutyon = {}
    for _,v in ipairs(getElementsByType("player")) do
        if getElementData(v,"admin:rank") then
            if getElementData(v,"admin:rank") == "Moderator" then
                table.insert(moderatorzy,tostring(getPlayerName(v)).." ("..getElementData(v,"id")..")")
            elseif getElementData(v,"admin:rank") == "Globalmoderator" then
                table.insert(globalmoderatorzy,tostring(getPlayerName(v)).." ("..getElementData(v,"id")..")")
            elseif getElementData(v,"admin:rank") == "Administrator" then
                table.insert(administratorzy,tostring(getPlayerName(v)).." ("..getElementData(v,"id")..")")
            elseif getElementData(v, "admin:rank") == "Globaladministrator" then
                if not getElementData(v, "admin:showrcon") then
                    table.insert(globaladministratorzy,tostring(getPlayerName(v)).." ("..getElementData(v,"id")..")")
                else
                    if(getElementData(plr, "admin:rank") == "RCON")then
                        table.insert(globaladministratorzy,"(#ede326INV#ffffff) #ede326"..tostring(getPlayerName(v)).."#ffffff ("..getElementData(v,"id")..")")
                    end
                end
            elseif getElementData(v, "admin:rank") == "RCON" then
                local addText = "";
                if(getPlayerName(v)) == ("CoRFX")then addText = "(#5e0202★#ffffff ) " end
                if not getElementData(v, "admin:showrcon") then
                    table.insert(rconi,addText..tostring(getPlayerName(v)).." ("..getElementData(v,"id")..")")
                elseif(getElementData(plr, "admin:rank") == "RCON")then
                    table.insert(rconi,"(#ede326INV#ffffff) "..addText.."#ede326"..tostring(getPlayerName(v)).."#ffffff ("..getElementData(v,"id")..")")
                end
            end
        end
        if getElementData(v,"admin:rank:duty") then
            table.insert(dutyon,tostring(getPlayerName(v)).." ("..getElementData(v,"id")..")")
        end
    end
    rconi=table.concat(rconi,", ")
    globalmoderatorzy=table.concat(globalmoderatorzy,", ")
    administratorzy=table.concat(administratorzy,", ")
    globaladministratorzy=table.concat(globaladministratorzy, ", ")
    moderatorzy=table.concat(moderatorzy,", ")
    dutyon=table.concat(dutyon,", ")
    if #rconi == 0 then rconi="brak" end
    if #globalmoderatorzy == 0 then globalmoderatorzy="brak" end
    if #administratorzy == 0 then administratorzy="brak" end
    if #globaladministratorzy == 0 then globaladministratorzy="brak" end
    if #moderatorzy == 0 then moderatorzy="brak" end
    outputChatBox(" ",plr)
    outputChatBox("#800000Administratorzy RCON: #ffffff"..rconi,plr,0,0,0,true)
    outputChatBox("#3498dbGlobal Administratorzy: #ffffff"..globaladministratorzy,plr,0,0,0,true)
    outputChatBox("#e82a1fAdministratorzy: #ffffff"..administratorzy,plr,0,0,0,true)
    outputChatBox("#008e02Global Moderatorzy: #ffffff"..globalmoderatorzy,plr,0,0,0,true)
    outputChatBox("#4cea5eModeratorzy: #ffffff"..moderatorzy,plr,0,0,0,true)
    if #dutyon>0 then
        outputChatBox("#C0C0C0Poza duty: #ffffff"..dutyon,plr,0,0,0,true)
    end
    outputChatBox("  ",plr)
end)

function showRank(thePlayer, command)
    if(command) == ("showrcon")then
        if getElementData(thePlayer, "admin:rank") == "RCON" then
            if getElementData(thePlayer, "admin:showrcon") then
                removeElementData(thePlayer, "admin:showrcon")
            else
                setElementData(thePlayer, "admin:showrcon", true)
            end
        end
    elseif(command) == ("showga")then
        if getElementData(thePlayer, "admin:rank") == "Globaladministrator" then
            if getElementData(thePlayer, "admin:showrcon") then
                removeElementData(thePlayer, "admin:showrcon")
            else
                setElementData(thePlayer, "admin:showrcon", true)
            end
        end
    end
end; addCommandHandler("showrcon", showRank); addCommandHandler("showga", showRank)

addCommandHandler("flip",function(plr,cmd,text)
    if timer5[plr] and isTimer(timer5[plr]) then return end
    timer5[plr] = setTimer(function() end,250,1)
    if getElementData(plr,"admin:rank") then
        if text and tostring(text) then
            local cel = findPlayer(plr,text)
            if cel then
                local rx,ry,rz = getElementRotation(cel)
                if isPedInVehicle(cel) then
                    setElementRotation(getPedOccupiedVehicle(cel),rx,ry,rz+180)
                    local x,y,z = getElementPosition(getPedOccupiedVehicle(cel))
                    setElementPosition(getPedOccupiedVehicle(cel),x,y,z+1.5)
                    exports["lss-admin"]:rconView_add("[FLIP] "..getPlayerName(plr).." >> "..getPlayerName(cel)..".")
                end
            end
        else
            local rx,ry,rz = getElementRotation(plr)
            if isPedInVehicle(plr) then
                setElementRotation(getPedOccupiedVehicle(plr),rx,ry,rz+180)
                local x,y,z = getElementPosition(getPedOccupiedVehicle(plr))
                setElementPosition(getPedOccupiedVehicle(plr),x,y,z+1.5)
                exports["lss-admin"]:rconView_add("[FLIP] "..getPlayerName(plr).." obrócił swój pojazd.")
            end
        end
    end
end)

addCommandHandler("dim",function(plr,cmd,dim)
    if timer5[plr] and isTimer(timer5[plr]) then return end
    timer5[plr] = setTimer(function() end,500,1)
    if plr and getElementData(plr,"admin:rank") then
        if dim and tonumber(dim) then
            if not isPedInVehicle(plr) then
                setElementDimension(plr,tonumber(dim))
                exports["lss-admin"]:rconView_add("[DIM] "..getPlayerName(plr).." >> "..tonumber(dim)..".")
            end
        end
    end
end)


addCommandHandler("int",function(plr,cmd,dim)
    if timer5[plr] and isTimer(timer5[plr]) then return end
    timer5[plr] = setTimer(function() end,500,1)
    if plr and getElementData(plr,"admin:rank") then
        if dim and tonumber(dim) then
            if not isPedInVehicle(plr) then
                setElementInterior(plr,tonumber(dim))
                exports["lss-admin"]:rconView_add("[INT] "..getPlayerName(plr).." >> "..tonumber(dim)..".")
            end
        end
    end
end)


addCommandHandler("fix",function(plr,cmd,text)
    if timer8[plr] and isTimer(timer8[plr]) then
    if getElementData(plr,"admin:rank") == "RCON" then killTimer(timer8[plr]) elseif(getElementData(plr,"admin:rank"))then triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie wolno używać tak często\nkomendy /fix (30 sekund)!"}) return end end
    timer8[plr] = setTimer(function() end,30000,1)
    if plr and getElementData(plr,"admin:rank") then
        if(tonumber(getElementData(plr, "CID"))) == (99)then 
            triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Funkcja ta została Ci zablokowana"});
            return;
        end
        if text and tostring(text) then
            local cel = findPlayer(plr,text)
            if cel and isElement(cel) then
                if isPedInVehicle(cel) then
                    fixVehicle(getPedOccupiedVehicle(cel))
		    exports["CS-OffroadDriving"]:export_returnOriginalHandling(getPedOccupiedVehicle(cel));
                    exports["lss-admin"]:rconView_add("[FIX] "..getPlayerName(plr).." >> naprawił pojazd gracza "..getPlayerName(cel).." >> "..getVehiclePlateText(getPedOccupiedVehicle(cel)))
                end
            else
                outputChatBox("* Nie znaleziono celu!",plr,155,0,0)
            end
        else
            if isPedInVehicle(plr) then
                fixVehicle(getPedOccupiedVehicle(plr))
                exports["lss-admin"]:rconView_add("[FIX] "..getPlayerName(plr).." naprawił swoje auto >> "..getVehiclePlateText(getPedOccupiedVehicle(plr)))
            end
        end
    end
end)

addCommandHandler("hp",function(plr,cmd,text)
    if timer8[plr] and isTimer(timer8[plr]) then
    if getElementData(plr,"admin:rank") == "RCON" then killTimer(timer8[plr]) else triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie wolno używać tak często\nkomendy /hp (30 sekund)!"}) return end end
    timer8[plr] = setTimer(function() end,30000,1)
    if plr and getElementData(plr,"admin:rank") then
        if text and tostring(text) then
            local cel = findPlayer(plr,text)
            if cel and isElement(cel) then
                setElementHealth(cel,100)
                triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Uleczyłeś gracza "..getPlayerName(cel).."."})
                exports["lss-admin"]:rconView_add("[HP] "..getPlayerName(plr).." >> "..getPlayerName(cel))
            end
        end
    end
end)


addCommandHandler("m",function(plr,cmd,...)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function() end,200,1)
    if getElementData(plr,"admin:rank") then
        if ... then
            local allArgs = {...}
            local wiadomosc = table.concat(allArgs, " ")
            if wiadomosc then
		exports["lss-admin"]:rconView_add("[MODERATOR CHAT] "..getPlayerName(plr)..": "..wiadomosc )
                for _,v in ipairs(getElementsByType("player")) do
                    local ranga = getElementData(v,"admin:rank")
                    if ranga and ranga == "Moderator" or ranga == "Globalmoderator" or ranga == "Administrator" or ranga == "RCON" or ranga == "Globaladministrator" then
                        outputChatBox("#4cea5eM#FFFFFF> #4cea5e["..getElementData(plr,"id").."] "..getPlayerName(plr).." > #FFFFFF"..wiadomosc.."",v,255,255,255,true)
                    end
                end
            end
        end
    end
end)

addCommandHandler("gm",function(plr,cmd,...)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function() end,200,1)
    if getElementData(plr,"admin:rank") == "Globalmoderator" or getElementData(plr,"admin:rank") == "Administrator" or getElementData(plr,"admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
        if ... then
            local allArgs = {...}
            local wiadomosc = table.concat(allArgs, " ")
            if wiadomosc then
		exports["lss-admin"]:rconView_add("[GLOBALMODERATOR CHAT] "..getPlayerName(plr)..": "..wiadomosc )
                for _,v in ipairs(getElementsByType("player")) do
                    local ranga = getElementData(v,"admin:rank")
                    if ranga and ranga == "Globalmoderator" or ranga == "Administrator" or ranga == "RCON" or ranga == "Globaladministrator" then
                        outputChatBox("#008e02GM#FFFFFF> #008e02["..getElementData(plr,"id").."] "..getPlayerName(plr).." > #FFFFFF"..wiadomosc.."",v,255,255,255,true)
                    end
                end
            end
        end
    end
end)


addCommandHandler("ga",function(plr,cmd,...)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function() end,200,1)
    if getElementData(plr,"admin:rank") == "Globaladministrator" or getElementData(plr,"admin:rank") == "RCON" then
        if ... then
            local allArgs = {...}
            local wiadomosc = table.concat(allArgs, " ")
            if wiadomosc then
		exports["lss-admin"]:rconView_add("[GLOBALADMINISTRATOR CHAT] "..getPlayerName(plr)..": "..wiadomosc )
                for _,v in ipairs(getElementsByType("player")) do
                    local ranga = getElementData(v,"admin:rank")
                    if ranga and ranga == "Globaladministrator" or ranga == "RCON" then
                        outputChatBox("#3498dbGA#FFFFFF> #3498db["..getElementData(plr,"id").."] "..getPlayerName(plr).." > #FFFFFF"..wiadomosc.."",v,255,255,255,true)
                    end
                end
            end
        end
    end
end)


addCommandHandler("a",function(plr,cmd,...)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function() end,200,1)
    if getElementData(plr,"admin:rank") == "Administrator" or getElementData(plr,"admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
        if ... then
            local allArgs = {...}
            local wiadomosc = table.concat(allArgs, " ")
            if wiadomosc then
		exports["lss-admin"]:rconView_add("[ADMIN CHAT] "..getPlayerName(plr)..": "..wiadomosc )
                for _,v in ipairs(getElementsByType("player")) do
                    local ranga = getElementData(v,"admin:rank")
                    if ranga and ranga == "Administrator" or ranga == "RCON" or ranga == "Globaladministrator" then
                        outputChatBox("#e82a1fA#FFFFFF> #e82a1f["..getElementData(plr,"id").."] "..getPlayerName(plr).." > #FFFFFF"..wiadomosc.."",v,255,255,255,true)
                    end
                end
            end
        end
    end
end)

addCommandHandler("r",function(plr,cmd,...)
    if getElementData(plr,"admin:rank") == "RCON" then
        if ... then
            local allArgs = {...}
            local wiadomosc = table.concat(allArgs, " ")
            if wiadomosc then
                for _,v in ipairs(getElementsByType("player")) do
                    local ranga = getElementData(v,"admin:rank")
                    if ranga and ranga == "RCON" then
                        outputChatBox("#800000R#FFFFFF> #800000["..getElementData(plr,"id").."] "..getPlayerName(plr).." > #FFFFFF"..wiadomosc.."",v,255,255,255,true)
                    end
                end
            end
        end
    end
end)

addCommandHandler("tp",function(plr,cmd,tekst)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        local ranga = getElementData(plr,"admin:rank")
        if ranga == "Globalmoderator" or ranga == "Administrator" or ranga == "Globaladministrator" or ranga == "RCON" then
            if tekst and string.find(tekst,",") then
                local posXYZ = split(tekst,",")
                local x,y,z = posXYZ[1],posXYZ[2],posXYZ[3]
                if x and y and z then
                    setElementPosition(plr,x,y,z)
                    outputChatBox("Preniesiono pod wskazaną pozycję!",plr)
                end
            end
        end
    end
end)

local veh = {}
local timer1 = {}
local timer2 = {}
addCommandHandler("cv",function(plr,cmd,id) --------------------------------
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"admin:rank") == "Administrator" or getElementData(plr,"admin:rank") == "RCON" or getElementData(plr,"admin:rank") == "Globaladministrator"  then
            if timer2[plr] and isTimer(timer2[plr]) then return end
            timer2[plr] = setTimer(function(plr) end,1000,1)
            if isPedInVehicle(plr) then outputChatBox("Wysiądź z pojazdu!",plr,255,0,0) return end
            if getElementDimension(plr) == 456 then return end
            if id and tonumber(id) then
                if tonumber(id) == 432 or tonumber(id) == 520 then
                    triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie możesz zrespić tego pojazdu\n na dim 0."})
                return end
                local x,y,z = getElementPosition(plr)
                local rx,ry,rz = getElementRotation(plr)
                local d,i = getElementDimension(plr),getElementInterior(plr)
                veh[plr] = createVehicle(tonumber(id),x,y,z,rx,ry,rz,"RESP_"..getElementData(plr,"CID").."")
                if not veh[plr] and not isElement(veh[plr]) then return end
                setElementData(veh[plr],"vehicletodestroy:public",true)
                setElementDimension(veh[plr],d)
                setElementInterior(veh[plr],i)
                setElementData(veh[plr],"pojazd:respiony",true)
                warpPedIntoVehicle(plr,veh[plr])
                setVehicleColor(veh[plr],255,255,255,255,255,255)
                exports["lss-admin"]:rconView_add("[CV] "..getPlayerName(plr).." >> "..getElementModel(veh[plr]).." ("..getVehicleNameFromModel(id)..").")
                if not getPedOccupiedVehicle(plr) or getPedOccupiedVehicle(plr)~=veh[plr] then
                    outputChatBox("Wystąpił błąd!",plr)
                    if veh[plr] and isElement(veh[plr]) then destroy(veh[plr]) veh[plr]=nil end
                end
            else
                if id and tostring(id) then
                    if getVehicleModelFromName(id) then
                        local model = getVehicleModelFromName(id)
                        local x,y,z = getElementPosition(plr)
                        local rx,ry,rz = getElementRotation(plr)
                        local d,i = getElementDimension(plr),getElementInterior(plr)
                        if model == 432 or model == 520 then
                            triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Nie możesz zrespić tego pojazdu\n na dim 0."})
                            return end
                        veh[plr] = createVehicle(model,x,y,z,rx,ry,rz,"RESP_"..getElementData(plr,"CID").."")
                        if not veh[plr] or not isElement(veh[plr]) then return end
                        setElementData(veh[plr],"vehicletodestroy:public",true)
                        setElementDimension(veh[plr],d)
                        setElementInterior(veh[plr],i)
                        setElementData(veh[plr],"pojazd:respiony",true)
                        warpPedIntoVehicle(plr,veh[plr])
                        setVehicleColor(veh[plr],255,255,255,255,255,255)
                        exports["lss-admin"]:rconView_add("[CV] "..getPlayerName(plr).." >> "..getElementModel(veh[plr]).." ("..getVehicleNameFromModel(model)..").")
                        if not getPedOccupiedVehicle(plr) or getPedOccupiedVehicle(plr)~=veh[plr] then
                            outputChatBox("Wystąpił błąd!",plr)
                            if veh[plr] and isElement(veh[plr]) then destroy(veh[plr]) veh[plr]=nil end
                        end
                    end
                else
                    outputChatBox("Nie podałeś ID pojazdu lub jego nazwy, który chcesz zrespić!",plr)
                end
            end
        end
    end
end)

addEventHandler("onVehicleExit",resourceRoot,function(plr,seat)
    if seat == 0 then
        if veh[plr] and isElement(veh[plr]) then
            if getElementData(veh[plr],"pojazd:respiony") then
                destroyElement(veh[plr])
                veh[plr]=nil
            end
        end
    end
end)

setTimer(function()
    for _,v in ipairs(getElementsByType("vehicle",resourceRoot)) do
        if v and isElement(v) then
            if getElementData(v,"pojazd:respiony") then
                if not getVehicleController(v) then
                    destroyElement(v)
                end
            end
        end
    end
end,10000,0)

local shapeDerb = createColSphere(4470.66,-185.48,59.86,75)
addCommandHandler("derby",function(plr,cmd)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function(plr) timer6[plr]=nil end,500,1,plr)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"CID") then
            if getElementData(plr,"admin:rank") then
                if isElementWithinColShape(plr,shapeDerb) then
                    local x,y,z = getElementPosition(plr)
                    local rx,ry,rz = getElementRotation(plr)
                    local vehicle = createVehicle(556,x+2,y,z+1,rx,ry,rz,"DERBY")
                    setElementDimension(vehicle,650)
                    setElementData(vehicle,"vehicletodestroy:public",true)
                    exports["lss-admin"]:rconView_add("[DERBY-POJAZD] "..getPlayerName(plr)..".")
                end
            end
        end
    end
end)

addCommandHandler("jp",function(plr,cmd)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function() end,250,1)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"admin:rank") then
            if not doesPedHaveJetPack(plr) then
                setPedWearingJetpack(plr,true)
                exports["lss-admin"]:rconView_add("[JP-ON] "..getPlayerName(plr)..".")
            else
                setPedWearingJetpack(plr,false)
                exports["lss-admin"]:rconView_add("[JP-OFF] "..getPlayerName(plr)..".")
            end
        end
    end
end)

addCommandHandler("resp",function(plr,cmd,id)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function(plr) timer6[plr]=nil end,500,1,plr)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"admin:rank") then
            if getElementDimension(plr) ~= 0 then
                if isPedInVehicle(plr) then outputChatBox("Wysiądź z pojazdu!",plr,255,0,0) return end
                if getElementDimension(plr) == 456 then return end
                if id and tonumber(id) then
                    local x,y,z = getElementPosition(plr)
                    local rx,ry,rz = getElementRotation(plr)
                    local d,i = getElementDimension(plr),getElementInterior(plr)
                    local veh = createVehicle(tonumber(id),x,y,z,rx,ry,rz,"RESP_"..getElementData(plr,"CID").."")
                    setElementDimension(veh,d)
                    setElementInterior(veh,i)
                    warpPedIntoVehicle(plr,veh)
                    setVehicleColor(veh,255,255,255,255,255,255)
                    exports["lss-admin"]:rconView_add("[CV-DIM] "..getPlayerName(plr).." >> "..getElementModel(veh).." ("..getVehicleNameFromModel(id)..").")
                else
                    if id and tostring(id) then
                        if getVehicleModelFromName(id) then
                            local model = getVehicleModelFromName(id)
                            local x,y,z = getElementPosition(plr)
                            local rx,ry,rz = getElementRotation(plr)
                            local d,i = getElementDimension(plr),getElementInterior(plr)
                            local veh = createVehicle(model,x,y,z,rx,ry,rz,"RESP_"..getElementData(plr,"CID").."")
                            setElementDimension(veh,d)
                            setElementInterior(veh,i)
                            warpPedIntoVehicle(plr,veh)
                            setVehicleColor(veh,255,255,255,255,255,255)
                            exports["lss-admin"]:rconView_add("[CV-DIM] "..getPlayerName(plr).." >> "..getElementModel(veh).." ("..getVehicleNameFromModel(model)..").")
                        end
                    else
                        outputChatBox("Nie podałeś ID pojazdu lub jego nazwy, który chcesz zrespić!",plr)
                    end
                end
            else
                outputChatBox("Aby zrespić pojazd na DIM 0, musisz użyć komendy /cv!",plr,255,0,0)
            end
        end
    end
end)

addCommandHandler("sserial",function(plr,cmd,cel)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function(plr) timer6[plr]=nil end,500,1,plr)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"admin:rank") then
            if cel and tostring(cel) then
            local wynik = exports.DB:pobierzTabeleWynikow("SELECT DISTINCT serial FROM cl_logowanie WHERE (login=? OR nick=? OR cid=?)",tostring(cel),tostring(cel),tonumber(cel))
            if wynik and #wynik > 0 then
                outputChatBox("Wyszukane seriale: ",plr)
                for _,v in ipairs(wynik) do
                    exports["lss-admin"]:rconView_add("[S-SERIAL] "..getPlayerName(plr).." >> "..cel..".")
                    outputChatBox(v["serial"],plr)
                end
                else
                    outputChatBox("Nie znaleziono podanego gracza!",plr,255,0,0)
            end
            end
        end
    end
end)



addCommandHandler("tprejka",function(plr,cmd,rejka)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function(plr) timer6[plr]=nil end,500,1,plr)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"admin:rank") then
            if rejka and tostring(rejka) then
                for _,v in ipairs(getElementsByType("vehicle")) do
                    if v and isElement(v) then
                        if getVehiclePlateText(v) == tostring(rejka) then
                            local x,y,z = getElementPosition(v)
                            setElementPosition(plr,x,y,z+2)
                            exports["lss-admin"]:rconView_add("[TP-REJKA] "..getPlayerName(plr).." >> "..rejka..".")
                        end
                    end
                end
            end
        end
    end
end)

addCommandHandler("threjka",function(plr,cmd,rejka)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function(plr) timer6[plr]=nil end,500,1,plr)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"admin:rank") then
            if rejka and tostring(rejka) then
                for _,v in ipairs(getElementsByType("vehicle")) do
                    if v and isElement(v) then
                        if getVehiclePlateText(v) == tostring(rejka) then
                            local x,y,z = getElementPosition(plr)
                            setElementPosition(v,x,y,z+2)
                            exports["lss-admin"]:rconView_add("[TH-REJKA] "..getPlayerName(plr).." >> "..rejka..".")
                        end
                    end
                end
            end
        end
    end
end)


addCommandHandler("czas",function(plr,cmd,cel)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function(plr) timer6[plr]=nil end,500,1,plr)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"admin:rank") then
            if cel then
                if tonumber(cel) then
                    local wynik = exports.DB:pobierzTabeleWynikow("SELECT minuty FROM cl_characters WHERE CID=? LIMIT 1",tonumber(cel))
                    for _,v in ipairs(wynik) do
                        if v["minuty"] then
                            outputChatBox("[CID "..tonumber(cel).."] Minuty przegrane na serwerze: "..tonumber(v["minuty"]).." (około "..math.floor(tonumber(v["minuty"])/60).." godzin/y)",plr,0,255,0)
                            exports["lss-admin"]:rconView_add("[CZAS-CID] "..getPlayerName(plr).." >> "..tonumber(cel)..".")
                        end
                    end
                else
                    local odbiorca = findPlayer(plr,cel)
                    if odbiorca then
                        local wynik = exports.DB:pobierzTabeleWynikow("SELECT minuty FROM cl_characters WHERE login=? LIMIT 1",tostring(getElementData(odbiorca,"login")))
                        for _,v in ipairs(wynik) do
                            if v["minuty"] then
                                outputChatBox("[GRACZ "..tostring(getPlayerName(odbiorca)).."] Minuty przegrane na serwerze: "..tonumber(v["minuty"]).." (około "..math.floor(tonumber(v["minuty"])/60).." godzin/y)",plr,0,255,0)
                                exports["lss-admin"]:rconView_add("[CZAS-GRACZ] "..getPlayerName(plr).." >> "..tostring(getPlayerName(odbiorca))..".")
                            end
                        end
                    else
                        local wynik = exports.DB:pobierzTabeleWynikow("SELECT minuty FROM cl_characters WHERE login=? LIMIT 1",tostring(cel))
                        for _,v in ipairs(wynik) do
                            if v["minuty"] then
                                outputChatBox("[LOGIN "..tostring(cel).."] Minuty przegrane na serwerze: "..tonumber(v["minuty"]).." (około "..math.floor(tonumber(v["minuty"])/60).." godzin/y)",plr,0,255,0)
                                exports["lss-admin"]:rconView_add("[CZAS-LOGIN] "..getPlayerName(plr).." >> "..tostring(cel)..".")
                            end
                        end
                    end
                end
            else
                outputChatBox("Nie wpisano podanego celu!",plr,255,0,0)
            end
        end
    end
end)


addCommandHandler("kary",function(plr,cmd,cel)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function(plr) timer6[plr]=nil end,500,1,plr)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"admin:rank") then
            if cel then
                local kary = {}
                if tostring(cel) then
                    local wynik = exports.DB:pobierzTabeleWynikow("SELECT CID,Serial FROM cl_characters WHERE login=? LIMIT 1",tostring(cel))
                    if wynik and #wynik>0 then
                        local cid,serial = nil,nil
                        for _,v in ipairs(wynik) do
                            cid,serial = v["CID"],v["Serial"]
                            outputDebugString(cid..", "..serial)
                        end
                        wynik = nil
                        local wynik = exports.DB:pobierzTabeleWynikow("SELECT dbid,date,type,cid,serial,do,przez,powod FROM cs_kary WHERE (cid=? OR serial=?)",cid,serial)
                        for _,v in ipairs(wynik) do
                            table.insert(kary,"- ["..v["dbid"].." - "..v["date"].."] Typ: "..v["type"]..", cid: "..v["cid"]..", serial: "..v["serial"]..", do: "..v["do"]..", przez: "..v["przez"]..", powód: "..v["powod"])
                        end
                        kary=table.concat(kary,"\n")
                        outputChatBox("Kary nałożone na gracza "..tostring(cel)..":",plr,100,100,0)
                        if #kary == 0 then kary="- brak nałożonych kar." end
                        outputChatBoxSplitted(kary,plr)
                        exports["lss-admin"]:rconView_add("[KARY-CHECK] "..getPlayerName(plr).." >> "..tostring(cel)..".")
                    else
                        outputChatBox("* Podano nieprawidłowy login!",plr)
                    end
                    wynik=nil
                end
            else
                outputChatBox("Nie wpisano podanego celu!",plr,255,0,0)
            end
        end
    end
end)

addCommandHandler("ustawczas",function(plr,cmd,h,m)
    if plr and isElement(plr) then
        if getElementData(plr,"admin:rank") then
            if getElementData(plr,"admin:rank") == "Administrator" or getElementData(plr,"admin:rank") == "Globaladministrator" or getElementData(plr,"admin:rank") == "RCON" then
                if h and tonumber(h) then
                    if tonumber(h) >= 0 and tonumber(h) <= 60 then
                    else
                        outputChatBox("Godziny zawierają się w zakresie czasowym od 0 do 23!",plr,255,0,0)
                        return
                    end
                else
                    outputChatBox("Nie podałeś godzin!",plr,255,0,0)
                    return
                end
                if m and tonumber(m) then
                    if tonumber(m) >= 0 and tonumber(m) <= 59 then
                    else
                        outputChatBox("Minuty zawierają się w zakresie czasowym od 0 do 59!",plr,255,0,0)
                        return
                    end
                else
                    outputChatBox("Nie podałeś minut!",plr,255,0,0)
                    return
                end
                setTime(h,m)
                outputChatBox("* Ustawiłeś czas serwerowy na "..h..":"..m..".",plr,0,255,0)
                exports["lss-admin"]:rconView_add("[SET-TIME] "..getPlayerName(plr).." >> "..h..":"..m..".")
            end
        end
    end
end)



addCommandHandler("ttv",function(plr,cmd,id)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function(plr) timer6[plr]=nil end,500,1,plr)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"CID") then
            if getElementData(plr,"admin:rank") then
                if id and tonumber(id) then
                    local v = exports["CS-vehicles"]:findVehicleByID(tonumber(id))
                    if v and isElement(v) then
                        local x,y,z = getElementPosition(v)
                        local d,i = getElementDimension(v),getElementInterior(v)
                        setElementPosition(plr,x,y,z+1.5)
                        setElementDimension(plr,d)
                        setElementInterior(plr,i)
                        exports["lss-admin"]:rconView_add("[TTV] "..getPlayerName(plr).." DO "..tonumber(id)..".")
                    else
                        outputChatBox("Nie znaleziono pojazdu!",plr,255,0,0)
                    end
                else
                    outputChatBox("Nie podano ID pojazdu!",plr,255,0,0)
                end
            end
        end
    end
end)

addCommandHandler("thv",function(plr,cmd,id)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function(plr) timer6[plr]=nil end,500,1,plr)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"CID") then
            if getElementData(plr,"admin:rank") then
                if id and tonumber(id) then
                    local v = exports["CS-vehicles"]:findVehicleByID(tonumber(id))
                    if v and isElement(v) then
                        local x,y,z = getElementPosition(plr)
                        local d,i = getElementDimension(plr),getElementInterior(plr)
                        setElementPosition(v,x,y,z)
                        setElementDimension(v,d)
                        setElementInterior(v,i)
                        setElementPosition(plr,x,y,z+1.5)
                        exports["lss-admin"]:rconView_add("[THV] "..getPlayerName(plr).." DO "..tonumber(id)..".")
                    else
                        outputChatBox("Nie znaleziono pojazdu!",plr,255,0,0)
                    end
                else
                    outputChatBox("Nie podano ID pojazdu!",plr,255,0,0)
                end
            end
        end
    end
end)

local timer = {}
addCommandHandler("vehdp",function(plr,cmd,id)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function() end,250,1)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"CID") then
            if getElementData(plr,"admin:rank") then
                if id and tonumber(id) then
                    local v = exports["CS-vehicles"]:findVehicleByID(tonumber(id))
                    if v and isElement(v) then
                        if getElementData(v, "vehicle:opis:gielda") == true then removeElementData(v,"vehicle:opis") end
                        local vehPrev = getElementData(v, "variantPreview");
                        if(vehPrev) and (vehPrev[1]) and (vehPrev[2])then
                            triggerEvent("vehicle-components:setVehicleVariant", plr, v, vehPrev[1], vehPrev[2])
                        end
                        exports["CS-vehicles"]:saveVehiclesData(tonumber(getElementData(v,"veh:dbid")))
                        exports.DB:zapytanie("UPDATE cl_vehicles SET storage=? WHERE id=? LIMIT 1",1,getElementData(v,"veh:dbid"))
                        timer[plr] = setTimer(function(plr,veh)
                            if veh and isElement(veh) then
                                local blockade = exports["CS-blockade"]:checkBlockade(veh)
                                if blockade == true then
                                    exports["CS-blockade"]:setBlockade(veh, "destroy")
                                end
                                destroyElement(veh)
                            end
                            timer[plr]=nil
                        end,500,1,plr,v)
                        triggerClientEvent(plr,"CS:powiadomienie",plr,plr,{"error","Pojazd został przeniesiony\n do przechowalni!"})
                        exports["lss-admin"]:rconView_add("[VEHDP] "..getPlayerName(plr).." >> "..tonumber(id)..".")
                    else
                        outputChatBox("Nie znaleziono pojazdu!",plr,255,0,0)
                    end
                else
                    outputChatBox("Nie podano ID pojazdu!",plr,255,0,0)
                end
            end
        end
    end
end)

addCommandHandler("vehdpw",function(plr,cmd,id)
    if timer6[plr] and isTimer(timer6[plr]) then return end
    timer6[plr] = setTimer(function() end,250,1)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"CID") then
            if getElementData(plr,"admin:rank") then
                if id and tonumber(id) then
                    local v = exports["CS-rental"]:checkVehicle(tonumber(id))
                    if v and isElement(v) then
                        exports["CS-rental"]:updateResultsOfVehicle(tonumber(id))
                        exports.DB:zapytanie("UPDATE cs_rentalhistory SET przechowalnia=? WHERE dbid=? LIMIT 1",1,tonumber(id))
                        timer[plr] = setTimer(function(plr,veh)
                            if veh and isElement(veh) then
                                local blockade = exports["CS-blockade"]:checkBlockade(veh)
                                if blockade == true then
                                    exports["CS-blockade"]:setBlockade(veh, "destroy")
                                end
                                exports["CS-rental"]:deleteVehicle(tonumber(id))
                            end
                            timer[plr]=nil
                        end,500,1,plr,v)
                        exports["lss-admin"]:rconView_add("[VEHDP-WYPOŻYCZALNIA] "..getPlayerName(plr).." >> "..tonumber(id)..".")
                    else
                        outputChatBox("Nie znaleziono pojazdu!",plr,255,0,0)
                    end
                else
                    outputChatBox("Nie podano ID pojazdu!",plr,255,0,0)
                end
            end
        end
    end
end)

addCommandHandler("pojazdy",function(plr,cmd,cid)
    if plr and isElement(plr) then
        if getElementData(plr,"admin:rank") then
            if timer6[plr] and isTimer(timer6[plr]) then return end
            timer6[plr] = setTimer(function(plr) timer6[plr]=nil end,500,1,plr)
            if cid and tonumber(cid) then
                        local wynik = exports.DB:pobierzTabeleWynikow("SELECT id,model,storage,police_parking,przebieg FROM cl_vehicles WHERE owner=?",cid)
                        if wynik and #wynik>0 then
                            for _,v in ipairs(wynik) do
                                local storage,policeparking=v["storage"],v["police_parking"]
                                info="brak informacji"
                                if storage==1 then info="w przechowalni pojazdów" end
                                if policeparking==1 then info="na parkingu policyjnym" end
                                if storage==0 and policeparking==0 then info="na mapie" end
                                outputChatBox("- "..getVehicleNameFromModel(v["model"]).." ("..v["model"]..") - ID: "..v["id"]..", status: "..info..", przebieg: "..string.format("%.01f",v["przebieg"]).." km.",plr)
                            end
                        else
                            outputChatBox("* Gracz nie posiada żadnych pojazdów prywatnych.",plr)
                        end
                        exports["lss-admin"]:rconView_add("[SPRAWDŹ POJAZDY] "..getPlayerName(plr).." >> "..tostring(gracz)..".")
                        wynik=nil
            else
                outputChatBox("Nie podano cidu gracza!",plr,255,0,0)
            end
        end
    end
end)

addCommandHandler("fixo",function(plr,cmd,radius)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"admin:rank") and getElementData(plr,"admin:rank") ~= "Moderator" then
            if radius and tonumber(radius)>0 then
                local x,y,z = getElementPosition(plr)
                local shape = createColSphere(x,y,z,tonumber(radius))
                if (#getElementsWithinColShape(shape,"vehicle")>0) then
                    for _,v in ipairs(getElementsWithinColShape(shape,"vehicle")) do
                        fixVehicle(v)
                        exports["CS-OffroadDriving"]:export_returnOriginalHandling(v);
                    end
                    exports["lss-admin"]:rconView_add("[FIXO] "..getPlayerName(plr)..", "..math.floor(x)..","..math.floor(y)..","..math.floor(z).." >> kąt "..radius..".")
                end
                destroyElement(shape)
            end
        end
    end
end)

addCommandHandler("clro",function(plr,cmd,radius)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"admin:rank") and getElementData(plr,"admin:rank") ~= "Moderator" then
            if radius and tonumber(radius)>0 then
                local x,y,z = getElementPosition(plr)
                local shape = createColSphere(x,y,z,tonumber(radius))
                if (#getElementsWithinColShape(shape,"vehicle")>0) then
                    for _,v in ipairs(getElementsWithinColShape(shape,"vehicle")) do
                        setVehicleColor(v, math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
                    end
                    exports["lss-admin"]:rconView_add("[CLRO] "..getPlayerName(plr)..", "..math.floor(x)..","..math.floor(y)..","..math.floor(z).." >> kąt "..radius..".")
                end
                destroyElement(shape)
            end
        end
    end
end)

addCommandHandler("flipo",function(plr,cmd,radius)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"admin:rank") and getElementData(plr,"admin:rank") ~= "Moderator" then
            if radius and tonumber(radius)>0 then
                local x,y,z = getElementPosition(plr)
                local shape = createColSphere(x,y,z,tonumber(radius))
                if (#getElementsWithinColShape(shape,"vehicle")>0) then
                    for _,v in ipairs(getElementsWithinColShape(shape,"vehicle")) do
local rx, ry, rz = getElementRotation(v)
						setElementRotation(v, rx, ry+180, rz)
                    end
                    exports["lss-admin"]:rconView_add("[FLIPO] "..getPlayerName(plr)..", "..math.floor(x)..","..math.floor(y)..","..math.floor(z).." >> kąt "..radius..".")
                end
                destroyElement(shape)
            end
        end
    end
end)


addCommandHandler("markerpos",function(plr,cmd,radius)
    if plr and isElement(plr) and getElementData(plr,"CID") then
        if getElementData(plr,"admin:rank") and getElementData(plr,"admin:rank") == "RCON" then
            if radius and tonumber(radius)>0 and tonumber(radius)<=50 then
                local x,y,z = getElementPosition(plr)
                local shape = createColSphere(x,y,z,tonumber(radius))
                if (#getElementsWithinColShape(shape,"marker")>0) then
                    for i,v in ipairs(getElementsWithinColShape(shape,"marker")) do
                        local x,y,z = getElementPosition(v)
                        local x,y,z = string.format("%.02f",x),string.format("%.02f",y),string.format("%.02f",z)
                        outputChatBox("Pozycja markera "..i..": "..x..","..y..","..z..".",plr)
                    end
                end
                destroyElement(shape)
            else
                outputChatBox("Kąt musi być >0 i <=50!",plr)
            end
        end
    end
end)

function vehicleopis(plr,cmd,...)
    if plr and isElement(plr) and getElementType(plr)=="player" then
        if getElementData(plr,"admin:rank") and getElementData(plr,"admin:rank")~="Moderator" then
            local veh = getPedOccupiedVehicle(plr)
            if veh and isElement(veh) then
                if getElementData(veh,"public:car") or getElementData(veh,"vehicle:salon") then return end
                if ... then
                    local opis = table.concat({...}," ")
                    if opis and tostring(opis)~="" then
                        setElementData(veh,"vehicle:opis",tostring(opis))
                        exports["lss-admin"]:rconView_add("[VEH OPIS] "..getPlayerName(plr)..", opis: "..opis)
                    else
                        setElementData(veh,"vehicle:opis",false)
                    end
                else
                    setElementData(veh,"vehicle:opis",false)
                end
            end
        end
    end
end
addCommandHandler("opis",vehicleopis)
addCommandHandler("vehopis",vehicleopis)
addCommandHandler("vehicleopis",vehicleopis)
addCommandHandler("vopis",vehicleopis)


addCommandHandler("posrot",function(plr,cmd)
    if plr and isElement(plr) and getElementType(plr) == "player" and getElementData(plr,"CID") then
        if getElementData(plr,"admin:rank") then
            local x,y,z = getElementPosition(plr)
            local rx,ry,rz = getElementRotation(plr)
            local x,y,z,rx,ry,rz = string.format("%.02f",x),string.format("%.02f",y),string.format("%.02f",z),string.format("%.02f",rx),string.format("%.02f",ry),string.format("%.02f",rz)
            outputChatBox("{"..x..","..y..","..z..","..rx..","..ry..","..rz.."},",plr)
        end
    end
end)

addCommandHandler("poz",function(plr,cmd)
    if plr and isElement(plr) and getElementType(plr) == "player" and getElementData(plr,"CID") then
        if getElementData(plr,"admin:rank") then
            local x,y,z = getElementPosition(plr)
            local x,y,z = string.format("%.02f",x),string.format("%.02f",y),string.format("%.02f",z)
            outputChatBox("{"..x..","..y..","..z.."};",plr)
        end
    end
end)

addCommandHandler("vehpos",function(plr,cmd)
    if plr and isElement(plr) and getElementType(plr) == "player" and getElementData(plr,"CID") then
        if getElementData(plr,"admin:rank") then
            local veh = getPedOccupiedVehicle(plr)
            if veh and isElement(veh) then
                local x,y,z = getElementPosition(veh)
                local x,y,z,rx,ry,rz = string.format("%.02f",x),string.format("%.02f",y),string.format("%.02f",z)
                outputChatBox("{"..x..","..y..","..z.."},",plr)
            end
        end
    end
end)

addCommandHandler("vehposrot",function(plr,cmd)
    if plr and isElement(plr) and getElementType(plr) == "player" and getElementData(plr,"CID") then
        if getElementData(plr,"admin:rank") then
            local veh = getPedOccupiedVehicle(plr)
            if veh and isElement(veh) then
                local x,y,z = getElementPosition(veh)
                local rx,ry,rz = getElementRotation(veh)
                local x,y,z,rx,ry,rz = string.format("%.02f",x),string.format("%.02f",y),string.format("%.02f",z),string.format("%.02f",rx),string.format("%.02f",ry),string.format("%.02f",rz)
                outputChatBox("{"..x..","..y..","..z..","..rx..","..ry..","..rz.."},",plr)
            end
        end
    end
end)

addCommandHandler("pos",function(plr,cmd)
    if plr and isElement(plr) and getElementType(plr) == "player" and getElementData(plr,"CID") then
        if getElementData(plr,"admin:rank") then
            local x,y,z = getElementPosition(plr)
            outputChatBox("{"..x..", "..y..", "..z.."},",plr)
        end
    end
end)


addCommandHandler("setfrakcja",function(plr,cmd,frakcja, ...)
    if plr and isElement(plr) and getElementType(plr) == "player" and getElementData(plr,"CID") then
        if getElementData(plr,"admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
            if frakcja and tostring(frakcja) then
                local rangaText = false;
                if(...)then
                    rangaText = table.concat({...}," ");
                end
                setElementData(plr,"frakcja",frakcja)
                setElementData(plr,"frakcja:ranga",rangaText)
                outputChatBox("Ustawiono frakcję na "..frakcja..".",plr)
                if(rangaText)then
                    exports["DB"]:prepareSet("UPDATE `cl_characters` SET `frakcja` = ?, `frakcja_ranga` = ? WHERE `CID` = ?", frakcja, rangaText, getElementData(plr,"CID"))
                else
                    exports["DB"]:prepareSet("UPDATE `cl_characters` SET `frakcja` = ? WHERE `CID` = ?", frakcja, getElementData(plr,"CID"))
                end
            end
        end
    end
end)


addCommandHandler("setbiznes",function(plr,cmd,biznes, ...)
    if plr and isElement(plr) and getElementType(plr) == "player" and getElementData(plr,"CID") then
        if getElementData(plr,"admin:rank") and (getElementData(plr,"admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator") then
            if frakcja and tostring(biznes) then
                local rangaText = false;
                if(...)then
                    rangaText = table.concat({...}," ");
                end
                setElementData(plr,"biznes",biznes)
                outputChatBox("Ustawiono biznes na "..biznes..".",plr)
                if(rangaText)then
                    exports["DB"]:prepareSet("UPDATE `cl_characters` SET `biznes` = ?, `biznes_lider` = ? WHERE `CID` = ?", biznes, rangaText, getElementData(plr,"CID"))
                else
                    exports["DB"]:prepareSet("UPDATE `cl_characters` SET `biznes` = ? WHERE `CID` = ?", biznes, getElementData(plr,"CID"))
                end
            end
        end
    end
end)

addCommandHandler("giveclc", function(thePlayer, command, arg)
    if getElementData(thePlayer, "admin:rank") == "RCON" then
        for k,v in ipairs(getElementsByType("player")) do
            outputChatBox("#00FF00[SERVER] Otrzymałeś #FFD700"..arg.." CLC #00FF00od "..getPlayerName(thePlayer), v, 255, 255, 255, true)
            if getElementData(v, "CLC") then
                setElementData(v, "CLC", getElementData(v, "CLC") + tonumber(arg))
            else
                setElementData(v, "CLC", tonumber(arg))
            end
        end
    end
end)

addCommandHandler("givecp.all_napewno", function(thePlayer, command, arg)
    if getElementData(thePlayer, "admin:rank") == "RCON" then
        for k,v in ipairs(getElementsByType("player")) do
            outputChatBox("#00FF00[SERVER] Otrzymałeś #00CCCC"..arg.." CP #00FF00od "..getPlayerName(thePlayer), v, 255, 255, 255, true)
            setElementData(v, "calm:points", getElementData(v, "calm:points") + tonumber(arg))
        end
    end
end)

addCommandHandler("givepln.all_napewno", function(thePlayer, command, arg)
    if getElementData(thePlayer, "admin:rank") == "RCON" then
        for k,v in ipairs(getElementsByType("player")) do
            outputChatBox("#00FF00[SERVER] Otrzymałeś #008000"..arg.." PLN #00FF00od "..getPlayerName(thePlayer), v, 255, 255, 255, true)
            givePlayerMoney(v, tonumber(arg))
        end
    end
end)

addCommandHandler("giveclcto", function(thePlayer, command, id, arg)
    if getElementData(thePlayer, "admin:rank") == "RCON" or getElementData(thePlayer, "CID") == 37 then
        if id and arg then
            local target = findPlayer(thePlayer, id)
            if target then
                if getElementData(target, "CLC") then
                    setElementData(target, "CLC", getElementData(target, "CLC") + tonumber(arg))
                else
                    setElementData(target, "CLC", tonumber(arg))
                end
                outputChatBox("#00FF00[SERVER] Otrzymałeś #FFD700"..arg.." CLC #00FF00od "..getPlayerName(thePlayer), target, 255, 255, 255, true)
                outputChatBox("#00FF00[SERVER] Wysłałeś #FFD700"..arg.." CLC #00FF00do "..getPlayerName(target), thePlayer, 255, 255, 255, true)
            end
        end
    end
end)

addCommandHandler("givecpto", function(thePlayer, command, id, arg)
    if id and arg then
        local target = findPlayer(thePlayer, id)
        if target then
            setElementData(target, "calm:points", getElementData(target, "calm:points") + tonumber(arg))
            outputChatBox("#00FF00[SERVER] Otrzymałeś #00CCCC"..arg.." CP #00FF00od "..getPlayerName(thePlayer), target, 255, 255, 255, true)
            outputChatBox("#00FF00[SERVER] Wysłałeś #00CCCC"..arg.." CP #00FF00do "..getPlayerName(target), thePlayer, 255, 255, 255, true)
        end
    end
end)

addCommandHandler("giveplnto", function(thePlayer, command, id, arg)
    if id and arg then
        local target = findPlayer(thePlayer, id)
        if target then
            givePlayerMoney(target, tonumber(arg))
            outputChatBox("#00FF00[SERVER] Otrzymałeś #008000"..arg.." PLN #00FF00od "..getPlayerName(thePlayer), target, 255, 255, 255, true)
            outputChatBox("#00FF00[SERVER] Wysłałeś #008000"..arg.." PLN #00FF00do "..getPlayerName(target), thePlayer, 255, 255, 255, true)
        end
    end
end)

addCommandHandler("usun.org", function(thePlayer, command, id)
    if getElementData(thePlayer, "admin:rank") == "RCON" or getElementData(thePlayer, "admin:rank") == "Globaladministrator" then
        if id then
            local targetB = findPlayer(thePlayer, id)
            if targetB then
                setElementData(targetB,"organizacja",false)
                setElementData(targetB,"organizacja:ranga",false)
                setElementData(targetB,"organizacja:ranga:typ",0)
                exports["DB"]:prepareSet("UPDATE `cl_characters` SET `organizacja` = ?, `organizacja_ranga` = ?, `organizacja_ranga` = 0 WHERE `CID` = ?", "", "", getElementData(targetB, "CID"))
                outputChatBox("Twoja przynaleznosc do organizacji zostala zmieniona przez "..getPlayerName(thePlayer), targetB, 255, 255, 255, true)
                outputChatBox("Zmieniono przynaleznosc do organizacji dla "..getPlayerName(targetB), thePlayer, 255, 255, 255, true)
            end
        end
    end
end)

addCommandHandler("usun.organizacje", function (plr, cmd, ...)
    if getElementData(plr, "admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
        if {...} then
            local name = table.concat({...}, " ")
            if name then
                local result = exports['DB']:pobierzTabeleWynikow("SELECT organizacja FROM cl_characters WHERE organizacja = ?", name)
                if result and #result > 0 then
                    exports['DB']:zapytanie("UPDATE cl_characters SET organizacja = '', organizacja_ranga = '', organizacja_ranga_typ = 0 WHERE organizacja = ?", name)
                    exports['DB']:zapytanie("DELETE FROM cs_organizacje WHERE organizacja = ?", name)
                    outputChatBox("Usunięto organizację "..name..".", plr, 255,255,255)
                    exports['lss-admin']:rconView_add("[ORG-DELETE] "..getPlayerName(plr).." >> "..name)
                end
            end
        end
    end
end)

addCommandHandler("zmiennazwa.organizacji", function (plr, cmd, ...)
    if getElementData(plr, "admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
        if (...) then
            local name = table.concat({...}, " ")
            name = split(name, ";")
            if name then
                outputDebugString(tostring(name[1]))
                outputDebugString(tostring(name[2]))
                local result = exports['DB']:pobierzTabeleWynikow("SELECT organizacja FROM cl_characters WHERE organizacja = ?", name[1])
                if result and #result > 0 then
                    exports['DB']:zapytanie("UPDATE cl_characters SET organizacja = ? WHERE organizacja = ?", name[2], name[1])
                    exports['DB']:zapytanie("UPDATE cs_organizacje SET organizacja = ? WHERE organizacja = ?", name[2], name[1])
                    for i,v in pairs(getElementsByType('player')) do
                        if getElementData(v, "organizacja") == name[1] then
                            setElementData(v, "organizacja", name[2])
                        end
                    end
                    outputChatBox("Zmieniono nazwę organizacji "..name[1].." na "..name[2]..".", plr, 255,255,255)
                    exports['lss-admin']:rconView_add("[ORG-NAME-CHANGE] "..getPlayerName(plr).." >> "..name[1].." -> "..name[2])
                end
            end
        end
    end
end)


addCommandHandler("nadajlidera.org", function(thePlayer, command, id)
    if getElementData(thePlayer, "admin:rank") == "RCON" or getElementData(thePlayer, "admin:rank") == "Globaladministartor"  then
        if id then
            local targetB = findPlayer(thePlayer, id)
            if targetB then
                setElementData(targetB,"organizacja:ranga","Lider")
                setElementData(targetB,"organizacja:ranga:typ",2)
                exports["DB"]:prepareSet("UPDATE `cl_characters` SET `organizacja_ranga` = ?, `organizacja_ranga_typ` = ? WHERE `CID` = ?", "Lider", "2", getElementData(targetB, "CID"))
                outputChatBox("Twoja przynaleznosc do organizacji (Ranga) zostala zmieniona przez "..getPlayerName(thePlayer), targetB, 255, 255, 255, true)
                outputChatBox("Zmieniono przynaleznosc (Ranga) do organizacji dla "..getPlayerName(targetB), thePlayer, 255, 255, 255, true)
            end
        end
    end
end)

addCommandHandler("set.orgcid", function(thePlayer, command, id, typ, ...)
    if getElementData(thePlayer, "admin:rank") == "RCON" or getElementData(thePlayer, "admin:rank") == "Globaladministrator" then
        if id and typ and ... then
            local text = table.concat({...}," ")
            for index, value in ipairs(getElementsByType("player"))do
                if(getElementData(value, "CID")) == (tonumber(id))then
                    setElementData(value,"organizacja",text)
                    setElementData(value,"organizacja:ranga:typ",tonumber(typ))
                end
            end
            exports["DB"]:prepareSet("UPDATE `cl_characters` SET `organizacja` = ?, `organizacja_ranga_typ` = ? WHERE `CID` = ?", text, typ, tonumber(id))
        end
    end
end)


addCommandHandler("checkaccounts", function(thePlayer, command, id)
    if getElementData(thePlayer, "admin:rank") == "RCON" or getElementData(thePlayer, "admin:rank") == "Administrator" or getElementData(thePlayer, "admin:rank") == "Globaladministrator"  then
        if id then
            local dbQuery = exports["DB"]:prepareSet("SELECT * FROM `cl_characters` WHERE `CID` = ? LIMIT 1", tonumber(id));
            if(dbQuery)then
                local dbQuery2 = exports["DB"]:prepareSet("SELECT * FROM `cl_characters` WHERE `serial` = ?", dbQuery[1].Serial);
                if(dbQuery2)then
                    outputDebugString(#dbQuery2);
                    for index, value in ipairs(dbQuery2) do
                        if(value)then
                            outputChatBox(index..". Konto [CID] = "..value.CID..", [login] = "..value.login..", [nick] = "..value.nick, thePlayer, 200, 200, 200);
                        end
                    end
                end
            end
        end
    end
end)

--[[
function fixVehiclesCapacity(player, command)
    if getElementData(player, "admin:rank") == "RCON" then
        local counter = 0;
        for index, value in ipairs(getElementsByType("vehicle")) do
            if(value) and (isElement(value))then
                local dbQ = exports["DB"]:prepareSet("SELECT * FROM `cl_vehicles` WHERE `id` = ? LIMIT 1", tonumber(getElementData(value, "veh:dbid")));
                if(dbQ) and (#dbQ) > (0)then
                    local capacity = getElementData(value, "capacity");
                    local upgrade = split(dbQ[1].customUpgrades, ",");
                    if(upgrade) and (tonumber(upgrade[1])) > (0)then
                        local bm = tonumber(dbQ[1].capacity) - tonumber(upgrade[1]);
                        bm = string.format("%.1f", tonumber(bm));
                        bm = tonumber(bm);
                        exports["DB"]:prepareSet("UPDATE `cl_vehicles` SET `capacity` = ? WHERE `id` = ? LIMIT 1", bm, tonumber(getElementData(value, "veh:dbid")));
                        counter = counter + 1;
                    end
                end
            end
        end
        outputChatBox("Change will apear at "..counter.." vehicles", player);
    end
end
addCommandHandler("checkVehicleChange", fixVehiclesCapacity)]]

addCommandHandler("tpkier",function(plr,cmd,id)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
        if id then
            local targetB = findPlayer(plr, id)
            if targetB then
		warpPedIntoVehicle(targetB , getPedOccupiedVehicle(plr), 0)
        	outputChatBox("#FFFF00★ #FFFFFFTeleportowano.",plr,0,0,0,true)
	    end
	end
	end
    end
end)

function addAccountEXP(plr,cmd,cid,amount)
    if plr and isElement(plr) and getElementType(plr) == "player" then
        if getElementData(plr,"admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
            if(cid) and (amount) and (tonumber(cid) and tonumber(amount))then
                local find = false;
                for index, value in pairs(getElementsByType("player")) do
                    if(value) and (isElement(value))then
                        if(getElementData(value, "CID")) == (tonumber(cid))then
                            find = value;
                            break;
                        end
                    end
                end
                if(find) and (isElement(find))then
                    exports["cs_levelingSystem"]:addPlayerExperience(find, tonumber(amount));
                else
                    exports["DB"]:prepareSet("UPDATE `cl_characters` SET `player_Exp` = `player_Exp` + ? WHERE `CID` = ?", tonumber(amount), tonumber(cid));
                end
                outputChatBox("#FFFF00★ #FFFFFFNadano punkty EXP dla CID "..cid.." ("..amount..") (Operacja została zapisana w logach RCON)",plr,0,0,0,true)
                exports["lss-admin"]:rconView_add("[EXP - CID (ADD)] Player "..getPlayerName(plr).." gived "..amount.." to CID "..cid)
            else
                outputChatBox("Nie prawidłowy format komendy", plr);
            end
        end
    end
end
addCommandHandler("add.expcid", addAccountEXP);

addCommandHandler("set.urlop", function(thePlayer, command, cid, number)
    if getElementData(thePlayer, "admin:rank") == "RCON" or getElementData(thePlayer, "admin:rank") == "Globaladministrator" then
        if cid and number and (tonumber(cid)) then
            exports["DB"]:prepareSet("UPDATE `cl_characters` SET `adminVacation` = `adminVacation` + INTERVAL ? DAY WHERE `CID` = ?", number, tonumber(cid))
            outputChatBox(" Nadano status zablokowanej rangi dla CID "..cid.." na "..number.." dni", thePlayer, 255, 255, 255);
            exports["lss-admin"]:rconView_add("[SET URLOP] "..getPlayerName(thePlayer).." ustawil urlop dla CID "..cid.." na "..number.." dni")

            return true;
        end
    end
end)

addCommandHandler("wolne.modele", function(plr, command)
    if getElementData(plr, "admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
    local idPojazdow = {400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415,
	416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433,
	434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451,
	452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469,
	470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487,
	488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505,
	506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523,
	524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541,
	542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559,
	560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577,
	578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595,
	596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611 }
    local empty_models = {}
    for i,v in ipairs(idPojazdow) do
        local result = exports["DB"]:pobierzTabeleWynikow("SELECT id, model FROM cl_vehicles WHERE model="..v)
        if not result or #result == 0 then
            table.insert(empty_models, v)
        end
    end
    for i,v in ipairs(empty_models) do
        outputChatBox(getVehicleNameFromModel(v), plr)
    end
    empty_models = {}
    end
end)



addCommandHandler("set.opis", function(plr, cmd, ...)
    if plr and getElementData(plr, "admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
        if ... then
            local opis = table.concat({...}," ")
            setGameType(opis)
            setMapName(opis)
            exports['lss-admin']:rconView_add("[OPIS-SERWERA] "..getPlayerName(plr).." >> "..opis)
        end
    end
end)


addCommandHandler("set.email", function(plr, cmd, cid, email)
    if plr then
        if getElementData(plr, "admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
            if cid and tonumber(cid) and email then
                local result = exports['DB']:pobierzTabeleWynikow("SELECT nick FROM cl_characters WHERE CID = ? LIMIT 1", cid)
                if result and #result == 1 then
                    exports['DB']:zapytanie("UPDATE cl_characters SET email = ? WHERE CID = ?", email, cid)
                    exports['lss-admin']:rconView_add("[SET-EMAIL] "..getPlayerName(plr).." cid: "..cid.." na: "..email)
                    outputChatBox("Zmieniono email gracza "..result[1].nick.." na "..email..".", plr, 255,255,255)
                end
            end
        end
    end
end)


addCommandHandler("set.serial", function(plr, cmd, cid, serial)
    if plr then
        if getElementData(plr, "admin:rank") == "RCON" or getElementData(plr, "admin:rank") == "Globaladministrator" then
            if cid and tonumber(cid) and serial and string.len(serial) == 32 then
                local result = exports['DB']:pobierzTabeleWynikow("SELECT nick FROM cl_characters WHERE CID = ? LIMIT 1", cid)
                if result and #result == 1 then
                    exports['DB']:zapytanie("UPDATE cl_characters SET serial = ? WHERE CID = ?", serial, cid)
                    exports['lss-admin']:rconView_add("[SET-SERIAL] "..getPlayerName(plr).." cid: "..cid.." na: "..serial)
                    outputChatBox("Zmieniono email gracza "..result[1].nick.." na "..serial..".", plr, 255,255,255)
                end
            end
        end
    end
end)

--[[
local allowedUsers = {
    [22593] = true;
    [15147] = true;
}

function resourceManage(player, command, resource)
    if(player) and (allowedUsers[getElementData(player, "CID")])then 
        if(command) == ("rs.refresh")then 
            if(refreshResources(true))then 
                outputChatBox("Przeładowano listę zasobów", player, 255,255,255) 
            end
        else
            if(resource) and (tostring(resource)) and (string.find(resource, "temp"))then 
                if(getResourceFromName(resource))then 
                    if(string.find(command, "start"))then 
                        if(startResource(getResourceFromName(resource)))then 
                            outputChatBox("Wystartowano zasób "..resource, player, 255,255,255) 
                        end
                    elseif(string.find(command, "restart"))then
                        if(restartResource(getResourceFromName(resource)))then 
                            outputChatBox("Przeładowano zasób "..resource, player, 255,255,255) 
                        end
                    elseif(string.find(command, "stop"))then
                        if(stopResource(getResourceFromName(resource)))then 
                            outputChatBox("Zatrzymano zasób "..resource, player, 255,255,255) 
                        end
                    end
                else
                    outputChatBox("Odrzucono polecenie. Nie znaleziono zasobu", player, 255,255,255) 
                end
            else
                outputChatBox("Odrzucono polecenie. Brak uprawnień", player, 255,255,255)
            end
        end
    else
        outputChatBox("Odrzucono polecenie. Brak uprawnień", player, 255,255,255)
    end
    return false
end
addCommandHandler("rs.start", resourceManage); addCommandHandler("rs.restart", resourceManage); addCommandHandler("rs.stop", resourceManage); addCommandHandler("rs.refresh", resourceManage); addCommandHandler("rs.db3", resourceManage);]]