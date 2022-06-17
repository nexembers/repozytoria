--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

local font = exports["CS-fonts"]:font("main")
local sw,sh = guiGetScreenSize()
local wybor=nil
local elements = {}
local data = nil
local vehicleData = {};

function isEventHandlerAdded(sEventName,pElementAttachedTo,func)
	if type(sEventName)=='string' and isElement(pElementAttachedTo) and type(func)=='function' then local aAttachedFunctions = getEventHandlers(sEventName,pElementAttachedTo)
	if type(aAttachedFunctions)=='table' and #aAttachedFunctions > 0 then for i,v in ipairs(aAttachedFunctions) do if v==func then return true end end end end return false
end

-- if elements[3] and isElement(elements[3]) then
	-- local sx,sy = guiGetPosition(elements[3],false)
	-- local sizex,sizey = guiGetSize(elements[3],false)
	-- if x*sw >= arg1 and y*sh <= arg2+arg4 and x*sw <= arg1+arg3 and y*sh >= arg2 then a = 255 else a = 255 * 0.4 end
	-- dxDrawText("",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.35,font,"center","center")
-- end a=nil

local zoom = 1
if sw < 1920 then zoom = math.min(1.25, 1920/sw) end -- domyślny

function checkButtons()
	if (#elements>0) then
		for _,v in ipairs(elements) do if v and isElement(v) then destroyElement(v) end end
	end
end

function showButtons()
	checkButtons()
	if (wybor==1) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+222/zoom,sh/2-(19/2)/zoom-122/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateComboBox(sw/2-(300/2)/zoom,sh/2-(30/2)/zoom-60/zoom,300/zoom,150,"Wybierz pojazd z listy",false) guiSetAlpha(elements[2],0.75)
		if data and #data>0 then
			local shape = data[1]
			local elementy = getElementsWithinColShape(shape,"vehicle")
			for _,v in ipairs(elementy) do
				if getElementData(v,"veh:dbid") then
					guiComboBoxAddItem(elements[2],"ID pojazdu: "..getElementData(v,"veh:dbid")..", marka: "..getVehicleName(v)..".")
				end
			end
		end
		elements[3] = guiCreateEdit(sw/2-(150/2)/zoom,sh/2-(35/2)/zoom,150/zoom,35/zoom,"",false) guiSetAlpha(elements[3],0.75)
		elements[4] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom,"wystaw[1]",false) guiSetAlpha(elements[4],0)
	elseif (wybor==2) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+222/zoom,sh/2-(19/2)/zoom-122/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateRadioButton(sw/2-(450/2)/zoom+10/zoom,sh/2-(40/2)/zoom-65/zoom,19/zoom,19/zoom, "radio[1]", false)
		elements[3] = guiCreateRadioButton(sw/2-(450/2)/zoom+10/zoom,sh/2-(40/2)/zoom-45/zoom,19/zoom,19/zoom, "radio[2]", false)
		elements[4] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom,"wystaw[1]",false) guiSetAlpha(elements[4],0)
	end
end

function checkPosition(arg1,arg2,arg3,arg4)
	local x,y = getCursorPosition()
	if not x then return end
	if x*sw >= arg1 and y*sh <= arg2+arg4 and x*sw <= arg1+arg3 and y*sh >= arg2 then return true else return false end
end

function onRender()
	local x,y = getCursorPosition()
	if (wybor==1) then
		if not data then return end
		dxDrawImage(sw/2-(500/2)/zoom,sh/2-(300/2)/zoom,500/zoom,300/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		dxDrawText("KOMIS - Nowy pojazd",sw/2,sh/2-125/zoom,sw/2,sh/2-125/zoom,tocolor(255,255,255,255),0.6/zoom,font,"center","center")

		if x*sw >= sw/2-(19/2)/zoom+222/zoom and y*sh <= sh/2-(19/2)/zoom-122/zoom+19/zoom and x*sw <= sw/2-(19/2)/zoom+222/zoom+19/zoom and y*sh >= sh/2-(19/2)/zoom-122/zoom then a = 255 else a = 255 * 0.4 end
		if elements[1] and isElement(elements[1]) then
			dxDrawImage(sw/2-(19/2)/zoom+222/zoom,sh/2-(19/2)/zoom-122/zoom,19/zoom,19/zoom,"images/close.png",0,0,0,tocolor(255,255,255,a or 255))
		end a=nil

		dxDrawText("Pojazd musi znajdować się na terenie komisu.",sw/2,sh/2-90/zoom,sw/2,sh/2-90/zoom,tocolor(255,255,255,230),0.4/zoom,font,"center","center")
		dxDrawText("Wpisz cenę, za którą chcesz wystawić pojazd.",sw/2,sh/2-33/zoom,sw/2,sh/2-33/zoom,tocolor(255,255,255,230),0.4/zoom,font,"center","center")

		dxDrawText("Upewnij się, że wpisane wyżej dane są podane prawidłowo.\nPojazd zostanie oznaczony opisem ze stanem technicznym.\nMożesz wystawić również pojazdy osób spoza komisu.",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(255,255,255,230),0.4/zoom,font,"center","center")

		if elements[4] and isElement(elements[4]) then
			local sx,sy = guiGetPosition(elements[4],false)
			local sizex,sizey = guiGetSize(elements[4],false)
			if checkPosition(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom) then a=230 else a=130 end
			dxDrawImage(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 230))
			dxDrawText("DALEJ",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.35/zoom,font,"center","center")
		end a=nil

	elseif (wybor==2) then
		
		dxDrawImage(sw/2-(500/2)/zoom,sh/2-(300/2)/zoom,500/zoom,300/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		dxDrawText("KOMIS - Nowy pojazd",sw/2,sh/2-125/zoom,sw/2,sh/2-125/zoom,tocolor(255,255,255,255),0.6/zoom,font,"center","center")

		if x*sw >= sw/2-(19/2)/zoom+222/zoom and y*sh <= sh/2-(19/2)/zoom-122/zoom+19/zoom and x*sw <= sw/2-(19/2)/zoom+222/zoom+19/zoom and y*sh >= sh/2-(19/2)/zoom-122/zoom then a = 255 else a = 255 * 0.4 end
		dxDrawImage(sw/2-(19/2)/zoom+222/zoom,sh/2-(19/2)/zoom-122/zoom,19/zoom,19/zoom,"images/close.png",0,0,0,tocolor(255,255,255,a or 255)); a = nil;

		if elements[4] and isElement(elements[4]) then
			local sx,sy = guiGetPosition(elements[4],false)
			local sizex,sizey = guiGetSize(elements[4],false)
			if checkPosition(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom) then a=230 else a=130 end
			dxDrawImage(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 230))
			dxDrawText("DALEJ",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.35/zoom,font,"center","center")
		end a=nil

		if(elements[2]) and (isElement(elements[2]))then 
			local sx,sy = guiGetPosition(elements[2],false)
			local sizex,sizey = guiGetSize(elements[2],false)
			dxDrawText("Możliwość sprzedaży offline",sx+30/zoom,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.35/zoom,font,"left","center")
		end

		if(elements[3]) and (isElement(elements[3]))then 
			local sx,sy = guiGetPosition(elements[3],false)
			local sizex,sizey = guiGetSize(elements[3],false)
			local offlineSelected = elements[2] and guiRadioButtonGetSelected(elements[2]);
			dxDrawText("Cena do negocjacji "..(offlineSelected and "(W przypadku offline, nie ma znaczenia)" or "(Tylko online)"),sx+30/zoom,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.35/zoom,font,"left","center")
		end
	end
end

local timer=nil
addEventHandler("onClientGUIClick",resourceRoot,function()
	local text = guiGetText(source)
	if (text=="close[1]") then
		if(wybor == 1)then showGUI(localPlayer,"ukryj") else
			wybor = wybor - 1 
			showButtons();
		end
	elseif (text=="wystaw[1]") then
		if timer and isTimer(timer) then return end
		timer = setTimer(function() timer=nil end,2500,1)	
		if(wybor == 1)then
			if guiGetText(elements[2]) ~= "Wybierz pojazd z listy" and guiGetText(elements[3]) ~= 0 and tonumber(guiGetText(elements[3])) and tonumber(guiGetText(elements[3]))>0 then
				wybor = 2;
				vehicleData = {
					vehicle = guiGetText(elements[2]);
					price = tonumber(guiGetText(elements[3]));
					offlineSale = false;
					guiGetText = false;
				};
				showButtons();
			else
				outputChatBox("#FF0000★ #FFFFFFUzupełnij wszystkie wymagane informacje",255,0,0,true)
			end
		elseif(wybor == 2)then
			if(vehicleData) and (vehicleData.vehicle) and (isElement(elements[2]))then 
				vehicleData.offlineSale = guiRadioButtonGetSelected(elements[2]);
				vehicleData.negociatePrice = guiRadioButtonGetSelected(elements[3]);
				if tonumber(vehicleData.price)>5000000 then outputChatBox("#FF0000★ #FFFFFFZbyt duża cena pojazdu!",255,0,0,true) return end
				if tonumber(vehicleData.price)<1 then outputChatBox("#FF0000★ #FFFFFFNieprawidłowa cena pojazdu",255,0,0,true) return end
				triggerServerEvent("CS:komisy:server",localPlayer,localPlayer,"wystaw",vehicleData);
			end
		end
	end
end)

function showGUI(plr,typ,dane)
	if plr and isElement(plr) then
		if (typ=="wystaw") then
			wybor=1
			if dane then data=dane end
			showCursor(true)
			showButtons();
			vehicleData=nil;
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
		elseif (typ=="ukryj") then
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
			showCursor(false)
			checkButtons()
			wybor,data,vehicleData=nil,nil,nil
			if timer and isTimer(timer) then killTimer(timer) timer=nil end
		end
	end
end
addEvent("CS:komisy:client",true)
addEventHandler("CS:komisy:client",root,showGUI)
