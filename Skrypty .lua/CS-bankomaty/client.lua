--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--
local sw,sh = guiGetScreenSize()
local zoom = 1
if sw < 1920 then zoom = math.min(1.25,1920/sw) end -- domyślny

local font = dxCreateFont('fonts/normal.ttf', 14.4/zoom)

local wybor=nil
local elements = {}

local organizationmoney = nil
local company_Account = nil
local admin_Account = nil
local action = nil
local actions = {
	[1] = {
		[1]={"images/priv.png","Prywatne konto\nbankowe"},
		[2]={"images/org.png","Organizacyjne konto\nbankowe"},
		[3]={"images/org.png","Biznesowe konto\nbankowe"},
		[4]={"images/priv.png","Firmowe konto\nbankowe"},
		[5]={"images/priv.png","Administracyjne konto\nbankowe"},
	},
	[2] = {
		[1]="Wypłać środki z konta",
		[2]="Wpłać środki na konto",
	},
	[3] = {
		[1]="Wypłać środki z konta",
		[2]="Wpłać środki na konto",
	},
	[4] = {
		[1]="Wypłać środki z konta",
		[2]="Wpłać środki na konto",
	},

	[5] = {
		[1]="Wypłać środki z konta",
	},

	[6] = {
		[1]="Wypłać środki z konta",
		[2]="Wpłać środki na konto",
	},
}

function isEventHandlerAdded(sEventName,pElementAttachedTo,func)
	if type(sEventName)=='string' and isElement(pElementAttachedTo) and type(func)=='function' then local aAttachedFunctions = getEventHandlers(sEventName,pElementAttachedTo)
	if type(aAttachedFunctions)=='table' and #aAttachedFunctions > 0 then for i,v in ipairs(aAttachedFunctions) do if v==func then return true end end end end return false
end



function checkButtons()
	if (#elements>0) then
		for _,v in ipairs(elements) do if v and isElement(v) then destroyElement(v) end end
	end
end

function showButtons()
	checkButtons()
	if (wybor==1) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateButton(sw/2-(350/2)/zoom,sh/2-(102/2)/zoom-75/zoom,350/zoom,102/zoom,"action_nil",false) guiSetAlpha(elements[2],0)
		elements[3] = guiCreateButton(sw/2-(35/2)/zoom-75/zoom,sh/2-(35/2)/zoom+5/zoom,35/zoom,35/zoom,"left[1]",false) guiSetAlpha(elements[3],0)
		elements[4] = guiCreateButton(sw/2-(35/2)/zoom+75/zoom,sh/2-(35/2)/zoom+5/zoom,35/zoom,35/zoom,"right[1]",false) guiSetAlpha(elements[4],0)

		elements[5] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+170/zoom,200/zoom,40/zoom,"next[1]",false) guiSetAlpha(elements[5],0)
	elseif (wybor==2) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom,"back[2]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateEdit(sw/2-(200/2)/zoom,sh/2-(35/2)/zoom,200/zoom,35/zoom,"",false) guiSetAlpha(elements[2],0.75)
		elements[3] = guiCreateButton(sw/2-(35/2)/zoom-125/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"left[1]",false) guiSetAlpha(elements[3],0)
		elements[4] = guiCreateButton(sw/2-(35/2)/zoom+125/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"right[1]",false) guiSetAlpha(elements[4],0)
		elements[5] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom,"action[2]",false) guiSetAlpha(elements[5],0)
	elseif (wybor==3) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom,"back[2]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateEdit(sw/2-(200/2)/zoom,sh/2-(35/2)/zoom,200/zoom,35/zoom,"",false) guiSetAlpha(elements[2],0.75)
		elements[3] = guiCreateButton(sw/2-(35/2)/zoom-125/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"left[1]",false) guiSetAlpha(elements[3],0)
		elements[4] = guiCreateButton(sw/2-(35/2)/zoom+125/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"right[1]",false) guiSetAlpha(elements[4],0)
		elements[5] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom,"action[3]",false) guiSetAlpha(elements[5],0)
	elseif (wybor==4) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom,"back[2]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateEdit(sw/2-(200/2)/zoom,sh/2-(35/2)/zoom,200/zoom,35/zoom,"",false) guiSetAlpha(elements[2],0.75)
		elements[3] = guiCreateButton(sw/2-(35/2)/zoom-125/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"left[1]",false) guiSetAlpha(elements[3],0)
		elements[4] = guiCreateButton(sw/2-(35/2)/zoom+125/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"right[1]",false) guiSetAlpha(elements[4],0)
		elements[5] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom,"action[3]",false) guiSetAlpha(elements[5],0)
	elseif (wybor==5) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom,"back[2]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateEdit(sw/2-(200/2)/zoom,sh/2-(35/2)/zoom,200/zoom,35/zoom,"",false) guiSetAlpha(elements[2],0.75)
		elements[3] = guiCreateButton(sw/2-(35/2)/zoom-125/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"left[1]",false) guiSetAlpha(elements[3],0)
		elements[4] = guiCreateButton(sw/2-(35/2)/zoom+125/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"right[1]",false) guiSetAlpha(elements[4],0)
		elements[5] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom,"action[3]",false) guiSetAlpha(elements[5],0)
	elseif (wybor==6) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom,"back[2]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateEdit(sw/2-(200/2)/zoom,sh/2-(35/2)/zoom,200/zoom,35/zoom,"",false) guiSetAlpha(elements[2],0.75)
		elements[3] = guiCreateButton(sw/2-(35/2)/zoom-125/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"left[1]",false) guiSetAlpha(elements[3],0)
		elements[4] = guiCreateButton(sw/2-(35/2)/zoom+125/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"right[1]",false) guiSetAlpha(elements[4],0)
		elements[5] = guiCreateButton(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom,"action[3]",false) guiSetAlpha(elements[5],0)
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
		dxDrawImage(sw/2-(360/2)/zoom,sh/2-(400/2)/zoom,360/zoom,400/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		dxDrawText("BANKOMAT",sw/2,sh/2-165/zoom,sw/2,sh/2-165/zoom,tocolor(255,255,255,230),1/zoom,font,"center","center")

		if checkPosition(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom) then a=255 else a=130 end
		dxDrawImage(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom,"images/close.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		if action and elements[2] then
			if guiGetText(elements[2]) ~= actions[wybor][action][2] then guiSetText(elements[2],actions[wybor][action][2]) end
			if elements[2] and isElement(elements[2]) then
				dxDrawImage(sw/2-(350/2)/zoom,sh/2-(102/2)/zoom-75/zoom,350/zoom,102/zoom,actions[wybor][action][1],0,0,0,tocolor(255,255,255,a or 255))
				local sx,sy = guiGetPosition(elements[2],false)
				local sizex,sizey = guiGetSize(elements[2],false)
				dxDrawText(actions[wybor][action][2],sx+50/zoom,sy,sx+sizex+50/zoom,sy+sizey,tocolor(235,235,235,210),0.95/zoom,font,"center","center")
			end

			if action == 1 then
				dxDrawText("Na koncie #044ec0prywatnym #FFFFFFprzetrzymywane są\nwpłacone przez Ciebie pieniądze.\nW każdej chwili możesz je wypłacić.\nNie są one objęte oprocentowaniem.\n\nObecny stan konta: #008000"..getElementData(localPlayer,"bankmoney")..".00 PLN",sw/2,sh/2+37.5/zoom,sw/2,sh/2+37.5/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","top",false,false,false,true)
			elseif action == 2 then
				dxDrawText("Na koncie #044ec0organizacyjnym #FFFFFFgromadzą się\npieniądze wpłacone przez członków organizacji.\n\nJedynie lider jest w stanie dysponować\nwypłatą pieniędzy. Wpłaty może dokonać\nkażdy pełnoprawny członek organizacji.",sw/2,sh/2+37.5/zoom,sw/2,sh/2+37.5/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","top",false,false,false,true)
			elseif action == 3 then
				dxDrawText("Na koncie #044ec0biznesowym #FFFFFFgromadzą się\npieniądze wpłacone przez członków biznesu.\n\nJedynie lider jest w stanie dysponować\nwypłatą pieniędzy. Wpłaty może dokonać\nkażdy pełnoprawny członek biznesu.",sw/2,sh/2+37.5/zoom,sw/2,sh/2+37.5/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","top",false,false,false,true)
			elseif action == 4 then
				dxDrawText("Na koncie #044ec0firmowym #FFFFFFgromadzą się\npieniądze za dobra sprzedane klientom.\n\nŚrodki z tego konta można tylko wypłacić.",sw/2,sh/2+37.5/zoom,sw/2,sh/2+37.5/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","top",false,false,false,true)
			elseif action == 5 then
				if getElementData(localPlayer, "admin:rank") ~= "RCON" and getElementData(localPlayer, "admin:rank") ~= "Globaladministrator" then
					action, wybor = 1,1
					return
				end
				dxDrawText("Na koncie #044ec0administracyjnym #FFFFFFgromadzą się\npieniądze z podatków.\n\n#ff0000Wypłaty są logowane!",sw/2,sh/2+37.5/zoom,sw/2,sh/2+37.5/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","top",false,false,false,true)
			end

		end

		dxDrawText("Wybierz\ntyp konta",sw/2,sh/2+5/zoom,sw/2,sh/2+5/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","center")

		if checkPosition(sw/2-(35/2)/zoom-75/zoom,sh/2-(35/2)/zoom+5/zoom,35/zoom,35/zoom) then a=255 else a=75 end
		dxDrawImage(sw/2-(35/2)/zoom-75/zoom,sh/2-(35/2)/zoom+5/zoom,35/zoom,35/zoom,"images/left.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		if checkPosition(sw/2-(35/2)/zoom+75/zoom,sh/2-(35/2)/zoom+5/zoom,35/zoom,35/zoom) then a=255 else a=75 end
		dxDrawImage(sw/2-(35/2)/zoom+75/zoom,sh/2-(35/2)/zoom+5/zoom,35/zoom,35/zoom,"images/right.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil


		if elements[5] and isElement(elements[5]) then
			local sx,sy = guiGetPosition(elements[5],false)
			local sizex,sizey = guiGetSize(elements[5],false)
			local a = 240
			if checkPosition(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+170/zoom,200/zoom,40/zoom) then 
			dxDrawRectangle(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+170/zoom,200/zoom,40/zoom, tocolor(32, 49, 76, a)) else dxDrawRectangle(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+170/zoom,200/zoom,40/zoom, tocolor(10, 24, 45, a)) end
			dxDrawText("Przejdź dalej",sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.775/zoom,font,"center","center")
		end a=nil


	elseif (wybor==2) then -- konto bankowe prywatne
		dxDrawImage(sw/2-(360/2)/zoom,sh/2-(400/2)/zoom,360/zoom,400/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		dxDrawText("BANKOMAT",sw/2,sh/2-165/zoom,sw/2,sh/2-165/zoom,tocolor(255,255,255,230),0.9/zoom,font,"center","center")

		if checkPosition(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom) then a=255 else a=130 end
		dxDrawImage(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom,"images/back.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		dxDrawText("Obecnie na swoim koncie prywatnym\nposiadasz #008000"..getElementData(localPlayer,"bankmoney")..".00 PLN#FFFFFF.",sw/2,sh/2-110/zoom,sw/2,sh/2-110/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","center",false,false,false,true)

		if checkPosition(sw/2-(35/2)/zoom-135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom) then a=255 else a=75 end
		dxDrawImage(sw/2-(35/2)/zoom-135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"images/left.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		if checkPosition(sw/2-(35/2)/zoom+135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom) then a=255 else a=75 end
		dxDrawImage(sw/2-(35/2)/zoom+135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"images/right.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		dxDrawText("Wpisz kwotę wykonywanej transakcji",sw/2,sh/2-30/zoom,sw/2,sh/2-30/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","center")
		dxDrawText("Wybierz typ transakcji",sw/2,sh/2+90/zoom,sw/2,sh/2+90/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","center")
		if elements[5] and isElement(elements[5]) then
			local sx,sy = guiGetPosition(elements[5],false)
			local sizex,sizey = guiGetSize(elements[5],false)
			if checkPosition(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom) then a=255 else a=100 end
			dxDrawImage(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))

			if guiGetText(elements[5]) ~= actions[wybor][action] then guiSetText(elements[5],actions[wybor][action]) end
			dxDrawText(guiGetText(elements[5]),sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.75/zoom,font,"center","center")
		end a=nil

		if guiGetText(elements[2]) ~= "" then
			if tonumber(guiGetText(elements[2])) then
				if tonumber(guiGetText(elements[2]))>0 then
					if tonumber(guiGetText(elements[2]))<1000000 then
						dxDrawText("#008000Podana liczba jest prawidłowa.\nPotwierdź transakcję przyciskiem poniżej.",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","center",false,false,false,true)
					else
						dxDrawText("#FF0000Na jedną transakcję przypada limit\nna kwotę poniżej 1.000.000 PLN!",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","center",false,false,false,true)
					end
				else
					dxDrawText("#FF0000Podana kwota jest ujemna!\nZweryfikuj ją.",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","center",false,false,false,true)
				end
			else
				dxDrawText("#FF0000Wpisz jedynie cyfry!",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","center",false,false,false,true)
			end
		end

	elseif (wybor==3) then
		if not organizationmoney then return end
		dxDrawImage(sw/2-(360/2)/zoom,sh/2-(400/2)/zoom,360/zoom,400/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		dxDrawText("BANKOMAT",sw/2,sh/2-165/zoom,sw/2,sh/2-165/zoom,tocolor(255,255,255,230),0.9/zoom,font,"center","center")

		if checkPosition(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom) then a=255 else a=130 end
		dxDrawImage(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom,"images/back.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		dxDrawText("Obecnie na koncie organizacyjnym\nposiadasz #008000"..organizationmoney..".00 PLN#FFFFFF.",sw/2,sh/2-110/zoom,sw/2,sh/2-110/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","center",false,false,false,true)

		if checkPosition(sw/2-(35/2)/zoom-135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom) then a=255 else a=75 end
		dxDrawImage(sw/2-(35/2)/zoom-135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"images/left.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		if checkPosition(sw/2-(35/2)/zoom+135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom) then a=255 else a=75 end
		dxDrawImage(sw/2-(35/2)/zoom+135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"images/right.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		dxDrawText("Wpisz kwotę wykonywanej transakcji",sw/2,sh/2-30/zoom,sw/2,sh/2-30/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","center")
		dxDrawText("Wybierz typ transakcji",sw/2,sh/2+90/zoom,sw/2,sh/2+90/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","center")
		if elements[5] and isElement(elements[5]) then
			local sx,sy = guiGetPosition(elements[5],false)
			local sizex,sizey = guiGetSize(elements[5],false)
			if checkPosition(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom) then a=255 else a=100 end
			dxDrawImage(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))

			if guiGetText(elements[5]) ~= actions[wybor][action] then guiSetText(elements[5],actions[wybor][action]) end
			dxDrawText(guiGetText(elements[5]),sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.75/zoom,font,"center","center")
		end a=nil

		if guiGetText(elements[2]) ~= "" then
			if tonumber(guiGetText(elements[2])) then
				if tonumber(guiGetText(elements[2]))>0 then
					if tonumber(guiGetText(elements[2]))<1000000 then
						dxDrawText("#008000Podana liczba jest prawidłowa.\nPotwierdź transakcję przyciskiem poniżej.",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.75/zoom,font,"center","center",false,false,false,true)
					else
						dxDrawText("#FF0000Na jedną transakcję przypada limit\nna kwotę poniżej 1.000.000 PLN!",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
					end
				else
					dxDrawText("#FF0000Podana kwota jest ujemna!\nZweryfikuj ją.",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
				end
			else
				dxDrawText("#FF0000Wpisz jedynie cyfry!",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
			end
		end
	elseif (wybor==4) then -- konto biznesu
		if not businessmoney then return end
		dxDrawImage(sw/2-(360/2)/zoom,sh/2-(400/2)/zoom,360/zoom,400/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		dxDrawText("BANKOMAT",sw/2,sh/2-165/zoom,sw/2,sh/2-165/zoom,tocolor(255,255,255,230),0.9/zoom,font,"center","center")

		if checkPosition(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom) then a=255 else a=130 end
		dxDrawImage(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom,"images/back.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		dxDrawText("Obecnie na koncie biznesowym\nposiadasz #008000"..businessmoney..".00 PLN#FFFFFF.",sw/2,sh/2-110/zoom,sw/2,sh/2-110/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)

		if checkPosition(sw/2-(35/2)/zoom-135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom) then a=255 else a=75 end
		dxDrawImage(sw/2-(35/2)/zoom-135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"images/left.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		if checkPosition(sw/2-(35/2)/zoom+135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom) then a=255 else a=75 end
		dxDrawImage(sw/2-(35/2)/zoom+135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"images/right.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		dxDrawText("Wpisz kwotę wykonywanej transakcji",sw/2,sh/2-30/zoom,sw/2,sh/2-30/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center")
		dxDrawText("Wybierz typ transakcji",sw/2,sh/2+90/zoom,sw/2,sh/2+90/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center")
		if elements[5] and isElement(elements[5]) then
			local sx,sy = guiGetPosition(elements[5],false)
			local sizex,sizey = guiGetSize(elements[5],false)
			if checkPosition(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom) then a=255 else a=100 end
			dxDrawImage(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))

			if guiGetText(elements[5]) ~= actions[wybor][action] then guiSetText(elements[5],actions[wybor][action]) end
			dxDrawText(guiGetText(elements[5]),sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.7/zoom,font,"center","center")
		end a=nil

		if guiGetText(elements[2]) ~= "" then
			if tonumber(guiGetText(elements[2])) then
				if tonumber(guiGetText(elements[2]))>0 then
					if tonumber(guiGetText(elements[2]))<1000000 then
						dxDrawText("#008000Podana liczba jest prawidłowa.\nPotwierdź transakcję przyciskiem poniżej.",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
					else
						dxDrawText("#FF0000Na jedną transakcję przypada limit\nna kwotę poniżej 1.000.000 PLN!",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
					end
				else
					dxDrawText("#FF0000Podana kwota jest ujemna!\nZweryfikuj ją.",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
				end
			else
				dxDrawText("#FF0000Wpisz jedynie cyfry!",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
			end
		end
	elseif wybor == 5 then
		dxDrawImage(sw/2-(360/2)/zoom,sh/2-(400/2)/zoom,360/zoom,400/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		dxDrawText("BANKOMAT",sw/2,sh/2-165/zoom,sw/2,sh/2-165/zoom,tocolor(255,255,255,230),0.9/zoom,font,"center","center")

		if checkPosition(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom) then a=255 else a=130 end
		dxDrawImage(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom,"images/back.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		dxDrawText("Obecnie na swoim koncie firmowym\nposiadasz #008000"..company_Account..".00 PLN#FFFFFF.",sw/2,sh/2-110/zoom,sw/2,sh/2-110/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)

		if checkPosition(sw/2-(35/2)/zoom-135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom) then a=255 else a=75 end
		dxDrawImage(sw/2-(35/2)/zoom-135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"images/left.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		if checkPosition(sw/2-(35/2)/zoom+135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom) then a=255 else a=75 end
		dxDrawImage(sw/2-(35/2)/zoom+135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"images/right.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		dxDrawText("Wpisz kwotę wykonywanej transakcji",sw/2,sh/2-30/zoom,sw/2,sh/2-30/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center")
		--dxDrawText("Wybierz typ transakcji",sw/2,sh/2+90/zoom,sw/2,sh/2+90/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center")
		if elements[5] and isElement(elements[5]) then
			local sx,sy = guiGetPosition(elements[5],false)
			local sizex,sizey = guiGetSize(elements[5],false)
			if checkPosition(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom) then a=255 else a=100 end
			dxDrawImage(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))

			if guiGetText(elements[5]) ~= actions[wybor][action] then guiSetText(elements[5],actions[wybor][action]) end
			dxDrawText(guiGetText(elements[5]),sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.7/zoom,font,"center","center")
		end a=nil

		if guiGetText(elements[2]) ~= "" then
			if tonumber(guiGetText(elements[2])) then
				if tonumber(guiGetText(elements[2]))>0 then
					if tonumber(guiGetText(elements[2]))<1000000 then
						dxDrawText("#008000Podana liczba jest prawidłowa.\nPotwierdź transakcję przyciskiem poniżej.",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
					else
						dxDrawText("#FF0000Na jedną transakcję przypada limit\nna kwotę poniżej 1.000.000 PLN!",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
					end
				else
					dxDrawText("#FF0000Podana kwota jest ujemna!\nZweryfikuj ją.",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
				end
			else
				dxDrawText("#FF0000Wpisz jedynie cyfry!",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
			end
		end
	elseif (wybor==6) then -- konto administracyjne
		dxDrawImage(sw/2-(360/2)/zoom,sh/2-(400/2)/zoom,360/zoom,400/zoom,"images/main.png",0,0,0,tocolor(255,255,255,255))
		dxDrawText("BANKOMAT",sw/2,sh/2-165/zoom,sw/2,sh/2-165/zoom,tocolor(255,255,255,230),0.9/zoom,font,"center","center")

		if checkPosition(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom) then a=255 else a=130 end
		dxDrawImage(sw/2-(19/2)/zoom+155/zoom,sh/2-(19/2)/zoom-165/zoom,19/zoom,19/zoom,"images/back.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		dxDrawText("Obecnie na koncie administracyjnym\njest #008000"..admin_Account..".00 PLN#FFFFFF.",sw/2,sh/2-110/zoom,sw/2,sh/2-110/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)

		if checkPosition(sw/2-(35/2)/zoom-135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom) then a=255 else a=75 end
		dxDrawImage(sw/2-(35/2)/zoom-135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"images/left.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		if checkPosition(sw/2-(35/2)/zoom+135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom) then a=255 else a=75 end
		dxDrawImage(sw/2-(35/2)/zoom+135/zoom,sh/2-(35/2)/zoom+125/zoom,35/zoom,35/zoom,"images/right.png",0,0,0,tocolor(255,255,255,a or 255)) a=nil

		dxDrawText("Wpisz kwotę wykonywanej transakcji",sw/2,sh/2-30/zoom,sw/2,sh/2-30/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center")
		dxDrawText("Wybierz typ transakcji",sw/2,sh/2+90/zoom,sw/2,sh/2+90/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center")
		if elements[5] and isElement(elements[5]) then
			local sx,sy = guiGetPosition(elements[5],false)
			local sizex,sizey = guiGetSize(elements[5],false)
			if checkPosition(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom) then a=255 else a=100 end
			dxDrawImage(sw/2-(200/2)/zoom,sh/2-(40/2)/zoom+125/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))

			if guiGetText(elements[5]) ~= actions[wybor][action] then guiSetText(elements[5],actions[wybor][action]) end
			dxDrawText(guiGetText(elements[5]),sx,sy,sx+sizex,sy+sizey,tocolor(255,255,255,a or 155),0.7/zoom,font,"center","center")
		end a=nil

		if guiGetText(elements[2]) ~= "" then
			if tonumber(guiGetText(elements[2])) then
				if tonumber(guiGetText(elements[2]))>0 then
					if tonumber(guiGetText(elements[2]))<1000000 then
						dxDrawText("#008000Podana liczba jest prawidłowa.\nPotwierdź transakcję przyciskiem poniżej.",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
					else
						dxDrawText("#FF0000Na jedną transakcję przypada limit\nna kwotę poniżej 1.000.000 PLN!",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
					end
				else
					dxDrawText("#FF0000Podana kwota jest ujemna!\nZweryfikuj ją.",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
				end
			else
				dxDrawText("#FF0000Wpisz jedynie cyfry!",sw/2,sh/2+55/zoom,sw/2,sh/2+55/zoom,tocolor(235,235,235,210),0.7/zoom,font,"center","center",false,false,false,true)
			end
		end
	end
end

addEventHandler("onClientGUIClick",resourceRoot,function()
	local text = guiGetText(source)
	if (text=="close[1]") then
		showGUI(localPlayer,"ukryj")
	elseif (text=="back[2]") then
		showGUI(localPlayer,"pokaz")
	elseif (text=="left[1]") then
		action = action - 1
		if action < 1 then action = #actions[wybor] end
	elseif (text=="right[1]") then
		action = action + 1
		if action > #actions[wybor] then action = 1 end
	elseif (text=="next[1]") then
		if action == 1 then
			wybor,action=2,1
			showButtons()
		elseif action == 2 then
			if timer2 and isTimer(timer2) then return end
			timer2 = setTimer(function() timer2=nil end,2500,1)
			if getElementData(localPlayer,"organizacja") then
				triggerServerEvent("CS:bankomaty:server",localPlayer,localPlayer,nil,"pobierzdane","organizacja")
			else
				outputChatBox("#FF0000★ #FFFFFFNie należysz do żadnej organizacji!",0,0,0,true)
			end
		elseif action == 3 then
			if timer2 and isTimer(timer2) then return end
			timer2 = setTimer(function() timer2=nil end,2500,1)
			if getElementData(localPlayer,"biznes") then
				triggerServerEvent("CS:bankomaty:server",localPlayer,localPlayer,nil,"pobierzdane","biznes")
			else
				outputChatBox("#FF0000★ #FFFFFFNie należysz do żadnej organizacji!",0,0,0,true)
			end
		elseif action == 4 then
			if timer2 and isTimer(timer2) then return end
			timer2 = setTimer(function() timer2=nil end,2500,1)
			triggerServerEvent("CS:bankomaty:server",localPlayer,localPlayer,nil,"pobierzdane","company")
	elseif action == 5 then
		if timer2 and isTimer(timer2) then return end
		timer2 = setTimer(function() timer2=nil end,2500,1)
		if getElementData(localPlayer,"admin:rank") == "RCON" or getElementData(localPlayer, "admin:rank") == "Globaladministrator" then
			triggerServerEvent("CS:bankomaty:server",localPlayer,localPlayer,nil,"pobierzdane","admin")
		else
			outputChatBox("#ff0000★ #ffffffNie należysz do administracji serwera.", 0,0,0, true)
		end
	end
	elseif (text=="Wypłać środki z konta") then
		if timer and isTimer(timer) then return end
		timer = setTimer(function() timer=nil end,1500,1)
		local kwota = guiGetText(elements[2])
		if kwota~="" and tonumber(kwota) and tonumber(kwota) >= 1 and tonumber(kwota)<1000000 then
			kwota = math.floor(kwota)
			guiSetText(elements[2],"")
			if (wybor==2) then
				triggerServerEvent("CS:bankomaty:server",localPlayer,localPlayer,"prywatne","wyplata",kwota)
			elseif (wybor==3) then
				triggerServerEvent("CS:bankomaty:server",localPlayer,localPlayer,"organizacja","wyplata",kwota)
			elseif (wybor==4) then
				triggerServerEvent("CS:bankomaty:server",localPlayer,localPlayer,"biznes","wyplata",kwota)
			elseif (wybor==5) then
				triggerServerEvent("CS:bankomaty:server",localPlayer,localPlayer,"firma","wyplata",kwota)
			elseif (wybor==6) then
				triggerServerEvent("CS:bankomaty:server",localPlayer,localPlayer,"admin","wyplata",kwota)
			end
		end
	elseif (text=="Wpłać środki na konto") then
		if timer and isTimer(timer) then return end
		timer = setTimer(function() timer=nil end,1500,1)
		local kwota = guiGetText(elements[2])
		if kwota~="" and tonumber(kwota) and tonumber(kwota) >= 1 and tonumber(kwota)<1000000 then
			kwota = math.floor(kwota)
			guiSetText(elements[2],"")
			if (wybor==2) then
				triggerServerEvent("CS:bankomaty:server",localPlayer,localPlayer,"prywatne","wplata",kwota)
			elseif (wybor==3) then
				triggerServerEvent("CS:bankomaty:server",localPlayer,localPlayer,"organizacja","wplata",kwota)
			elseif (wybor==4) then
				triggerServerEvent("CS:bankomaty:server",localPlayer,localPlayer,"biznes","wplata",kwota)
			elseif (wybor==6) then
				triggerServerEvent("CS:bankomaty:server",localPlayer,localPlayer,"admin","wplata",kwota)
			end
		end
	end
end)

function showGUI(plr,typ,dane)
	if plr and isElement(plr) then
		if (typ=="pokaz") then
			wybor,action=1,1
			organizationmoney=nil
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
			wybor,action=nil
			organizationmoney=nil
		elseif (typ=="kontoorganizacji") then
			if dane then organizationmoney=dane end
			if not organizationmoney then outputChatBox("#FF0000★ #FFFFFFBrak pobranych danych!",0,0,0,true) return end
			wybor,action=3,1
			showCursor(true)
			showButtons()
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
		elseif (typ=="kontobiznesu") then
			if dane then businessmoney=dane end
			if not businessmoney then outputChatBox("#FF0000★ #FFFFFFBrak pobranych danych!",0,0,0,true) return end
			wybor,action=4,1
			showCursor(true)
			showButtons()
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
			outputChatBox("Pobrane dane dot. konta biznesowego.")
		elseif (typ=="company_Account") then
			if dane then company_Account = dane end
			if not company_Account then outputChatBox("#FF0000★ #FFFFFFBrak pobranych danych!",0,0,0,true) return end
			wybor,action=5,1
			showCursor(true)
			showButtons()
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
			outputChatBox("Pobrane dane dot. konta firmowego.")
		elseif (typ=="admin_Account") then
			if dane then admin_Account = dane end
			if not admin_Account then outputChatBox("#FF0000★ #FFFFFFBrak pobranych danych!",0,0,0,true) return end
			wybor,action=6,1
			showCursor(true)
			showButtons()
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
			outputChatBox("Pobrane dane dot. konta administracyjnego.")
		end
	end
end
addEvent("CS:bankomaty:client",true)
addEventHandler("CS:bankomaty:client",root,showGUI)
