--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

local options = {
	[1]={
		name="PRAWO JAZDY KAT. A/B/C",
		pos={-2020.49,-98.78,35.17},
		rot=90,
	},
	[2]={
		name="PRACA DORYWCZA: MAGAZYNIER",
		pos={-1693.99,-90.20,3.56},
		rot=224,
	},
	[3]={
		name="PRACA DORYWCZA: RYBAK",
		pos={1623.59,609.77,7.77},
		rot=270,
	},
	[4]={
		name="PRZEBIERALNIA",
		pos={-2191.78,576.03,35.17},
		rot=270,
	},
}

local font = exports["CS-fonts"]:font("main")
local sw,sh = guiGetScreenSize()
local wybor=nil
local elements = {}
local data = nil

function isEventHandlerAdded(sEventName,pElementAttachedTo,func)
	if type(sEventName)=='string' and isElement(pElementAttachedTo) and type(func)=='function' then local aAttachedFunctions = getEventHandlers(sEventName,pElementAttachedTo)
	if type(aAttachedFunctions)=='table' and #aAttachedFunctions > 0 then for i,v in ipairs(aAttachedFunctions) do if v==func then return true end end end end return false
end

local zoom = 1
if sw < 1920 then zoom = math.min(1.25,1920/sw) end -- domyślny

function checkposition(arg1,arg2,arg3,arg4)
	local x,y = getCursorPosition()
	if not x then return end
	if x*sw >= arg1 and y*sh <= arg2+arg4 and x*sw <= arg1+arg3 and y*sh >= arg2 then return true else return false end
end

function onRender()
	local x,y = getCursorPosition()
	if (wybor==1) then
		dxDrawImage(sw/2-(500/2)/zoom,sh/2-(400/2)/zoom,500/zoom,400/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		dxDrawText("#3399FF★ #FFFFFFWITAJ NA SERWERZE #3399FF★",sw/2,sh/2-175/zoom,sw/2,sh/2-175/zoom,tocolor(255,255,255,255),1.75/zoom,"default-bold","center","center",false,false,false,true)
		
		dxDrawText("Miło nam, że zadecydowałeś/aś zagrać na naszym serwerze.\nWiedz o tym, że serwer tworzony jest z pasją, dla graczy.\n\nNa samym początku proponujemy Ci niewielką pomoc\nw postaci przeniesienia do najważniejszych początkowych miejsc,\ndzięki którym możesz rozpocząć w pełni rozgrywkę na naszym\nserwerze. Pamiętaj, że wyrabianie prawa jazdy na początku rozgrywki\nnie jest obowiązkowe.",sw/2,sh/2-75/zoom,sw/2,sh/2-75/zoom,tocolor(255,255,255,255),1.25/zoom,"default","center","center")
		dxDrawRectangle(sw/2-(475/2)/zoom,sh/2+10/zoom,475/zoom,1/zoom,tocolor(255,255,255,150))

		option,mnoznik=1,1.7

		if checkposition(sw/2-(475/2)/zoom,sh/2+25*option/zoom,475/zoom,30/zoom) then
			a1,a2=45,255
			if getKeyState("mouse1") then
				if not state then
					state=true
					showGUI(localPlayer,"ukryj")
					triggerServerEvent("CS:helloPanel2:server",localPlayer,localPlayer,"teleport",{options[1].pos[1],options[1].pos[2],options[1].pos[3],options[1].rot})
				end
			else
				if state then state=nil end
			end
		else
			a1,a2=20,135
		end
		dxDrawRectangle(sw/2-(475/2)/zoom,sh/2+25*option/zoom,475/zoom,30/zoom,tocolor(255,255,255,a1))
		dxDrawText(options[1].name,sw/2-(475/2)/zoom,sh/2+25*option/zoom,sw/2-(475/2)/zoom+475/zoom,sh/2+25*option/zoom+30/zoom,tocolor(255,255,255,a2),1.25/zoom,"default-bold","center","center")
		a1,a2,option=nil,nil,option+mnoznik

		if checkposition(sw/2-(475/2)/zoom,sh/2+25*option/zoom,475/zoom,30/zoom) then
			a1,a2=45,255
			if getKeyState("mouse1") then
				if not state then
					state=true
					showGUI(localPlayer,"ukryj")
					triggerServerEvent("CS:helloPanel2:server",localPlayer,localPlayer,"teleport",{options[2].pos[1],options[2].pos[2],options[2].pos[3],options[2].rot})
				end
			else
				if state then state=nil end
			end
		else
			a1,a2=20,135
		end
		dxDrawRectangle(sw/2-(475/2)/zoom,sh/2+25*option/zoom,475/zoom,30/zoom,tocolor(255,255,255,a1))
		dxDrawText(options[2].name,sw/2-(475/2)/zoom,sh/2+25*option/zoom,sw/2-(475/2)/zoom+475/zoom,sh/2+25*option/zoom+30/zoom,tocolor(255,255,255,a2),1.25/zoom,"default-bold","center","center")
		a1,a2,option=nil,nil,option+mnoznik

		if checkposition(sw/2-(475/2)/zoom,sh/2+25*option/zoom,475/zoom,30/zoom) then
			a1,a2=45,255
			if getKeyState("mouse1") then
				if not state then
					state=true
					showGUI(localPlayer,"ukryj")
					triggerServerEvent("CS:helloPanel2:server",localPlayer,localPlayer,"teleport",{options[3].pos[1],options[3].pos[2],options[3].pos[3],options[3].rot})
				end
			else
				if state then state=nil end
			end
		else
			a1,a2=20,135
		end
		dxDrawRectangle(sw/2-(475/2)/zoom,sh/2+25*option/zoom,475/zoom,30/zoom,tocolor(255,255,255,a1))
		dxDrawText(options[3].name,sw/2-(475/2)/zoom,sh/2+25*option/zoom,sw/2-(475/2)/zoom+475/zoom,sh/2+25*option/zoom+30/zoom,tocolor(255,255,255,a2),1.25/zoom,"default-bold","center","center")
		a1,a2,option=nil,nil,option+mnoznik

		if checkposition(sw/2-(475/2)/zoom,sh/2+25*option/zoom,475/zoom,30/zoom) then
			a1,a2=45,255
			if getKeyState("mouse1") then
				if not state then
					state=true
					showGUI(localPlayer,"ukryj")
					triggerServerEvent("CS:helloPanel2:server",localPlayer,localPlayer,"teleport",{options[4].pos[1],options[4].pos[2],options[4].pos[3],options[4].rot})
				end
			else
				if state then state=nil end
			end
		else
			a1,a2=20,135
		end
		dxDrawRectangle(sw/2-(475/2)/zoom,sh/2+25*option/zoom,475/zoom,30/zoom,tocolor(255,255,255,a1))
		dxDrawText(options[4].name,sw/2-(475/2)/zoom,sh/2+25*option/zoom,sw/2-(475/2)/zoom+475/zoom,sh/2+25*option/zoom+30/zoom,tocolor(255,255,255,a2),1.25/zoom,"default-bold","center","center")
		a1,a2,option=nil,nil,option+mnoznik

		

		

		if (czas and czas>0) then
			dxDrawText(czas,sw/2+225/zoom,sh/2-175/zoom,sw/2+225/zoom,sh/2-175/zoom,tocolor(200,200,200,200),1.25/zoom,"default-bold","center","center")
		else
			if checkposition(sw/2-(19/2)/zoom+225/zoom,sh/2-(19/2)/zoom-175/zoom,19/zoom,19/zoom) then
				a=255
				if getKeyState("mouse1") then
					if not state then
						state=true
						showGUI(localPlayer,"ukryj")
					end
				else
					if state then state=nil end
				end
			else
				a=120
			end
			dxDrawImage(sw/2-(19/2)/zoom+225/zoom,sh/2-(19/2)/zoom-175/zoom,19/zoom,19/zoom,"images/close.png",0,0,0,tocolor(255,255,255,a or 255))
			a=nil
		end
	end
end

function showGUI(plr,typ)
	if plr and isElement(plr) then
		if (typ=="pokaz") then
			wybor=1
			showCursor(true)
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
			czas=10

			setTimer(function()
				czas=czas-1
			end,1000,czas)
		elseif (typ=="ukryj") then
			if isEventHandlerAdded("onClientRender",root,onRender) then
				removeEventHandler("onClientRender",root,onRender)
			end
			showCursor(false)
			wybor=nil
		end
	end
end
addEvent("CS:helloPanel:next:client",true)
addEventHandler("CS:helloPanel:next:client",root,showGUI)