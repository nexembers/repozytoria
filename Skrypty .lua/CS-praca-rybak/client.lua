--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

local font = exports["CS-fonts"]:font("main")

local sw,sh = guiGetScreenSize()
local zoom = 1
if sw < 1920 then zoom = math.min(1.25,1920/sw) end -- domyślny

local czcionka = dxCreateFont('normal.ttf', 11/zoom)
local czcionka2 = dxCreateFont('normal.ttf', 17/zoom)
local wybor=nil
local elements = {}
local data = nil
local config = nil
local aktualny = getTickCount()

function isEventHandlerAdded(sEventName,pElementAttachedTo,func)
	if type(sEventName)=='string' and isElement(pElementAttachedTo) and type(func)=='function' then local aAttachedFunctions = getEventHandlers(sEventName,pElementAttachedTo)
	if type(aAttachedFunctions)=='table' and #aAttachedFunctions > 0 then for i,v in ipairs(aAttachedFunctions) do if v==func then return true end end end end return false
end

local cost = 5

local info = {
	["text"]="\nPraca rybaka polega na połowie ryb.\nW pracy nie trzeba posiadać żadnych umiejętności\npoza swobodą ruchu oraz siłą, która jest\ngłównym atutem w pracy.\n\nAby rozpocząć połów ryb, musisz zakupić przynęty.\nPo złowieniu ryby, możesz ją sprzedać\nw chacie u rybaka.\n\nWynagrodzenie zależne jest od ilości \nzłowionych ryboraz typu złowionych ryb.",
	["przynety"]="W tym miejscu możesz zakupić przynęty, które są niezbędne do rozpoczęcia połowu ryb.\nPo wyjściu z serwera przynęty zapisują się i wczytują po rozpoczęciu pracy.\nNadmiaru zakupionych przynęt nie można sprzedać!",
	["ryby"]="W tym miejscu możesz sprzedać ryby, jeśli tak owe posiadasz.\nRyby są posegregowane w kolejności od najtańszej, do najdrożdzej.",
}



function checkButtons()
	if (#elements>0) then
		for _,v in ipairs(elements) do if v and isElement(v) then destroyElement(v) end end
	end
end

function checkposition(arg1,arg2,arg3,arg4)
	local x,y = getCursorPosition()
	if not x then return end
	if x*sw >= arg1 and y*sh <= arg2+arg4 and x*sw <= arg1+arg3 and y*sh >= arg2 then return true else return false end
end

function showButtons()
	checkButtons()
	if (wybor==1) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+300/zoom,sh/2-(19/2)/zoom-146.25/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateButton(sw/2-(200/2)/zoom+133/zoom,sh/2-(40/2)/zoom+135/zoom,200/zoom,40/zoom,"off",false) guiSetAlpha(elements[2],0)
	elseif (wybor==2) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+300/zoom,sh/2-(19/2)/zoom-146.25/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateEdit(sw/2-(175/2)/zoom,sh/2-(35/2)/zoom+45/zoom,175/zoom,35/zoom,"",false) guiSetAlpha(elements[2],0.75)
		elements[3] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+135/zoom,200/zoom,40/zoom,"przynety[2]",false) guiSetAlpha(elements[3],0)
		guiEditSetMaxLength(elements[2],3)
	elseif (wybor==3) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+300/zoom,sh/2-(19/2)/zoom-146.25/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+135/zoom,200/zoom,40/zoom,"sell[3]",false) guiSetAlpha(elements[2],0)
	end
end

function onRender()
	local x,y = getCursorPosition()
	if (wybor==1) then
		dxDrawImage(sw/2-(650/2)/zoom,sh/2-(350/2)/zoom,650/zoom,350/zoom,"images/main.png", 0, 0, 0, 0xFF878787)

		if checkposition(sw/2-(19/2)/zoom+300/zoom,sh/2-(19/2)/zoom-146.25/zoom,19/zoom,19/zoom) then a=255 else a=120 end
		dxDrawImage(sw/2-(19/2)/zoom+300/zoom,sh/2-(19/2)/zoom-146.25/zoom,19/zoom,19/zoom,"images/close.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil
--sw/2-(19/2)/zoom+300/zoom,sh/2-(19/2)/zoom-146.25/zoom,19/zoom,19/zoom
		dxDrawText("RYBAK",sw/2-302/zoom,sh/2-155/zoom,sw/2-188/zoom,sh/2-140/zoom,tocolor(255,255,255,200),1/zoom,czcionka2,"left","center")

		dxDrawText(info.text,sw/2+133/zoom,sh/2-125/zoom,sw/2+133/zoom,sh/2-125/zoom,tocolor(255,255,255,200),1.00/zoom,czcionka,"center","top",false,false,false,true)

		if elements[2] and isElement(elements[2]) then
			local sx,sy = guiGetPosition(elements[2],false)
			local sizex,sizey = guiGetSize(elements[2],false)
			if checkposition(sw/2-(200/2)/zoom+133/zoom,sh/2-(40/2)/zoom+135/zoom,200/zoom,40/zoom) then a=220 else a=120 end
			dxDrawImage(sw/2-(200/2)/zoom+133/zoom,sh/2-(40/2)/zoom+135/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))
			if getElementData(localPlayer,"player:job") then
				if getElementData(localPlayer,"player:job") == "rybak" then
					dxDrawText("ZAKOŃCZ PRACĘ!",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),1.00/zoom,czcionka,"center","center")
					if guiGetText(elements[2]) ~= "zakoncz[1]" then guiSetText(elements[2],"zakoncz[1]") end
				else
					dxDrawText("Tu nie zakończysz swojej\npracy!",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),1.00/zoom,czcionka,"center","center")
					if guiGetText(elements[2]) ~= "brak niestety[1]" then guiSetText(elements[2],"brak niestety[1]") end
				end
			else
				dxDrawText("ROZPOCZNIJ PRACĘ!",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),1.00/zoom,czcionka,"center","center")
				if guiGetText(elements[2]) ~= "pracuj[1]" then guiSetText(elements[2],"pracuj[1]") end
			end
		end a=nil
	elseif (wybor==2) then
		dxDrawImage(sw/2-(650/2)/zoom,sh/2-(350/2)/zoom,650/zoom,350/zoom,"images/main2.png",0,0,0,0xFF878787)

		if checkposition(sw/2-(19/2)/zoom+300/zoom,sh/2-(19/2)/zoom-146.25/zoom,19/zoom,19/zoom) then a=255 else a=120 end
		dxDrawImage(sw/2-(19/2)/zoom+300/zoom,sh/2-(19/2)/zoom-146.25/zoom,19/zoom,19/zoom,"images/close.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		dxDrawText("KUPNO PRZYNĘT",sw/2,sh/2-148/zoom,sw/2,sh/2-148/zoom,tocolor(255,255,255,230),1.05/zoom,czcionka,"center","center")
		dxDrawText(info.przynety,sw/2,sh/2-115/zoom,sw/2,sh/2-115/zoom,tocolor(255,255,255,230),1.00/zoom,czcionka,"center","top",false,false,false,true)

		dxDrawText("Wpisz ilość przynęt do zakupu",sw/2,sh/2,sw/2,sh/2,tocolor(255,255,255,230),1.00/zoom,czcionka,"center","top",false,false,false,true)
		dxDrawText("#0553cc★#FFFFFF Aktualnie posiadasz #0553cc"..config.przynety.."#FFFFFF przynęt.",sw/2,sh/2-38/zoom,sw/2,sh/2-38/zoom,tocolor(255,255,255,230),1.00/zoom,czcionka,"center","top",false,false,false,true)

		if elements[3] and isElement(elements[3]) then
			local sx,sy = guiGetPosition(elements[3],false)
			local sizex,sizey = guiGetSize(elements[3],false)
			if checkposition(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+135/zoom,200/zoom,40/zoom) then a=255 else a=120 end
			dxDrawImage(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+135/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))
			dxDrawText("ZAKUP PRZYNĘTY!",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),1.00/zoom,czcionka,"center","center")
		end a=nil

		local text = guiGetText(elements[2])
		if text and tonumber(text) and tonumber(text)>0 and tonumber(text)<=1000 then
			guiSetText(elements[2],math.floor(text))
			dxDrawText("Cena #0553cc"..text.."#FFFFFF przynęt wynosi #008000"..tonumber(text)*cost..".00 PLN#FFFFFF.",sw/2,sh/2+85/zoom,sw/2,sh/2+85/zoom,0xFF878787,1.1/zoom,czcionka,"center","center",false,false,false,true)
		else
			if string.len(text)>0 then
				dxDrawText("#FF0000Wpisz poprawną ilość przynęt!",sw/2,sh/2+85/zoom,sw/2,sh/2+85/zoom,0xFF878787,1.1/zoom,czcionka,"center","center",false,false,false,true)
			end
		end
	elseif (wybor==3) then
		dxDrawImage(sw/2-(650/2)/zoom,sh/2-(350/2)/zoom,650/zoom,350/zoom,"images/main2.png",0,0,0,0xFF878787)

		if checkposition(sw/2-(19/2)/zoom+300/zoom,sh/2-(19/2)/zoom-146.25/zoom,19/zoom,19/zoom) then a=255 else a=120 end
		dxDrawImage(sw/2-(19/2)/zoom+300/zoom,sh/2-(19/2)/zoom-146.25/zoom,19/zoom,19/zoom,"images/close.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		dxDrawText("SPRZEDAŻ RYB",sw/2,sh/2-148/zoom,sw/2,sh/2-148/zoom,tocolor(255,255,255,230),1.05/zoom,czcionka,"center","center")
		dxDrawText(info.ryby,sw/2,sh/2-115/zoom,sw/2,sh/2-115/zoom,tocolor(255,255,255,230),1.00/zoom,czcionka,"center","top",false,false,false,true)

		for _,v in ipairs(data) do
			dxDrawText("Aktualnie posiadane ryby:\n\nKaraś: #0553cc"..string.format("%.02f",v["karas"]).." kg#FFFFFF\nKarp: #0553cc"..string.format("%.02f",v["karp"]).." kg#FFFFFF\nDorsz: #0553cc"..string.format("%.02f",v["dorsz"]).." kg#FFFFFF\nŁosoś: #0553cc"..string.format("%.02f",v["losos"]).." kg#FFFFFF\nHalibut: #0553cc"..string.format("%.02f",v["halibut"]).." kg#FFFFFF\nWęgorz: #0553cc"..string.format("%.02f",v["wegorz"]).." kg#FFFFFF\nSzczupak: #0553cc"..string.format("%.02f",v["szczupak"]).." kg#FFFFFF",sw/2,sh/2-65/zoom,sw/2,sh/2-65/zoom,tocolor(255,255,255,230),1.00/zoom,czcionka,"center","top",false,false,false,true)
		end

		if elements[2] and isElement(elements[2]) then
			local sx,sy = guiGetPosition(elements[2],false)
			local sizex,sizey = guiGetSize(elements[2],false)
			if checkposition(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+135/zoom,200/zoom,40/zoom) then a=255 else a=120 end
			dxDrawImage(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+135/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))
			dxDrawText("SPRZEDAJ RYBY!",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),1.00/zoom,czcionka,"center","center")
		end a=nil
	elseif (wybor==50) then
		zapisany = config.time
		aktualny = math.abs(config.savetime-getTickCount())
		if not zapisany or not aktualny then outputChatBox("brak") return end

		iloraz = aktualny/zapisany
		if iloraz>1 then iloraz=1 end
		dxDrawImage(sw/2-(476/2)/zoom,sh/2-(28/2)/zoom-1/zoom+250/zoom,476/zoom,28/zoom,"images/back.png",0,0,0,0xFF878787)
		dxDrawImageSection(sw/2-(476/2)/zoom,sh/2-(28/2)/zoom-1/zoom+250/zoom,476/zoom*iloraz,28/zoom, 0,0,476/zoom*iloraz,28/zoom,"images/front.png",0,0,0,0xFF878787)

		dxDrawText("Trwa połów ( "..math.floor(iloraz*100).."% )",sw/2+1.00/zoom,sh/2+251/zoom+1.00/zoom,sw/2+1.00/zoom,sh/2+248/zoom+1.00/zoom,tocolor(0,0,0,255),1/zoom,czcionka,"center","center",false,false,false,true)
		dxDrawText("Trwa połów ( "..math.floor(iloraz*100).."% )",sw/2+1.00/zoom,sh/2+251/zoom-1.00/zoom,sw/2+1.00/zoom,sh/2+248/zoom-1.00/zoom,tocolor(0,0,0,255),1/zoom,czcionka,"center","center",false,false,false,true)
		dxDrawText("Trwa połów ( "..math.floor(iloraz*100).."% )",sw/2-1.00/zoom,sh/2+251/zoom+1.00/zoom,sw/2-1.00/zoom,sh/2+248/zoom+1.00/zoom,tocolor(0,0,0,255),1/zoom,czcionka,"center","center",false,false,false,true)
		dxDrawText("Trwa połów ( "..math.floor(iloraz*100).."% )",sw/2-1.00/zoom,sh/2+251/zoom-1.00/zoom,sw/2-1.00/zoom,sh/2+248/zoom-1.00/zoom,tocolor(0,0,0,255),1/zoom,czcionka,"center","center",false,false,false,true)

		dxDrawText("Trwa połów ( "..math.floor(iloraz*100).."% )",sw/2,sh/2+251/zoom,sw/2,sh/2+248/zoom,0xFFE1E1E1,1/zoom,czcionka,"center","center",false,false,false,true)
	end
end

addEventHandler("onClientGUIClick",resourceRoot,function()
	local text = guiGetText(source)
	if (text=="close[1]") then
		showGUI(localPlayer,"ukryj")
	elseif (text=="pracuj[1]") then
		if not getElementData(localPlayer,"player:job") then
			--if getElementData(localPlayer,"admin:rank")~="RCON" then outputChatBox("Praca jest w trakcie tworzenia!") return end
			triggerServerEvent("CS:praca:rybak:server",localPlayer,localPlayer,"przynety")
		else
			outputChatBox("#FF0000★ #FFFFFFPosiadasz już gdzie indziej rozpoczętą pracę!",0,0,0,true)
		end
	elseif (text=="zakoncz[1]") then
		if getElementData(localPlayer,"player:job") and getElementData(localPlayer,"player:job") == "rybak" then
			statusJob(localPlayer,"zakoncz")
			triggerServerEvent("CS:praca:rybak:server",localPlayer,localPlayer,"zakoncz")
		else
			outputChatBox("#FF0000★ #FFFFFFNie możesz w tym miejscu zakończyć swojej pracy!",0,0,0,true)
		end
	elseif (text=="przynety[2]") then
		local text = guiGetText(elements[2])
		if text and tonumber(text) and tonumber(text)>0 and tonumber(text)<=1000 then
			local count,cost = tonumber(text),tonumber(text)*tonumber(cost)
			if count and cost then
				if getPlayerMoney()<cost then
					outputChatBox("#FF0000★ #FFFFFFNie posiadasz wystarczającej ilości pieniędzy na swoim koncie, aby móc zakupić daną ilość przynęt!",0,0,0,true)
					return
				end
				if timer and isTimer(timer) then return end
				timer = setTimer(function() timer=nil end,5000,1)

				triggerServerEvent("CS:praca:rybak:server",localPlayer,localPlayer,"buy-przynety",{count,cost})
			end
		end
	elseif (text=="sell[3]") then
		if timersell and isTimer(timersell) then outputChatBox("#FF0000★ #FFFFFFPoczekaj chwilę przed kolejną próbą sprzedaży ryb!",0,0,0,true) return end
		timersell = setTimer(function() timersell=nil end,15000,1)
		triggerServerEvent("CS:praca:rybak:server",localPlayer,localPlayer,"sprzedazryb")
		showGUI(localPlayer,"ukryj")
	end
end)

function showGUI(plr,typ,dane)
	if plr and isElement(plr) then
		if (typ=="pokaz") then
			if dane then
				data=dane
			end
			wybor=1
			showCursor(true)
			showButtons()
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
		elseif (typ=="ukryj") then
			if isEventHandlerAdded("onClientRender",root,onRender) then
				removeEventHandler("onClientRender",root,onRender)
			end
			showCursor(false)
			checkButtons()
			wybor,data=nil,nil
		elseif (typ=="przynety-wczytaj") then
			if dane and tonumber(dane) then
				if not config then config={} end
				config.przynety = tonumber(dane)
				config.city = data
				statusJob(plr,"rozpocznij")
			end
		elseif (typ=="kupnoprzynet") then
			if dane then
				if not config then return end
				config.przynety = tonumber(dane)
			end
			wybor=2
			showCursor(true)
			showButtons()
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
		elseif (typ=="actualing-przynety") then
			if dane then
				if not config then outputChatBox("Wystąpił błąd!") end
				config.przynety = config.przynety + dane
			end
			showGUI(plr,"ukryj")
		elseif (typ=="sprzedazryb") then
			if dane then
				data=dane
			end
			wybor=3
			showCursor(true)
			showButtons()
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
		elseif (typ=="next-point") then
			if not config then return end
			if dane then
				config.przynety = dane
				outputChatBox("      #FFFF00★ #FFFFFFAktualnie posiadasz "..config.przynety.." przynęt.",0,0,0,true)
			end
			if isEventHandlerAdded("onClientRender",root,onRender) then
				removeEventHandler("onClientRender",root,onRender)
			end
			statusJob(plr,"pokazpunkt")
		end
	end
end
addEvent("CS:praca:rybak:client",true)
addEventHandler("CS:praca:rybak:client",root,showGUI)

function stopJob(plr)
	if plr and isElement(plr) then
		if not config then return end
		if config.point and isElement(config.point) then destroyElement(config.point) config.point=nil end
		if config.pointrot and tonumber(config.pointrot) then config.pointrot=nil end
		if config.city and isElement(config.point) then destroyElement(config.point) config.point=nil end
		if config.blip and isElement(config.blip) then destroyElement(config.blip) config.blip=nil end
		if config.shape and isElement(config.shape) then destroyElement(config.shape) config.shape=nil end
		if config.przynety and tonumber(config.przynety) then config.przynety=nil end
		if config.time and tonumber(config.time) then config.time=nil end
		config=nil
		for k,v in ipairs(getElementsByType("player")) do
			setElementCollidableWith(plr, v,true)
		end
	end
end

function checkPoints(plr)
	if plr and isElement(plr) then
		if config.point and isElement(config.point) then destroyElement(config.point) config.point=nil end
		if config.pointrot and tonumber(config.pointrot) then config.pointrot=nil end
		if config.blip and isElement(config.blip) then destroyElement(config.blip) config.blip=nil end
		if config.shape and isElement(config.shape) then destroyElement(config.shape) config.shape=nil end
		if config.time and tonumber(config.time) then config.time=nil end
	end
end

function statusJob(plr,typ,data)
	if plr and isElement(plr) then
		if (typ=="rozpocznij") then
			if not config then config={} end

			if config.city then
				exports["CS-powiadomienia"]:powiadomienie(plr,{"info","Rozpoczęto pracę.\nZakup przynęty i udaj się do\nmiejsca połowu ryb."})
				showGUI(plr,"ukryj")
				setElementData(plr,"player:job","rybak")
				for k,v in ipairs(getElementsByType("player")) do
					setElementCollidableWith(localPlayer, v,false)
				end
				statusJob(plr,"pokazpunkt")
			else
				outputChatBox("Wystąpił błąd!")
			end
		elseif (typ=="zakoncz") then
			stopJob(plr)
			setElementData(plr,"player:job",nil)
			showGUI(plr,"ukryj")
			exports["CS-powiadomienia"]:powiadomienie(plr,{"info","Zakończono pracę."})
		elseif (typ=="pokazpunkt") then
			checkPoints(plr)
			if not config then stopJob(plr) outputChatBox("Praca zakończona - błąd 1!") return end
			if not config.przynety then stopJob(plr) outputChatBox("Praca zakończona - błąd 2!")  return end
			local rnd = math.random(1,#points[config.city])
			config.point = createMarker(points[config.city][rnd][1],points[config.city][rnd][2],points[config.city][rnd][3]-1,"cylinder",1.25,0,100,200,55)
			config.shape = createColSphere(points[config.city][rnd][1],points[config.city][rnd][2],points[config.city][rnd][3]-1,90)
			config.pointrot = points[config.city][rnd][4]
			config.blip = createBlip(points[config.city][rnd][1],points[config.city][rnd][2],points[config.city][rnd][3]-1,41,2,255,0,0,150,0,9999)
			config.time,config.savetime=nil,nil
		end
	end
end

addEventHandler("onClientMarkerHit",resourceRoot,function(plr,dim)
	if plr and isElement(plr) and plr==localPlayer and dim then
		if not config then return end
		if not config.point then return end
		if getPedOccupiedVehicle(plr) then return end
		if source==config.point then
			if config.przynety<1 then outputChatBox("#FF0000★ #FFFFFFNie posiadasz wystarczającej ilości przynęt!",0,0,0,true) return end
			if timerlos and isTimer(timerlos) then return end
			timerlos = setTimer(function() timerlos=nil end,6000,1)
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				config.time=math.random(6000,15000)
				config.savetime=getTickCount()
				addEventHandler("onClientRender",root,onRender)
				wybor=50
			end

			triggerServerEvent("CS:praca:rybak:server",localPlayer,localPlayer,"losing",{config.pointrot,config.time})
		end
	end
end)

addEventHandler("onClientPlayerWasted",root,function()
	if source == localPlayer then
		stopJob(source)
		showGUI(source,"ukryj")
		triggerServerEvent("CS:praca:rybak:server",source,source,"zakonczprace")
	end
end)

addEventHandler("onClientColShapeLeave",resourceRoot,function(plr)
	if plr and isElement(plr) and plr == localPlayer then
		if source==config.shape then
			if getElementData(plr,"player:job") then
				stopJob(plr)
				showGUI(plr,"ukryj")
				triggerServerEvent("CS:praca:rybak:server",plr,plr,"zakonczprace")
				outputChatBox("#FF0000★ #FFFFFFOddalono się od miejsca przeznaczonego do połowu ryb! Praca została #FF0000zakończona#FFFFFF.",0,0,0,true)
			end
		end
	end
end)
