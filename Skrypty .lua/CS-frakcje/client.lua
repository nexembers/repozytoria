--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

local sw,sh = guiGetScreenSize()
local elements = {}

local zoom = 1
if sw < 1920 then zoom = math.min(1.5,1920/sw) end -- domyślny

function onRender()
	local x,y = getCursorPosition()

	if (wybor==1) then
		dxDrawImage(sw/2-(500/2)/zoom,sh/2-(300/2)/zoom,500/zoom,300/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		dxDrawText("PANEL SŁUŻBY",sw/2,sh/2-125/zoom,sw/2,sh/2-125/zoom,tocolor(255,255,255,255),1.5/zoom,"default-bold","center","center")

		if x*sw >= sw/2-(200/2)/zoom and y*sh <= sh/2-(40/2)/zoom+110/zoom+40/zoom and x*sw <= sw/2-(200/2)/zoom+200/zoom and y*sh >= sh/2-(40/2)/zoom+110/zoom then a = 255 else a = 255 * 0.4 end
		if elements[1] and isElement(elements[1]) then
			local sx,sy = guiGetPosition(elements[1],false)
			local sizex,sizey = guiGetSize(elements[1],false)
			dxDrawImage(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+110/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))
			if getElementData(localPlayer,"frakcja:S1") then
				dxDrawText("ZAKOŃCZ SŁUŻBĘ",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),1.35/zoom,"default-bold","center","center")
				dxDrawText("Obecna frakcja: #81b1d3"..(getElementData(localPlayer,"frakcja") or "- - -").."#FFFFFF.\nObecna ranga we frakcji: #81b1d3"..(getElementData(localPlayer,"frakcja:ranga") or "Brak").."#FFFFFF.\n\nObecnie posiadasz #81b1d3"..(getElementData(localPlayer,"frakcja:minuty") or 0).." przepracowanych minut #FFFFFFwe frakcji.\nJeśli uważasz, że potrzebujesz odpoczynku,\nzakończ służbę aby nie zostać ukaranym!\n\nPamiętaj o zastosowaniu się do wytycznych regulaminu frakcji!",sw/2,sh/2-25/zoom,sw/2,sh/2-25/zoom,tocolor(255,255,255,255),1.25/zoom,"default","center","center",false,false,false,true)
			else
				dxDrawText("ROZPOCZNIJ SŁUŻBĘ",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),1.35/zoom,"default-bold","center","center")
				dxDrawText("Obecna frakcja: #81b1d3"..(getElementData(localPlayer,"frakcja") or "- - -").."#FFFFFF.\nObecna ranga we frakcji: #81b1d3"..(getElementData(localPlayer,"frakcja:ranga") or "Brak").."#FFFFFF.\n\nObecnie posiadasz #81b1d3"..(getElementData(localPlayer,"frakcja:minuty") or 0).." przepracowanych minut #FFFFFFwe frakcji.\nPamiętaj, aby przed rozpoczęciem służby\nzapoznać się z regulaminem frakcji!",sw/2,sh/2-25/zoom,sw/2,sh/2-25/zoom,tocolor(255,255,255,255),1.25/zoom,"default","center","center",false,false,false,true)
			end
		end a=nil

		if x*sw >= sw/2-(19/2)/zoom+222/zoom and y*sh <= sh/2-(19/2)/zoom-122/zoom+19/zoom and x*sw <= sw/2-(19/2)/zoom+222/zoom+19/zoom and y*sh >= sh/2-(19/2)/zoom-122/zoom then a = 255 else a = 255 * 0.4 end
		if elements[2] and isElement(elements[2]) then
			dxDrawImage(sw/2-(19/2)/zoom+222/zoom,sh/2-(19/2)/zoom-122/zoom,19/zoom,19/zoom,"images/close.png",0,0,0,tocolor(255,255,255,a or 255))
		end a=nil
	elseif (wybor==2) then
		dxDrawImage(sw/2-(500/2)/zoom,sh/2-(300/2)/zoom,500/zoom,300/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		dxDrawText("WYPŁATA Z FRAKCJI",sw/2,sh/2-125/zoom,sw/2,sh/2-125/zoom,tocolor(255,255,255,255),1.75/zoom,"default-bold","center","center")

		if x*sw >= sw/2-(200/2)/zoom and y*sh <= sh/2-(40/2)/zoom+110/zoom+40/zoom and x*sw <= sw/2-(200/2)/zoom+200/zoom and y*sh >= sh/2-(40/2)/zoom+110/zoom then a = 255 else a = 255 * 0.4 end
		if elements[1] and isElement(elements[1]) then
			local sx,sy = guiGetPosition(elements[1],false)
			local sizex,sizey = guiGetSize(elements[1],false)
			dxDrawImage(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+110/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))
			dxDrawText("WYPŁAĆ ŚRODKI",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),1.5/zoom,"default=bold","center","center")
			dxDrawText("Obecna frakcja: #81b1d3"..(getElementData(localPlayer,"frakcja") or "- - -").."#FFFFFF.\nObecna ranga we frakcji: #81b1d3"..(getElementData(localPlayer,"frakcja:ranga") or "- - -").."#FFFFFF.\nObecnie posiadasz #81b1d3"..(getElementData(localPlayer,"frakcja:minuty") or 0).." przepracowanych minut #FFFFFFwe frakcji.\n\nJeśli uważasz, że chcesz wybrać swoje środki\nza przepracowane minuty na służbie, zrób to teraz!\n\nKwota zarobków jest adekwatna do zajmowanej we frakcji rangi.",sw/2,sh/2-10/zoom,sw/2,sh/2-10/zoom,tocolor(255,255,255,255),1.25/zoom,"default","center","center",false,false,false,true)
		end a=nil

		if x*sw >= sw/2-(19/2)/zoom+222/zoom and y*sh <= sh/2-(19/2)/zoom-122/zoom+19/zoom and x*sw <= sw/2-(19/2)/zoom+222/zoom+19/zoom and y*sh >= sh/2-(19/2)/zoom-122/zoom then a = 255 else a = 255 * 0.4 end
		if elements[2] and isElement(elements[2]) then
			local sx,sy = guiGetPosition(elements[2],false)
			local sizex,sizey = guiGetSize(elements[2],false)
			dxDrawImage(sw/2-(19/2)/zoom+222/zoom,sh/2-(19/2)/zoom-122/zoom,19/zoom,19/zoom,"images/close.png",0,0,0,tocolor(255,255,255,a or 255))
		end a=nil
	end
end

function checkButtons()
	for _,v in ipairs(elements) do
		if v and isElement(v) then
			destroyElement(v)
		end
	end
end

function showButtons()
	checkButtons()
	if (wybor==1) then
		if getElementData(localPlayer,"frakcja:S1") then
			elements[1] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+110/zoom,200/zoom,40/zoom,"zakoncz[1]",false) guiSetAlpha(elements[1],0)
		else
			elements[1] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+110/zoom,200/zoom,40/zoom,"rozpocznij[1]",false) guiSetAlpha(elements[1],0)
		end
		elements[2] = guiCreateButton(sw/2-(19/2)/zoom+222/zoom,sh/2-(19/2)/zoom-122/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[2],0)
	elseif (wybor==2) then
		elements[1] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+110/zoom,200/zoom,40/zoom,"wyplac[2]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateButton(sw/2-(19/2)/zoom+222/zoom,sh/2-(19/2)/zoom-122/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[2],0)
	end
end


addEventHandler("onClientGUIClick",resourceRoot,function()
	local text = guiGetText(source)
	if (text=="close[1]") then
		checkButtons()
		removeEventHandler("onClientRender",root,onRender)
		wybor=nil
		showCursor(false)
	elseif (text=="rozpocznij[1]") then
		triggerServerEvent("frakcja:etapySluzby",localPlayer,localPlayer,"rozpocznij")
		removeEventHandler("onClientRender",root,onRender)
		checkButtons()
		showCursor(false)
	elseif (text=="zakoncz[1]") then
		triggerServerEvent("frakcja:etapySluzby",localPlayer,localPlayer,"zakoncz")
		removeEventHandler("onClientRender",root,onRender)
		checkButtons()
		showCursor(false)
	elseif (text=="wyplac[2]") then
		triggerServerEvent("CS:frakcje:wyplata",localPlayer,localPlayer)
		removeEventHandler("onClientRender",root,onRender)
		checkButtons()
		showCursor(false)
	end
end)

addEvent("frakcja:showGUI:rozpoczecie",true)
addEventHandler("frakcja:showGUI:rozpoczecie",root,function(plr,info)
	if plr and isElement(plr) then
		if info then
			wybor=2
			showCursor(true)
			showButtons()
			addEventHandler("onClientRender",root,onRender)
			return
		end
		wybor=1
		showCursor(true)
		showButtons()
		addEventHandler("onClientRender",root,onRender)
	end
end)

addEvent("odtworzDzwiek:czatFrakcyjny",true)
addEventHandler("odtworzDzwiek:czatFrakcyjny",root,function(plr)
	if plr and isElement(plr) then
		playSound("frakcja.mp3")
	end
end)

addEvent("odtworzDzwiek:czatSluzbowy",true)
addEventHandler("odtworzDzwiek:czatSluzbowy",root,function(plr)
	if plr and isElement(plr) then
		playSound("sluzby.mp3")
	end
end)

local timetogetcp = 0;
local getNumber = 1;
setTimer(function()
	if getElementData(localPlayer,"frakcja") and getElementData(localPlayer,"frakcja:S1") then
		local nowTime = getRealTime();
		if(nowTime.hour) < (7) and (nowTime.hour) >= (0)then
			if(getNumber) == (1)then
				getNumber = 0;
			else getNumber = 1 end;
		else
			timetogetcp=timetogetcp+1
			if(getNumber) ~= (1)then getNumber = 1 end;
		end
		if(getNumber) and (tonumber(getNumber)) > (0)then
			setElementData(localPlayer,"frakcja:minuty",(getElementData(localPlayer,"frakcja:minuty") or 0) + getNumber);
			setElementData(localPlayer,"frakcja:minuty:week",(getElementData(localPlayer,"frakcja:minuty:week") or 0)+getNumber)
		end


		if timetogetcp==60 then
			timetogetcp=0
			outputChatBox("#FFFF00★ #FFFFFFUzyskano 15 dodatkowych punktów CP za godną podziwu pracę we frakcji!",0,0,0,true)
			setElementData(localPlayer,"calm:points",getElementData(localPlayer,"calm:points")+15)
		end
		return;
	end
end,60000,0) -- zwiekszyc na 60s
