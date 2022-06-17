--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

local sw,sh = guiGetScreenSize()
local wybor=nil
local data=nil
local config=nil

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
		dxDrawText("KOMIS SAMOCHODOWY",sw/2,sh/2-178/zoom,sw/2,sh/2-178/zoom,tocolor(255,255,255,230),2/zoom,"default-bold","center","center")

		dxDrawRectangle(sw/2-(475/2)/zoom,sh/2-142/zoom,475/zoom,2/zoom,tocolor(255,255,255,150))

		if checkposition(sw/2-(19/2)/zoom+225/zoom,sh/2-(19/2)/zoom-178/zoom,19/zoom,19/zoom) then
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
			a=100
		end
		dxDrawImage(sw/2-(19/2)/zoom+225/zoom,sh/2-(19/2)/zoom-178/zoom,19/zoom,19/zoom,"images/close.png",0,0,0,tocolor(255,255,255,a or 255))
		a=nil

		if data then
			dxDrawText("(( Właściciel komisu: "..data[1].." ))",sw/2,sh/2-165/zoom,sw/2,sh/2-165/zoom,tocolor(255,255,255,255),1.25/zoom,"default-bold","center","top",false,true)
			dxDrawText(data[2],sw/2-(475/2)/zoom,sh/2-135/zoom,sw/2+(475/2)/zoom,sh/2+135/zoom,tocolor(255,255,255,255),1.25/zoom,"default-bold","center","top",false,true)
		end

	elseif (wybor==2) then
		dxDrawImage(sw/2-(500/2)/zoom,sh/2-(400/2)/zoom,500/zoom,400/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		dxDrawText("KOMIS SAMOCHODOWY",sw/2,sh/2-178/zoom,sw/2,sh/2-178/zoom,tocolor(255,255,255,230),2/zoom,"default-bold","center","center")

		dxDrawRectangle(sw/2-(475/2)/zoom,sh/2-142/zoom,475/zoom,2/zoom,tocolor(255,255,255,150))

		if checkposition(sw/2-(19/2)/zoom+225/zoom,sh/2-(19/2)/zoom-178/zoom,19/zoom,19/zoom) then
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
			a=100
		end
		dxDrawImage(sw/2-(19/2)/zoom+225/zoom,sh/2-(19/2)/zoom-175/zoom,19/zoom,19/zoom,"images/close.png",0,0,0,tocolor(255,255,255,a or 255))
		a=nil

		if data then
			dxDrawText("(( Właściciel komisu: "..data[1].." ))",sw/2,sh/2-165/zoom,sw/2,sh/2-165/zoom,tocolor(255,255,255,255),1.25/zoom,"default-bold","center","top",false,true)
			dxDrawText(data[2],sw/2-(475/2)/zoom,sh/2-135/zoom,sw/2+(475/2)/zoom,sh/2+135/zoom,tocolor(255,255,255,255),1.25/zoom,"default-bold","center","top",false,true)
		end

		if checkposition(sw/2-(315/2)/zoom,sh/2-(43/2)/zoom+170/zoom,315/zoom,43/zoom) then
			a=255
			if getKeyState("mouse1") then
				if not state then
					state=true
					wybor=3
					if not config then config={} end
					config.memo=guiCreateMemo(sw/2-(475/2)/zoom,sh/2-(290/2)/zoom,475/zoom,285/zoom,data[2],false)
				end
			else
				if state then state=nil end
			end
		else
			a=100
		end
		dxDrawImage(sw/2-(315/2)/zoom,sh/2-(43/2)/zoom+170/zoom,315/zoom,43/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))
		dxDrawText("EDYTUJ OPIS",sw/2-(315/2)/zoom,sh/2-(43/2)/zoom+170/zoom,sw/2-(315/2)/zoom+315/zoom,sh/2-(43/2)/zoom+170/zoom+43/zoom,tocolor(255,255,255,a or 255),1.75/zoom,"default-bold","center","center")
		a=nil
	elseif (wybor==3) then
		dxDrawImage(sw/2-(500/2)/zoom,sh/2-(400/2)/zoom,500/zoom,400/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		dxDrawText("KOMIS SAMOCHODOWY",sw/2,sh/2-178/zoom,sw/2,sh/2-178/zoom,tocolor(255,255,255,230),2/zoom,"default-bold","center","center")

		dxDrawRectangle(sw/2-(475/2)/zoom,sh/2-142/zoom,475/zoom,2/zoom,tocolor(255,255,255,150))

		if checkposition(sw/2-(19/2)/zoom+225/zoom,sh/2-(19/2)/zoom-178/zoom,19/zoom,19/zoom) then
			a=255
			if getKeyState("mouse1") then
				if not state then
					state=true
					wybor=2
					if config then
						deleteConfig()
					end
				end
			else
				if state then state=nil end
			end
		else
			a=100
		end
		dxDrawImage(sw/2-(19/2)/zoom+225/zoom,sh/2-(19/2)/zoom-175/zoom,19/zoom,19/zoom,"images/back.png",0,0,0,tocolor(255,255,255,a or 255))
		a=nil

		if data then
			dxDrawText("(( tryb: edycja opisu komisu ))",sw/2,sh/2-165/zoom,sw/2,sh/2-165/zoom,tocolor(255,255,255,255),1.25/zoom,"default-bold","center","top",false,true)
		end

		if checkposition(sw/2-(315/2)/zoom,sh/2-(43/2)/zoom+170/zoom,315/zoom,43/zoom) then
			a=255
			if getKeyState("mouse1") then
				if not state then
					state=true
					if config.memo then
						if data then data[2]=guiGetText(config.memo) end
						triggerServerEvent("CS:komisytabele:server",localPlayer,localPlayer,"new-description",{data[3],data[2],data[4]})
						deleteConfig()
						wybor=2
					end
				end
			else
				if state then state=nil end
			end
		else
			a=100
		end
		dxDrawImage(sw/2-(315/2)/zoom,sh/2-(43/2)/zoom+170/zoom,315/zoom,43/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))
		dxDrawText("ZAPISZ OPIS",sw/2-(315/2)/zoom,sh/2-(43/2)/zoom+170/zoom,sw/2-(315/2)/zoom+315/zoom,sh/2-(43/2)/zoom+170/zoom+43/zoom,tocolor(255,255,255,a or 255),1.75/zoom,"default-bold","center","center")
		a=nil
	end
end

function deleteConfig()
	if config.memo and isElement(config.memo) then
		destroyElement(config.memo)
		config.memo=nil
	end
	config=nil
end

addEventHandler("onClientGUIClick",resourceRoot,function()
	local text = guiGetText(source)
	if (text=="close[1]") then
		showGUI(localPlayer,"ukryj")
	end
end)

function showGUI(plr,typ,dane)
	if plr and isElement(plr) then
		if (typ=="customer") then
			if dane then data = dane end
			wybor=1
			showCursor(true)
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
		elseif (typ=="owner") then
			if dane then data = dane end
			wybor=2
			showCursor(true)
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
		elseif (typ=="ukryj") then
			if isEventHandlerAdded("onClientRender",root,onRender) then
				removeEventHandler("onClientRender",root,onRender)
			end
			showCursor(false)
			wybor,data=nil,nil
			if config then deleteConfig() end
		end
	end
end
addEvent("CS:komisytabele:client",true)
addEventHandler("CS:komisytabele:client",root,showGUI)