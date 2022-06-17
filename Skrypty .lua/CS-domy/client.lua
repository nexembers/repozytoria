--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--

bindKey("i","both",function(_,state)
	if state == "down" then
		for _,v in ipairs(getElementsByType("pickup",resourceRoot)) do
			if getElementData(v,"house:free") then
				createBlipAttachedTo(v,31,2,255,0,0,255,100,450)
			else
				createBlipAttachedTo(v,32,2,255,0,0,255,100,450)
			end
		end
	else
		for _,v in ipairs(getElementsByType("blip",resourceRoot)) do
			destroyElement(v)
			v=nil
		end
	end
end)

local font = exports["CS-fonts"]:font("main")
local sw,sh = guiGetScreenSize()
local wybor=nil
local elements = {}
local dane = nil
local wejscie = false
local actual = 1

function isEventHandlerAdded(sEventName,pElementAttachedTo,func)
	if type(sEventName)=='string' and isElement(pElementAttachedTo) and type(func)=='function' then local aAttachedFunctions = getEventHandlers(sEventName,pElementAttachedTo)
	if type(aAttachedFunctions)=='table' and #aAttachedFunctions > 0 then for i,v in ipairs(aAttachedFunctions) do if v==func then return true end end end end return false
end

local zoom = 1
if sw < 1920 then zoom = math.min(1.25,1920/sw) end -- domyślny

function checkButtons()
	if (#elements>0) then
		for _,v in ipairs(elements) do if v and isElement(v) then destroyElement(v) v=nil end end
		elements = {}
	end
end

function showButtons()
	checkButtons()
	if (wybor==1) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+185/zoom,sh/2-(19/2)/zoom-214/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[1],0)
		elements[2] = guiCreateButton(sw/2-(200/2)/zoom+75/zoom,sh/2-(40/2)/zoom+200/zoom,200/zoom,40/zoom,"buy[1]",false) guiSetAlpha(elements[2],0)
		elements[3] = guiCreateComboBox(sw/2-(200/2)/zoom+75/zoom,sh/2-(50/2)/zoom-65/zoom,200/zoom,52,"      - - - rozwiń listę - - -",false) guiSetAlpha(elements[3],0.7)
		guiComboBoxAddItem(elements[3],"Gotówka")
		elements[4] = guiCreateEdit(sw/2-(200/2)/zoom+75/zoom,sh/2-(30/2)/zoom+35/zoom,200/zoom,30/zoom,1,false) guiSetAlpha(elements[4],0.7)
	elseif (wybor==2) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+185/zoom,sh/2-(19/2)/zoom-214/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[1],0)
	elseif (wybor==3) then
		elements[1] = guiCreateButton(sw/2-(19/2)/zoom+185/zoom,sh/2-(19/2)/zoom-214/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[1],0)
		
		elements[2] = guiCreateButton(sw/2-(100/2)/zoom-135/zoom,sh/2-(100/2)/zoom-115/zoom,100/zoom,100/zoom,"info[3]",false) guiSetAlpha(elements[2],0)
		elements[3] = guiCreateButton(sw/2-(100/2)/zoom-135/zoom,sh/2-(100/2)/zoom-115/zoom+101/zoom,100/zoom,100/zoom,"lock/close[3]",false) guiSetAlpha(elements[3],0)
		elements[4] = guiCreateButton(sw/2-(100/2)/zoom-135/zoom,sh/2-(100/2)/zoom-115/zoom+202/zoom,100/zoom,100/zoom,"extend[3]",false) guiSetAlpha(elements[4],0)
		elements[5] = guiCreateButton(sw/2-(100/2)/zoom-135/zoom,sh/2-(100/2)/zoom-115/zoom+303/zoom,100/zoom,100/zoom,"options[3]",false) guiSetAlpha(elements[5],0)
		if (actual==3) then -- opłacanie
			elements[6] = guiCreateButton(sw/2-(19/2)/zoom+185/zoom,sh/2-(19/2)/zoom-214/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[6],0)
			elements[7] = guiCreateButton(sw/2-(200/2)/zoom+75/zoom,sh/2-(40/2)/zoom+200/zoom,200/zoom,40/zoom,"extend_days[3]",false) guiSetAlpha(elements[7],0)
			elements[8] = guiCreateComboBox(sw/2-(200/2)/zoom+75/zoom,sh/2-(50/2)/zoom-65/zoom,200/zoom,52,"      - - - rozwiń listę - - -",false) guiSetAlpha(elements[8],0.7)
			guiComboBoxAddItem(elements[8],"Gotówka")
			elements[9] = guiCreateEdit(sw/2-(200/2)/zoom+75/zoom,sh/2-(30/2)/zoom+35/zoom,200/zoom,30/zoom,1,false) guiSetAlpha(elements[9],0.7)
		elseif (actual==4) then -- opcje
			elements[6] = guiCreateButton(sw/2-(19/2)/zoom+185/zoom,sh/2-(19/2)/zoom-214/zoom,19/zoom,19/zoom,"close[1]",false) guiSetAlpha(elements[6],0)
			if dane[5] == "stacja-nos" then
				elements[7] = guiCreateButton(sw/2-(200/2)/zoom+75/zoom,sh/2-(40/2)/zoom+150/zoom,200/zoom,40/zoom,"nos_price[1]",false) guiSetAlpha(elements[7],0)
			else
				elements[7] = guiCreateButton(sw/2-(200/2)/zoom+75/zoom,sh/2-(40/2)/zoom+150/zoom,200/zoom,40/zoom,"occupants[3]",false) guiSetAlpha(elements[7],0)
				elements[8] = guiCreateButton(sw/2-(200/2)/zoom+75/zoom,sh/2-(40/2)/zoom+200/zoom,200/zoom,40/zoom,"release[3]",false) guiSetAlpha(elements[8],0)
			end
		end
	end
end



local pos = {
	one = {
		main = {sw/2-(400/2)/zoom,sh/2-(400/2)/zoom,400/zoom,400/zoom,"images/main.png"},
		
		info = {sw/2-(75/2)/zoom-135/zoom,sh/2-(72/2)/zoom-150/zoom,75/zoom,72/zoom,"images/house.png"},
		lock = {sw/2-(75/2)/zoom-135/zoom,sh/2-(72/2)/zoom-50/zoom,75/zoom,72/zoom,"images/lock.png"},
		payment = {sw/2-(75/2)/zoom-135/zoom,sh/2-(72/2)/zoom+50/zoom,75/zoom,72/zoom,"images/payment.png"},
		settings = {sw/2-(75/2)/zoom-135/zoom,sh/2-(72/2)/zoom+150/zoom,75/zoom,72/zoom,"images/settings.png"},
	},
}

local config = {
	actual=pos.one.info,
	alphaofnotouch=120,
	select=1,
}

function checkposition(arg1,arg2,arg3,arg4)
	local x,y = getCursorPosition()
	if not x then return end
	if x*sw >= arg1 and y*sh <= arg2+arg4 and x*sw <= arg1+arg3 and y*sh >= arg2 then return true else return false end
end


function onRender()
	local x,y = getCursorPosition()
	if not x then showGUI(localPlayer,"ukryj") return end
	if (wybor==1) then -- dom do wynajęcia...
		dxDrawImage(pos.one.main[1],pos.one.main[2],pos.one.main[3],pos.one.main[4],pos.one.main[5],0,0,0,tocolor(255,255,255,255))


		if config.actual==pos.one.info then
			pos.one.info[5]="images/house_p.png"
			a=255
		else
			pos.one.info[5]="images/house.png" a=config.alphaofnotouch
			if checkposition(pos.one.info[1],pos.one.info[2],pos.one.info[3],pos.one.info[4]) then
				pos.one.info[5]="images/house.png" a=255
				if getKeyState("mouse1") then
					if not state then
						state=true
						config.actual=pos.one.info
						checkButtons()
						config.select=1
					end
				else
					state=nil
				end
			else
				pos.one.info[5]="images/house.png" a=config.alphaofnotouch
			end
		end
		dxDrawImage(pos.one.info[1],pos.one.info[2],pos.one.info[3],pos.one.info[4],pos.one.info[5],0,0,0,tocolor(255,255,255,a or config.alphaofnotouch))
		a=nil

		if config.select == 1 then
			dxDrawText("ID nieruchomości: #81b1d3"..dane[1].."#FFFFFF.",sw/2+62/zoom,sh/2-164/zoom,sw/2+62/zoom,sh/2-164/zoom,tocolor(255,255,255,235),1.5/zoom,"default-bold","center","center",false,false,false,true)
			dxDrawText("Koszt opłaty nieruchomości\n#81b1d3"..dane[2]..".00 PLN #FFFFFF/ #81b1d3dzień#FFFFFF",sw/2+62/zoom,sh/2-100/zoom,sw/2+62/zoom,sh/2-100/zoom,tocolor(255,255,255,220),1.25/zoom,"default-bold","center","center",false,false,false,true)
			dxDrawText("Wpisz liczbę dni, na którą chcesz\nwykupić nieruchomość",sw/2+62/zoom,sh/2,sw/2+62/zoom,sh/2,tocolor(255,255,255,220),1.25/zoom,"default-bold","center","center")

			if not elements[1] then
				elements[1] = guiCreateEdit(sw/2-(75/2)/zoom+62/zoom,sh/2-(40/2)/zoom+50/zoom,75/zoom,40/zoom,"",false) guiSetAlpha(elements[1],0.75)
				guiEditSetMaxLength(elements[1],3)
			end
			if elements[1] and isElement(elements[1]) then
				text="brak"
				local txt = guiGetText(elements[1])
				if string.len(txt)<1 then
					text="#FFFFFFWprowadź odpowiednią liczbę dni."
				elseif string.len(txt)>0 then
					if tonumber(txt) then
						if tonumber(txt)>0 then
							guiSetText(elements[1],math.floor(txt))
							text="#FFFFFFKoszt opłaty na "..txt.." dni\n#00FF00"..tonumber(txt)*dane[2].." PLN#FFFFFF"

							if checkposition(sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+145/zoom,200/zoom,40/zoom) then
								ab=255
								if getKeyState("mouse1") then
									if not state then
										state=true
										local id,cost,dni = dane[1],dane[2]*tonumber(txt),tonumber(txt)
										if id and tonumber(id) and cost and tonumber(cost) and dni and tonumber(dni) then
											triggerServerEvent("CS:domy:server",localPlayer,localPlayer,"wynajmij",{"Gotówka",id,cost,dni})
										end
									end
								else
									state=false
								end
							else
								ab=120
							end
							dxDrawImage(sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+145/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,ab or 255))
							dxDrawText("WYNAJMIJ DOM",sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+145/zoom,sw/2-(200/2)/zoom+62/zoom+200/zoom,sh/2-(40/2)/zoom+145/zoom+40/zoom,tocolor(255,255,255,ab or 255),1.25/zoom,"default-bold","center","center")
							ab=nil
						else
							text="#FF0000Wprowadzono niepoprawną\nilość dni!"
						end
					else
						text="#FF0000Wprowadzono niepoprawną\nilość dni!"
					end
				end
				dxDrawText(text,sw/2+62/zoom,sh/2+100/zoom,sw/2+62/zoom,sh/2+100/zoom,tocolor(255,255,255,255),1.25/zoom,"default-bold","center","center",false,false,false,true)
			end

			dxDrawText("(( podgląd domu - wciśnij #81b1d3klawisz e#FFFFFF ))",sw/2+62/zoom,sh/2+180/zoom,sw/2+62/zoom,sh/2+180/zoom,tocolor(255,255,255,255),1/zoom,"default-bold","center","center",false,false,false,true)
			if getKeyState("e") then
				if not statekey then
					statekey=true
					triggerServerEvent("CS:domy:server:move",localPlayer,localPlayer)
					showGUI(localPlayer,"ukryj")
				end
			else
				statekey=false
			end
		end
	elseif (wybor==2) then -- dom wynajęty, ale nie przez właściciela...
		dxDrawImage(pos.one.main[1],pos.one.main[2],pos.one.main[3],pos.one.main[4],pos.one.main[5],0,0,0,tocolor(255,255,255,255))
		if config.actual==pos.one.info then
			pos.one.info[5]="images/house_p.png"
			a=255
		else
			pos.one.info[5]="images/house.png" a=config.alphaofnotouch
			if checkposition(pos.one.info[1],pos.one.info[2],pos.one.info[3],pos.one.info[4]) then
				pos.one.info[5]="images/house.png" a=255
				if getKeyState("mouse1") then
					if not state then
						state=true
						config.actual=pos.one.info
						checkButtons()
						config.select=1
					end
				else
					state=nil
				end
			else
				pos.one.info[5]="images/house.png" a=config.alphaofnotouch
			end
		end
		dxDrawImage(pos.one.info[1],pos.one.info[2],pos.one.info[3],pos.one.info[4],pos.one.info[5],0,0,0,tocolor(255,255,255,a or config.alphaofnotouch))
		a=nil

		if config.select == 1 then
			dxDrawText("ID nieruchomości: #81b1d3"..dane[1].."#FFFFFF.",sw/2+62/zoom,sh/2-175/zoom,sw/2+62/zoom,sh/2-175/zoom,tocolor(255,255,255,235),1.5/zoom,"default-bold","center","center",false,false,false,true)
			local czas = dane[3]
			if czas>24 then
				info1=math.floor(czas/24)
				info2=czas-(info1*24)
				if info1 == 1 then info1 = info1.." dzień" else info1= info1.." dni" end
				if info2 == 1 then info2 = info2.." godzinę" elseif info2>1 and info2<5 then info2=info2.." godziny" else info2 = info2.." godzin" end
				if info2 == "0 godzin" then
					czas_text = info1
				else
					czas_text = info1.." i "..info2
				end
			else
				if czas == 1 then czas_text = czas.." godzinę" elseif czas>1 and czas<5 then czas=czas.." godziny" else czas_text = czas.." godzin" end
				if not tonumber(czas) then czas_text = czas end
			end
			if not czas_text then czas_text = 'brak informacji - błąd' end
			dxDrawText("Nieruchomość została już wynajęta\nprzez gracza o loginie\n#81b1d3"..dane[2].."\n\n\n\n#FFFFFFDo końca wynajmu niniejszej\nnieruchomości pozostało#81b1d3\n"..czas_text.."#FFFFFF.",sw/2+62/zoom,sh/2-50/zoom,sw/2+62/zoom,sh/2-50/zoom,tocolor(255,255,255,220),1.25/zoom,"default-bold","center","center",false,false,false,true)
			
			dxDrawText("(( podgląd domu - wciśnij #81b1d3klawisz e#FFFFFF ))",sw/2+62/zoom,sh/2+180/zoom,sw/2+62/zoom,sh/2+180/zoom,tocolor(255,255,255,255),1/zoom,"default-bold","center","center",false,false,false,true)
			if getKeyState("e") then
				if not statekey then
					statekey=true
					triggerServerEvent("CS:domy:server:move",localPlayer,localPlayer)
					showGUI(localPlayer,"ukryj")
				end
			else
				statekey=false
			end
		end
	elseif (wybor==3) then -- dom wynajęty, przez właściciela.
		dxDrawImage(pos.one.main[1],pos.one.main[2],pos.one.main[3],pos.one.main[4],pos.one.main[5],0,0,0,tocolor(255,255,255,255))


		if config.actual==pos.one.info then
			pos.one.info[5]="images/house_p.png"
			a=255
		else
			pos.one.info[5]="images/house.png" a=config.alphaofnotouch
			if checkposition(pos.one.info[1],pos.one.info[2],pos.one.info[3],pos.one.info[4]) then
				pos.one.info[5]="images/house.png" a=255
				if getKeyState("mouse1") then
					if not state then
						state=true
						config.actual=pos.one.info
						checkButtons()
						config.select=1
					end
				else
					state=nil
				end
			else
				pos.one.info[5]="images/house.png" a=config.alphaofnotouch
			end
		end
		dxDrawImage(pos.one.info[1],pos.one.info[2],pos.one.info[3],pos.one.info[4],pos.one.info[5],0,0,0,tocolor(255,255,255,a or config.alphaofnotouch))
		a=nil

		local czas = dane[2]
		if czas and czas>24 then
			info1=math.floor(czas/24)
			info2=czas-(info1*24)
			if info1 == 1 then info1 = info1.." dzień" else info1= info1.." dni" end
			if info2 == 1 then info2 = info2.." godzina" elseif info2>1 and info2<5 then info2=info2.." godziny" else info2 = info2.." godzin" end
			if info2 == "0 godzin" then
				czas_text = info1
			else
				czas_text = info1.." i "..info2
			end
		else
			if czas == 1 then czas_text = czas.." godzina" elseif czas>1 and czas<5 then czas=czas.." godziny" else czas_text = czas.." godzin" end
			if not tonumber(czas) then czas_text = czas end
		end
		if not czas_text then czas_text = 'brak informacji - błąd' end
		if dane[4]==0 then
			lock_info="#339933otwarty#FFFFFF"
		else
			lock_info="#CC0000zamknięty#FFFFFF"
		end

		if config.select == 1 then
			dxDrawText("ID domu: #81b1d3"..dane[1].."#FFFFFF.",sw/2+62/zoom,sh/2-175/zoom,sw/2+62/zoom,sh/2-175/zoom,tocolor(255,255,255,235),1.5/zoom,"default-bold","center","center",false,false,false,true)

			dxDrawText("Do końca wynajmu pozostało#81b1d3\n"..czas_text.."#FFFFFF.\n\nKoszt dodatkowego wynajmu\nna 1 dzień wynosi\n#81b1d3"..dane[3]..".00 PLN#FFFFFF.\n\nAktualnie dom jest "..lock_info..".\n\n\n\n\nMożesz zarządzać opcjami domu\nw pasku znajdującym się po lewej\nstronie panelu domu.",sw/2+62/zoom,sh/2-5/zoom,sw/2+62/zoom,sh/2-5/zoom,tocolor(255,255,255,220),1.25/zoom,"default-bold","center","center",false,false,false,true)
			

			dxDrawText("(( podgląd domu - wciśnij #81b1d3klawisz e#FFFFFF ))",sw/2+62/zoom,sh/2+180/zoom,sw/2+62/zoom,sh/2+180/zoom,tocolor(255,255,255,255),1/zoom,"default-bold","center","center",false,false,false,true)
			if getKeyState("e") then
				if not statekey then
					statekey=true
					triggerServerEvent("CS:domy:server:move",localPlayer,localPlayer)
					showGUI(localPlayer,"ukryj")
					return
				end
			else
				statekey=false
			end


		elseif config.select==3 then
			dxDrawText("ID nieruchomości: #81b1d3"..dane[1].."#FFFFFF.",sw/2+62/zoom,sh/2-164/zoom,sw/2+62/zoom,sh/2-164/zoom,tocolor(255,255,255,235),1.5/zoom,"default-bold","center","center",false,false,false,true)
			dxDrawText("Koszt opłaty nieruchomości\n#81b1d3"..dane[3]..".00 PLN #FFFFFF/ #81b1d3dzień#FFFFFF",sw/2+62/zoom,sh/2-100/zoom,sw/2+62/zoom,sh/2-100/zoom,tocolor(255,255,255,220),1.25/zoom,"default-bold","center","center",false,false,false,true)
			dxDrawText("Wpisz liczbę dni, na którą chcesz\nprzedłużyć najem nieruchomości",sw/2+62/zoom,sh/2,sw/2+62/zoom,sh/2,tocolor(255,255,255,220),1.25/zoom,"default-bold","center","center")
			if not elements[1] then
				elements[1] = guiCreateEdit(sw/2-(75/2)/zoom+62/zoom,sh/2-(40/2)/zoom+50/zoom,75/zoom,40/zoom,"",false) guiSetAlpha(elements[1],0.75)
				guiEditSetMaxLength(elements[1],3)
			end
			if elements[1] and isElement(elements[1]) then
				text="brak"
				local txt = guiGetText(elements[1])
				if string.len(txt)<1 then
					text="#FFFFFFWprowadź odpowiednią liczbę dni."
				elseif string.len(txt)>0 then
					if tonumber(txt) then
						if tonumber(txt)>0 then
							guiSetText(elements[1],math.floor(txt))
							text="#FFFFFFKoszt opłaty na "..txt.." dni\n#00FF00"..tonumber(txt)*dane[3].." PLN#FFFFFF"

							if checkposition(sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+170/zoom,200/zoom,40/zoom) then
								ab=255
								if getKeyState("mouse1") then
									if not state then
										state=true
										local id,cost,dni = dane[1],dane[3]*tonumber(txt),tonumber(txt)
										if id and tonumber(id) and cost and tonumber(cost) and dni and tonumber(dni) then
											triggerServerEvent("CS:domy:server",localPlayer,localPlayer,"przedluz",{"Gotówka",id,cost,dni})
										end
									end
								else
									state=false
								end
							else
								ab=120
							end
							dxDrawImage(sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+170/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,ab or 255))
							dxDrawText("PRZEDŁUŻ NAJEM",sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+170/zoom,sw/2-(200/2)/zoom+62/zoom+200/zoom,sh/2-(40/2)/zoom+170/zoom+40/zoom,tocolor(255,255,255,ab or 255),1.25/zoom,"default-bold","center","center")
							ab=nil
						else
							text="#FF0000Wprowadzono niepoprawną\nilość dni!"
						end
					else
						text="#FF0000Wprowadzono niepoprawną\nilość dni!"
					end
				end
				dxDrawText(text,sw/2+62/zoom,sh/2+100/zoom,sw/2+62/zoom,sh/2+100/zoom,tocolor(255,255,255,255),1.25/zoom,"default-bold","center","center",false,false,false,true)
			end
		elseif config.select == 4 then
			if dane[5] ~= "stacja-nos" then
				dxDrawText("ID domu: #81b1d3"..dane[1].."#FFFFFF.",sw/2+62/zoom,sh/2-175/zoom,sw/2+62/zoom,sh/2-175/zoom,tocolor(255,255,255,235),1.5/zoom,"default-bold","center","center",false,false,false,true)
				
				dxDrawText("Do końca wynajmu pozostało#81b1d3\n"..czas_text.."#FFFFFF.\n\nAktualnie dom jest "..lock_info..".\n\n\nJeśli uważasz, że ta nieruchomość\nnie jest już Tobie potrzebna,\nzwolnij ją przyciskiem poniżej.",sw/2+62/zoom,sh/2-50/zoom,sw/2+62/zoom,sh/2-50/zoom,tocolor(255,255,255,220),1.2/zoom,"default-bold","center","center",false,false,false,true)
				
				if checkposition(sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+60/zoom,200/zoom,40/zoom) then
					a=255
					if getKeyState("mouse1") then
						if not state then
							state=true
							czyZwolnij=czyZwolnij+1
							if timerzw and isTimer(timerzw) then killTimer(timerzw) end
							timerzw = setTimer(function()
								if czyZwolnij<2 then
									czyZwolnij=0
									triggerEvent("CS:powiadomienie",localPlayer,localPlayer,{"error","Nie dokonano potwierdzenia\nczynności zwolnienia domu!"})
								end
							end,4000,1)
							if czyZwolnij==2 then
								triggerServerEvent("CS:domy:server",localPlayer,localPlayer,"zwolnij",{dane[1]})
							else
								triggerEvent("CS:powiadomienie",localPlayer,localPlayer,{"info","Aby zwolnić dom, potwierdź\nswój wybór ponownie!"})
							end
						end
					else
						state=false
					end
				else
					a=config.alphaofnotouch
				end
				dxDrawImage(sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+60/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))
				dxDrawText("ZWOLNIJ DOM",sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+60/zoom,sw/2-(200/2)/zoom+62/zoom+200/zoom,sh/2-(40/2)/zoom+60/zoom+40/zoom,tocolor(255,255,255,a or 255),1.25/zoom,"default-bold","center","center")
				a=nil

				dxDrawText("Aby przejść do panelu zarządzania\nlokatorami domu, przyciśnij przycisk\nznajdujący się poniżej.",sw/2+62/zoom,sh/2+115/zoom,sw/2+62/zoom,sh/2+115/zoom,tocolor(255,255,255,220),1.2/zoom,"default-bold","center","center",false,false,false,true)
			
				if checkposition(sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+170/zoom,200/zoom,40/zoom) then
					a=255
					if getKeyState("mouse1") then
						if not state then
							state=true
							triggerServerEvent("CS:lokatorzy:server",localPlayer,localPlayer,"result",{dane[1]})
							showGUI(localPlayer,"ukryj")
						end
					else
						state=false
					end
				else
					a=config.alphaofnotouch
				end
				dxDrawImage(sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+170/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))
				dxDrawText("LOKATORZY",sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+170/zoom,sw/2-(200/2)/zoom+62/zoom+200/zoom,sh/2-(40/2)/zoom+170/zoom+40/zoom,tocolor(255,255,255,a or 255),1.25/zoom,"default-bold","center","center")
				a=nil
			else
				if not elements[1] then
					elements[1] = guiCreateEdit(sw/2-(75/2)/zoom+62/zoom,sh/2-(85)/zoom+50/zoom,75/zoom,30/zoom,"",false) guiSetAlpha(elements[1],0.75)
				end
				if not elements[2] then
					elements[2] = guiCreateEdit(sw/2-(75/2)/zoom+62/zoom,sh/2/zoom+50/zoom,75/zoom,30/zoom,"",false) guiSetAlpha(elements[2],0.75)
				end

				dxDrawText("ID domu: #81b1d3"..dane[1].."#FFFFFF.",sw/2+62/zoom,sh/2-175/zoom,sw/2+62/zoom,sh/2-175/zoom,tocolor(255,255,255,235),1.5/zoom,"default-bold","center","center",false,false,false,true)
				dxDrawText("Aktualna cena NOS:\n#81b1d3"..dane[6].." PLN/l \nZbiornik NO2: "..string.format("%.2f", tonumber(dane[8]) or 0).."l",sw/2+62/zoom,sh/2-140/zoom,sw/2+62/zoom,sh/2-120/zoom,tocolor(255,255,255,235),1.25/zoom,"default-bold","center","center",false,false,false,true)
				dxDrawText("Zmień cenę:\n#81b1d3MIN: 10 PLN, MAX: 50 PLN",sw/2+62/zoom,sh/2-120,sw/2+62/zoom,sh/2,tocolor(255,255,255,235),1.25/zoom,"default-bold","center","center",false,false,false,true)
				dxDrawText("Zakup podtlenku azotu :\n#81b1d3LIMIT: 1,000 l, CENA: "..dane[9].." PLN/l",sw/2+62/zoom,sh/2+50,sw/2+62/zoom,sh/2,tocolor(255,255,255,235),1.25/zoom,"default-bold","center","center",false,false,false,true)
				if checkposition(sw/2-(200/2)/zoom+62/zoom,sh/2-(70)/zoom+170/zoom,200/zoom,40/zoom) then
					a2=255
					if getKeyState("mouse1") then
						if not state then
							state=true
							local price = guiGetText(elements[2])
							if tonumber(price) ~= nil and tonumber(price) > 0 then
								if tonumber(price) <= dane[10] then
									if(tonumber(price + dane[8])) > (tonumber(dane[10]))then return outputChatBox("#FF0000✘ #FFFFFFZakup wykracza ponad 1000l", 255, 255, 255, true) end
									local toPay = tonumber(dane[9]) * tonumber(price);
									if(getPlayerMoney()) >= (toPay)then
										triggerServerEvent("CS-domy:nos-sation:setNO2State", localPlayer, dane[1], tonumber(price), toPay, dane[8])
										showGUI(localPlayer,"ukryj")
									else
										outputChatBox("#FF0000✘ #FFFFFFNie posiadasz tyle pieniedzy! Aby zakupic "..tonumber(price).." l nalezy zaplacic "..toPay.." PLN", 255, 255, 255, true)
									end
								end
							end
						end
					else
						state=false
					end
				else
					a2=config.alphaofnotouch
				end

				if(isElement(elements[2]))then
					local txt = guiGetText(elements[2]);
					if(not tonumber(txt))then guiSetText(elements[2], ""); txt = ""; end
					if(string.len(txt)) >= (1) and (tonumber(txt)) > (dane[10])then if(tonumber(dane[8]) < dane[10])then txt = dane[10] - tonumber(dane[8]) else txt = dane[10] end end;
					if(string.len(txt)) > (4)then txt = string.sub(txt, 1, 4); end
					if(string.len(txt)) >= (1) and (tonumber(txt)) < (0)then txt = "" end;
					guiSetText(elements[2], txt);
				end

				dxDrawImage(sw/2-(200/2)/zoom+62/zoom,sh/2-(70)/zoom+170/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a2 or 255))
				dxDrawText("ZAKUP NO2",sw/2-(200/2)/zoom+62/zoom,sh/2-(120)/zoom+170/zoom,sw/2-(200/2)/zoom+62/zoom+200/zoom,sh/2-(40/2)/zoom+170/zoom+40/zoom,tocolor(255,255,255,a2 or 255),1.5/zoom,"default-bold","center","center")
				
				if checkposition(sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+170/zoom,200/zoom,40/zoom) then
					a=255
					if getKeyState("mouse1") then
						if not state then
							state=true
							local price = guiGetText(elements[1])
							if tonumber(price) ~= nil and tonumber(price) > 0 then
								if tonumber(string.format("%.02f", price)) >= 10 and tonumber(string.format("%.02f", price)) <= 50 then
									triggerServerEvent("CS-domy:nos-sation:setPrice", localPlayer, dane[1], tonumber(string.format("%.02f", price)), dane[7])
									showGUI(localPlayer,"ukryj")
								else
									outputChatBox("#FF0000✘ #FFFFFFCena nie mieści się w podanym przedziale!", 255, 255, 255, true)
									showGUI(localPlayer,"ukryj")
								end
							end
						end
					else
						state=false
					end
				else
					a=config.alphaofnotouch
				end

				dxDrawImage(sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+170/zoom,200/zoom,40/zoom,"images/button.png",0,0,0,tocolor(255,255,255,a or 255))
				dxDrawText("ZMIEŃ CENĘ",sw/2-(200/2)/zoom+62/zoom,sh/2-(40/2)/zoom+170/zoom,sw/2-(200/2)/zoom+62/zoom+200/zoom,sh/2-(40/2)/zoom+170/zoom+40/zoom,tocolor(255,255,255,a or 255),1.5/zoom,"default-bold","center","center")
			end
		end

		
		if dane and dane[4]==0 then
			if checkposition(pos.one.lock[1],pos.one.lock[2],pos.one.lock[3],pos.one.lock[4]) then
				a=255
				if getKeyState("mouse1") then
					if not state then
						if not timer then
							timer = setTimer(function() timer=nil end,2000,1)
							triggerServerEvent("CS:domy:server",localPlayer,localPlayer,"zamknij",{dane[1]})
							dane={dane[1],dane[2],dane[3],1}
						end
					end
				else
					state=false
				end
			else
				a=config.alphaofnotouch
			end
			dxDrawImage(pos.one.lock[1],pos.one.lock[2],pos.one.lock[3],pos.one.lock[4],"images/lock.png",0,0,0,tocolor(255,255,255,a or 150))
		else
			if checkposition(pos.one.lock[1],pos.one.lock[2],pos.one.lock[3],pos.one.lock[4]) then
				a=255
				if getKeyState("mouse1") then
					if not state then
						if not timer then
							timer = setTimer(function() timer=nil end,2000,1)
							triggerServerEvent("CS:domy:server",localPlayer,localPlayer,"otworz",{dane[1]})
							dane={dane[1],dane[2],dane[3],0}
						end
					end
				else
					state=false
				end
			else
				a=config.alphaofnotouch
			end
			dxDrawImage(pos.one.lock[1],pos.one.lock[2],pos.one.lock[3],pos.one.lock[4],"images/unlockhouse.png",0,0,0,tocolor(255,255,255,a or 150))
		end
		a=nil

		if config.actual==pos.one.payment then
			pos.one.payment[5]="images/payment_p.png"
			a=255
		else
			pos.one.payment[5]="images/payment.png" a=config.alphaofnotouch
			if checkposition(pos.one.payment[1],pos.one.payment[2],pos.one.payment[3],pos.one.payment[4]) then
				pos.one.payment[5]="images/payment.png" a=255
				if getKeyState("mouse1") then
					if not state then
						state=true
						config.actual=pos.one.payment
						checkButtons()
						config.select=3
					end
				else
					state=nil
				end
			else
				pos.one.payment[5]="images/payment.png" a=config.alphaofnotouch
			end
		end
		dxDrawImage(pos.one.payment[1],pos.one.payment[2],pos.one.payment[3],pos.one.payment[4],pos.one.payment[5],0,0,0,tocolor(255,255,255,a or config.alphaofnotouch))
		a=nil

		if config.actual==pos.one.settings then
			pos.one.settings[5]="images/settings_p.png"
			a=255
		else
			pos.one.settings[5]="images/settings.png" a=config.alphaofnotouch
			if checkposition(pos.one.settings[1],pos.one.settings[2],pos.one.settings[3],pos.one.settings[4]) then
				pos.one.settings[5]="images/settings.png" a=255
				if getKeyState("mouse1") then
					if not state then
						state=true
						config.actual=pos.one.settings
						checkButtons()
						config.select=4
						czyZwolnij=0
					end
				else
					state=nil
				end
			else
				pos.one.settings[5]="images/settings.png" a=config.alphaofnotouch
			end
		end
		dxDrawImage(pos.one.settings[1],pos.one.settings[2],pos.one.settings[3],pos.one.settings[4],pos.one.settings[5],0,0,0,tocolor(255,255,255,a or config.alphaofnotouch))
		a=nil
	end
end

function showGUI(plr,typ,data)
	if plr and isElement(plr) then
		if (typ=="pokaz") then
			if (data and #data>0) then
				if data[1] == "wolny" then
					wybor=1
					dane={data[2],data[3]} --id,cost
				elseif (data[1] == "zajety") then
					wybor=2
					dane={data[2],data[3],data[4]} --id,owner,time
				elseif (data[1] == "wlasciciel") then
					wybor=3
					if data[6] ~= "stacja-nos" then
						dane={data[2],data[3],data[4],data[5],data[6]} --id,czas,cost,lock,typ
					else
						dane={data[2],data[3],data[4],data[5],data[6],data[7],data[8],data[9], data[10], data[11]} --id,czas,cost,lock,typ,nos_price
					end
				end
			end
			actual=1
			
			config.actual=pos.one.info
			config.alphaofnotouch=120
			config.select = 1

			wejscie=false
			showCursor(true,false)
			showChat(false)
			if not isEventHandlerAdded("onClientRender",root,onRender) then
				addEventHandler("onClientRender",root,onRender)
			end
		elseif (typ=="ukryj") then
			if isEventHandlerAdded("onClientRender",root,onRender) then
				removeEventHandler("onClientRender",root,onRender)
			end
			showCursor(false)
			showChat(true)
			checkButtons()
			wybor=nil
			dane=nil
			wejscie=nil
			actual = nil
		end
	end
end
addEvent("CS:house:client",true)
addEventHandler("CS:house:client",root,showGUI)