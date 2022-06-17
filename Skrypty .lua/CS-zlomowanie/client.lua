--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

local font = exports["CS-fonts"]:font("main")
local sw,sh = guiGetScreenSize()
local wybor=nil
local data=nil
local elements = {}

function isEventHandlerAdded(sEventName,pElementAttachedTo,func)
	if type(sEventName)=='string' and isElement(pElementAttachedTo) and type(func)=='function' then local aAttachedFunctions = getEventHandlers(sEventName,pElementAttachedTo)
	if type(aAttachedFunctions)=='table' and #aAttachedFunctions > 0 then for i,v in ipairs(aAttachedFunctions) do if v==func then return true end end end end return false
end

local zoom = 1
if sw < 1920 then zoom = math.min(1.25,1920/sw) end -- domyślny

function checkButtons()
	if (#elements>0) then
		for _,v in ipairs(elements) do if v and isElement(v) then destroyElement(v) end end
	end
end

function showButtons()
	checkButtons()
	if (wybor==1) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+136/zoom,sh/2-(19/2)/zoom-160/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+150/zoom,200/zoom,40/zoom,"destroy[1]",false) guiSetAlpha(elements[2],0)
	elseif (wybor==2) then
		
	end
end

function onRender()
	local x,y = getCursorPosition()
	if (wybor==1) then
		dxDrawImage(sw/2-(320/2)/zoom,sh/2-(370/2)/zoom,320/zoom,370/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		
		dxDrawText("ZŁOMOWANIE",sw/2,sh/2-160/zoom,sw/2,sh/2-160/zoom,tocolor(255,255,255,200),0.55/zoom,font,"center","center")
		
		if x*sw >= sw/2-(19/2)/zoom+136/zoom and y*sh <= sh/2-(19/2)/zoom-160/zoom+19/zoom and x*sw <= sw/2-(19/2)/zoom+136/zoom+19/zoom and y*sh >= sh/2-(19/2)/zoom-160/zoom then a = 255 else a = 255 * 0.4 end
		dxDrawImage(sw/2-(19/2)/zoom+136/zoom,sh/2-(19/2)/zoom-160/zoom,19/zoom,19/zoom,"images/close.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil
		
		if elements[2] and isElement(elements[2]) then
			local sx,sy = guiGetPosition(elements[2],false)
			local sizex,sizey = guiGetSize(elements[2],false)
			if x*sw >= sw/2-(200/2)/zoom and y*sh <= sh/2-(40/2)/zoom+150/zoom+40/zoom and x*sw <= sw/2-(200/2)/zoom+200/zoom and y*sh >= sh/2-(40/2)/zoom+150/zoom then a = 220 else a = 255 * 0.4 end
			dxDrawImage(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+150/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))
			dxDrawText("Zezłomuj pojazd",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.35/zoom,font,"center","center")
		end a=nil
		
		if data then
			dxDrawText("W tym miejscu możesz zezłomować\npojazd marki #81b1d3"..getVehicleNameFromModel(data[2]).."#FFFFFF.\n\nPamiętaj, że pojazd zostanie\ncałkowicie usunięty!\n\nPamiętaj również, aby przed zezłomowaniem\npojazdu ściągnąć tuning wizualny,\nmechaniczny i inne komponenty.\n\nZa zezłomowanie pojazdu otrzymasz\n#81b1d3"..(data[3] or 0)..".00 PLN#FFFFFF.\n\nPrzed podjęciem decyzji, #81b1d3zastanów się#FFFFFF!",sw/2,sh/2-125/zoom,sw/2,sh/2-125/zoom,tocolor(255,255,255,220),0.33/zoom,font,"center","top",false,false,false,true)
		end
		
	elseif (wybor==2) then
		
	end
end

addEventHandler("onClientGUIClick",resourceRoot,function()
	local text = guiGetText(source)
	if (text=="close[1]") then
		triggerEvent("CS:zlomowaniepojazdow:client",localPlayer,localPlayer,"ukryj")
	elseif (text=="destroy[1]") then
		if getPedOccupiedVehicle(localPlayer) then
			
			if not times then times=0 end
			if timer and isTimer(timer) then killTimer(timer) end
			timer = setTimer(function()
				if getPedOccupiedVehicle(localPlayer) then
					if times<3 then
						triggerEvent("CS:powiadomienie",localPlayer,localPlayer,{"info","Cieszymy się, że zrezygnowałeś\nze złomowania pojazdu."})
					end
				end
				times=nil
			end,6000,1)
			times = times+1
			if times>=3 then
				if timer5 and isTimer(timer5) then outputChatBox("Poczekaj!",255,0,0,true) return end
				timer5 = setTimer(function() end,15000,1)
				triggerServerEvent("CS:zlomowaniepojazdow:server",localPlayer,localPlayer,"zlomowanie",{data[1],data[2],data[3]})
			else
				triggerEvent("CS:powiadomienie",localPlayer,localPlayer,{"info","Aby zezłomować pojazd,\nprzyciśnij przycisk!\n\n#81b1d3( "..times.."/3 )"})
			end
		end
	end
end)

addEvent("CS:zlomowaniepojazdow:client",true)
addEventHandler("CS:zlomowaniepojazdow:client",root,function(plr,typ,dane)
	if plr and isElement(plr) then
		if (typ=="pokaz") then
			wybor=1
			data=dane
			showCursor(true)
			showButtons()
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
		elseif (typ=="ukryj") then
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
			showCursor(false)
			checkButtons()
			wybor=nil
			data=nil
		end
	end
end)