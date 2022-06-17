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

function isEventHandlerAdded(sEventName,pElementAttachedTo,func)
	if type(sEventName)=='string' and isElement(pElementAttachedTo) and type(func)=='function' then local aAttachedFunctions = getEventHandlers(sEventName,pElementAttachedTo)
	if type(aAttachedFunctions)=='table' and #aAttachedFunctions > 0 then for i,v in ipairs(aAttachedFunctions) do if v==func then return true end end end end return false
end

-- if elements[3] and isElement(elements[3]) then
	-- local sx,sy = guiGetPosition(elements[3],false)
	-- local sizex,sizey = guiGetSize(elements[3],false)
	-- if x*sw >= arg1 and y*sh <= arg2+arg4 and x*sw <= arg1+arg3 and y*sh >= arg2 then a = 255 else a = 255 * 0.4 end
	-- dxDrawText("",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.35/zoom,font,"center","center")
-- end a=nil

local zoom = 1
if sw < 1920 then zoom = math.min(2, 1920/sw) end -- domyślny

function checkButtons()
	if (#elements>0) then
		for _,v in ipairs(elements) do if v and isElement(v) then destroyElement(v) end end
	end
end

function showButtons()
	checkButtons()
	if (wybor==1) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+222/zoom,sh/2-(19/2)/zoom-121/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[1],0)
        elements[2] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+120/zoom,200/zoom,40/zoom,"zaladuj[1]",false) guiSetAlpha(elements[2],0)
    elseif (wybor==2) then
        elements[1] = guiCreateButton(sw/2-(19/2)/zoom+222/zoom,sh/2-(19/2)/zoom-121/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+120/zoom,200/zoom,40/zoom,"rozladuj[1]",false) guiSetAlpha(elements[2],0)
	end
end

local info = {
    ["zaladunek"]="W tym miejscu możesz pobrać\nzaładunek, który należy w późniejszym\netapie pracy przetransportować do wyznaczonego celu.",
    ["rozladunek"]="W tym miejscu możesz rozładować załadunek,\nktóry wcześniej załadowałeś.\nPamiętaj, że liczy się, aby ładunek nie był uszkodzony!",
}

function checkPosition(arg1,arg2,arg3,arg4)
    local x,y = getCursorPosition()
    if not x then return end
    if x*sw >= arg1 and y*sh <= arg2+arg4 and x*sw <= arg1+arg3 and y*sh >= arg2 then return true else return false end
end


function onRender()
	local x,y = getCursorPosition()
	if (wybor==1) then
		dxDrawImage(sw/2-(500/2)/zoom,sh/2-(300/2)/zoom,500/zoom,300/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		
		if checkPosition(sw/2-(19/2)/zoom+222/zoom,sh/2-(19/2)/zoom-121/zoom,19/zoom,19/zoom) then a=255 else a=120 end
		dxDrawImage(sw/2-(19/2)/zoom+222/zoom,sh/2-(19/2)/zoom-121/zoom,19/zoom,19/zoom,"images/closee.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil
		
		dxDrawText("ZAŁADUNEK KONTENERÓW",sw/2,sh/2-125/zoom,sw/2,sh/2-125/zoom,tocolor(255,255,255,220),0.6/zoom,font,"center","center")
		dxDrawText(info.zaladunek,sw/2,sh/2-90/zoom,sw/2,sh/2-90/zoom,tocolor(255,255,255,220),0.35/zoom,font,"center","top",false,false,false,true)
		
		
		if timer then
			dxDrawRectangle(sw/2-(300/2)/zoom,sh/2-(40/2)/zoom+50/zoom,300/zoom,40/zoom,tocolor(180,180,180,50))
			dxDrawRectangle(sw/2-(300/2)/zoom,sh/2-(40/2)/zoom+50/zoom,300*(czas/25)/zoom,40/zoom,tocolor(059,131,189,210))
			
			dxDrawRectangle(sw/2-(300/2)/zoom,sh/2-(40/2)/zoom+50/zoom,300/zoom,2/zoom,tocolor(0,0,0,230))
			dxDrawRectangle(sw/2-(300/2)/zoom,sh/2-(40/2)/zoom+90/zoom,300/zoom,2/zoom,tocolor(0,0,0,230))
			
			dxDrawRectangle(sw/2-(300/2)/zoom,sh/2-(40/2)/zoom+50/zoom,2/zoom,40/zoom+2/zoom,tocolor(0,0,0,230))
			dxDrawRectangle(sw/2+(300/2)/zoom,sh/2-(40/2)/zoom+50/zoom,2/zoom,40/zoom+2/zoom,tocolor(0,0,0,230))
			
			if czas==1 then czas_info = "1 sekunda" elseif czas>1 and czas<5 then czas_info = czas.." sekundy" else czas_info = czas.." sekund" end
			dxDrawText("Pozostało: "..czas_info,sw/2,sh/2+50/zoom,sw/2,sh/2+50/zoom,tocolor(0,0,0,220),0.4/zoom,font,"center","center")
        end
        
        if elements[2] and isElement(elements[2]) then
            local sx,sy = guiGetPosition(elements[2],false)
            local sizex,sizey = guiGetSize(elements[2],false)
            if checkPosition(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+120/zoom,200/zoom,40/zoom) then a=230 else a=120 end
            dxDrawImage(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+120/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 230))
            dxDrawText("Załaduj kontener",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.35/zoom,font,"center","center")
        end a=nil
    elseif (wybor==2) then
        dxDrawImage(sw/2-(500/2)/zoom,sh/2-(300/2)/zoom,500/zoom,300/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		
		if checkPosition(sw/2-(19/2)/zoom+222/zoom,sh/2-(19/2)/zoom-121/zoom,19/zoom,19/zoom) then a=255 else a=120 end
		dxDrawImage(sw/2-(19/2)/zoom+222/zoom,sh/2-(19/2)/zoom-121/zoom,19/zoom,19/zoom,"images/closee.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil
		
		dxDrawText("ROZŁADUNEK KONTENERÓW",sw/2,sh/2-125/zoom,sw/2,sh/2-125/zoom,tocolor(255,255,255,220),0.6/zoom,font,"center","center")
		dxDrawText(info.rozladunek,sw/2,sh/2-90/zoom,sw/2,sh/2-90/zoom,tocolor(255,255,255,220),0.35/zoom,font,"center","top",false,false,false,true)
		
		
		if timer then
			dxDrawRectangle(sw/2-(300/2)/zoom,sh/2-(40/2)/zoom+50/zoom,300/zoom,40/zoom,tocolor(180,180,180,50))
			dxDrawRectangle(sw/2-(300/2)/zoom,sh/2-(40/2)/zoom+50/zoom,300*(czas/25)/zoom,40/zoom,tocolor(059,131,189,210))
			
			dxDrawRectangle(sw/2-(300/2)/zoom,sh/2-(40/2)/zoom+50/zoom,300/zoom,2/zoom,tocolor(0,0,0,230))
			dxDrawRectangle(sw/2-(300/2)/zoom,sh/2-(40/2)/zoom+90/zoom,300/zoom,2/zoom,tocolor(0,0,0,230))
			
			dxDrawRectangle(sw/2-(300/2)/zoom,sh/2-(40/2)/zoom+50/zoom,2/zoom,40/zoom+2/zoom,tocolor(0,0,0,230))
			dxDrawRectangle(sw/2+(300/2)/zoom,sh/2-(40/2)/zoom+50/zoom,2/zoom,40/zoom+2/zoom,tocolor(0,0,0,230))
			
			if czas==1 then czas_info = "1 sekunda" elseif czas>1 and czas<5 then czas_info = czas.." sekundy" else czas_info = czas.." sekund" end
			dxDrawText("Pozostało: "..czas_info,sw/2,sh/2+50/zoom,sw/2,sh/2+50/zoom,tocolor(0,0,0,220),0.4/zoom,font,"center","center")
        end
        
        if elements[2] and isElement(elements[2]) then
            local sx,sy = guiGetPosition(elements[2],false)
            local sizex,sizey = guiGetSize(elements[2],false)
            if checkPosition(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+120/zoom,200/zoom,40/zoom) then a=230 else a=120 end
            dxDrawImage(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+120/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 230))
            dxDrawText("Rozładuj kontener",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.35/zoom,font,"center","center")
        end a=nil
	end
end

function showGUI(plr,typ,dane)
	if plr and isElement(plr) then
		if (typ=="ukryj") then
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
			showCursor(false)
			checkButtons()
            wybor=nil
        elseif (typ=="zaladunek") then
            wybor=1
            showCursor(true)
            showButtons()
            if not isEventHandlerAdded("onClientRender",root,onRender) then
                addEventHandler("onClientRender",root,onRender)
            end
        elseif (typ=="rozladunek") then
            wybor=2
            showCursor(true)
            showButtons()
            if not isEventHandlerAdded("onClientRender",root,onRender) then
                addEventHandler("onClientRender",root,onRender)
            end
		end
	end
end
addEvent("CS:kontenery:client",true)
addEventHandler("CS:kontenery:client",root,showGUI)

local timer2 = nil

addEventHandler("onClientGUIClick",resourceRoot,function()
	local text = guiGetText(source)
    if (text=="close[1]") then
        if timer and isTimer(timer) then return end
        showGUI(localPlayer,"ukryj")
    elseif (text=="zaladuj[1]") then
        if timer and isTimer(timer) then return end
        fadeCamera(false)
        czas = 25
        checkPoints(localPlayer)
        setElementFrozen(getPedOccupiedVehicle(localPlayer),true)
		timer = setTimer(function()
			czas = czas - 1
            if czas == 0 then
				showGUI(localPlayer,"ukryj")
				statusJob(localPlayer,"pokazrozladunek")
				fadeCamera(true)
				czas=nil
                timer = nil
                setElementFrozen(getPedOccupiedVehicle(localPlayer),false)
			end
        end,1000,czas)
    elseif (text=="rozladuj[1]") then
        if timer and isTimer(timer) then return end
        fadeCamera(false)
        czas = 25
        checkPoints(localPlayer)
        setElementFrozen(getPedOccupiedVehicle(localPlayer),true)
		timer = setTimer(function()
			czas = czas - 1
            if czas == 0 then
				showGUI(localPlayer,"ukryj")
				fadeCamera(true)
				czas=nil
                timer = nil
                triggerEvent("CS:powiadomienie",localPlayer,localPlayer,{"info","Konterner został rozładowany.\nUdaj się do miejsca załadunku\nwyznaczonego na mapie."})
                setElementFrozen(getPedOccupiedVehicle(localPlayer),false)
                if timer2 and isTimer(timer2) then return end
                timer2 = setTimer(function() timer2=nil end,5000,1)
                statusJob(localPlayer,"wyplata")
                statusJob(localPlayer,"pokazzaladunek")
			end
        end,1000,czas)
	end
end)

local point = nil
local blip = nil
local obiekt = nil
local shape = nil
local distance,originaldistnace=nil,nil

function checkPoints(plr,status)
    if plr and isElement(plr) then
        if point and isElement(point) then destroyElement(point) end point=nil
        if blip and isElement(blip) then destroyElement(blip) end blip=nil
        if shape and isElement(shape) then destroyElement(shape) end shape=nil
        if status then
            if obiekt and isElement(obiekt) then destroyElement(obiekt) end obiekt=nil
            distance,originaldistnace=nil,nil
        end
    end
end

function statusJob(plr,typ)
    if plr and isElement(plr) then
        if (typ=="pokazzaladunek") then
            checkPoints(plr,true)
            local rnd = math.random(1,#zaladunek)
            point = createMarker(zaladunek[rnd][1],zaladunek[rnd][2],zaladunek[rnd][3]-1,"cylinder",4,255,255,0,50)
            setElementData(point,"zaladunek",true,false)
            shape = createColSphere(zaladunek[rnd][1],zaladunek[rnd][2],zaladunek[rnd][3],16)
            blip = createBlip(zaladunek[rnd][1],zaladunek[rnd][2],zaladunek[rnd][3],41,2,255,0,0,150,0,9999)
        elseif (typ=="pokazrozladunek") then
            triggerEvent("CS:powiadomienie",plr,plr,{"info","Kontener został załadowany.\nUdaj sie do miejsca rozładunku."})
            checkPoints(plr,true)
            local rnd = math.random(1,#rozladunki)
            point = createMarker(rozladunki[rnd][1],rozladunki[rnd][2],rozladunki[rnd][3]-1,"cylinder",4,255,255,0,50)
            setElementData(point,"rozladunek",true,false)
            blip = createBlip(rozladunki[rnd][1],rozladunki[rnd][2],rozladunki[rnd][3],41,2,255,0,0,150,0,9999)
            shape = createColSphere(rozladunki[rnd][1],rozladunki[rnd][2],rozladunki[rnd][3]+1,16)
            local rnd = math.random(1,#obiekty)
            obiekt = createObject(obiekty[rnd],0,0,0,0,0,0)
            local x,y,z = getElementPosition(getPedOccupiedVehicle(plr))
            setElementPosition(getPedOccupiedVehicle(plr),x,y,z+3.5)
            attachElements(obiekt,getPedOccupiedVehicle(plr),0,1,-2.55,0,0,0)
            local x,y,z = getElementPosition(plr)
            originaldistnace = getDistanceBetweenPoints3D(x,y,z,rozladunki[rnd][1],rozladunki[rnd][2],rozladunki[rnd][3])
            distance=originaldistnace
        elseif (typ=="zakonczprace") then
            checkPoints(plr,true)
            showGUI(plr,"ukryj")
            if timer and isTimer(timer) then killTimer(timer) end timer=nil
            if timer2 and isTimer(timer2) then killTimer(timer2) end timer2=nil
            setElementData(plr,"player:job",false)
        elseif (typ=="wyplata") then
            triggerServerEvent("CS:wyplatapraca",localPlayer,localPlayer,"kontenery",originaldistnace/100)
        end
    end
end
addEvent("CS:praca:kontenery:client",true)
addEventHandler("CS:praca:kontenery:client",root,statusJob)

addEventHandler("onClientRender",root,function()
	if distance and originaldistnace and point then
		dxDrawImage(sw/2-(240/2)/zoom,15/zoom,240/zoom,110/zoom,"images/infoo.png",0,0,0,tocolor(255,255,255,255))
		local x,y,z = getElementPosition(localPlayer)
		local xm,ym,zm = getElementPosition(point)
		distance = getDistanceBetweenPoints3D(x,y,z,xm,ym,zm)
		if distance >= 25 then
			dxDrawText("Odległość od punktu: #81b1d3"..math.floor(distance).." m",sw/2,110/zoom,sw/2,110/zoom,tocolor(255,255,255,220),0.35/zoom,font,"center","center",false,false,false,true)
			dxDrawText("Udaj się do wyznaczonego\npunktu, aby rozładować\nkontener.",sw/2,65/zoom,sw/2,65/zoom,tocolor(255,255,255,220),0.35/zoom,font,"center","center")
		else
			dxDrawText("#81b1d3Jesteś u celu!",sw/2,110/zoom,sw/2,110/zoom,tocolor(255,255,255,220),0.35/zoom,font,"center","center",false,false,false,true)
			dxDrawText("Wleć do wyznaczonego punktu\ncelem rozładowania kontenera.",sw/2,70/zoom,sw/2,70/zoom,tocolor(255,255,255,220),0.35/zoom,font,"center","center")
		end
	else
		if point and not distance then
			dxDrawImage(sw/2-(240/2)/zoom,15/zoom,240/zoom,110/zoom,"images/infoo.png",0,0,0,tocolor(255,255,255,255))
			local x,y,z = getElementPosition(localPlayer)
			local xm,ym,zm = getElementPosition(point)
			
			if getDistanceBetweenPoints3D(x,y,z,xm,ym,zm) >= 25 then
				dxDrawText("Odległość od punktu: #81b1d3"..math.floor(getDistanceBetweenPoints3D(x,y,z,xm,ym,zm)).." m",sw/2,110/zoom,sw/2,110/zoom,tocolor(255,255,255,220),0.35/zoom,font,"center","center",false,false,false,true)
				dxDrawText("Udaj się do wyznaczonego\npunktu, aby odebrać\nkolejny kontener.",sw/2,65/zoom,sw/2,65/zoom,tocolor(255,255,255,220),0.35/zoom,font,"center","center")
			else
				dxDrawText("#81b1d3Jesteś u celu!",sw/2,110/zoom,sw/2,110/zoom,tocolor(255,255,255,220),0.35/zoom,font,"center","center",false,false,false,true)
				dxDrawText("Wleć do wyznaczonego punktu\n aby odebrać kontener.",sw/2,65/zoom,sw/2,65/zoom,tocolor(255,255,255,220),0.35/zoom,font,"center","center")
			end
		end
	end
end)

addEventHandler("onClientMarkerHit",resourceRoot,function(plr,dim)
    if plr and isElement(plr) and plr == localPlayer and dim then
        if source == point then
            if getElementData(source,"zaladunek") then
                if isElementWithinColShape(plr,shape) then
                    showGUI(plr,"zaladunek")
                end
            elseif getElementData(source,"rozladunek") then
                if isElementWithinColShape(plr,shape) then
                    showGUI(plr,"rozladunek")
                end
            end
        end
    end
end)

addEventHandler("onClientPlayerWasted",root,function()
	if source == localPlayer then
        statusJob(source,"zakonczprace")
	end
end)