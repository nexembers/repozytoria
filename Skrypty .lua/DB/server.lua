--[[
Właścicielem zasobów jest Krystian Janas, pseudonim NeX - zasoby opublikowane są jedynie na serwer Calm Story.
Zgodę na używanie zasobów ma jedynie serwer Calm Story oraz jego właściciel.
Zakazuje się rozpowszechniania zasobu bądź jego edycji i używania w przypadku jakiegokolwiek uzyskania treści kodu.
Kontakt jedynie e-mailowo: postofficeNeX@gmail.com
]]--


local time = getRealTime()
local tn=string.format("%04d-%02d-%02d'%02d %02d %02d-%02d.txt",time.year+1900,time.month+1,time.monthday,time.hour,time.minute,time.second,math.random(1,99))
local fh=fileCreate("logi/"..tn)

function outputLog(text)
	if (text and fh) then
		local time = getRealTime()
		local ts=string.format("%04d-%02d-%02d=%02d:%02d:%02d> ",time.year+1900,time.month+1,time.monthday,time.hour,time.minute,time.second)
		fileWrite(fh,ts..text.."\n")
		fileFlush(fh)
	end
end






local SQL

local function connect()
	SQL = dbConnect("mysql","dbname=;host=","","","share=1")
	if (not SQL) then
		outputServerLog("BRAK POLACZENIA Z BAZA DANYCH!")
		outputDebugString("Nie nawiązano połączenia z bazą danych!",3,255,0,0)
		outputDebugString("Nie nawiązano połączenia z bazą danych!!",3,255,0,0)
		outputDebugString("Nie nawiązano połączenia z bazą danych!!!",3,255,0,0)
		outputDebugString("Nie nawiązano połączenia z bazą danych!!!!",3,255,0,0)
		outputDebugString("Nie nawiązano połączenia z bazą danych!!!!!",3,255,0,0)
	else
		zapytanie("SET NAMES utf8;")
		outputDebugString("Nawiązano połączenie z bazą danych!",3,50,100,200)
		outputDebugString("Połaczenie z bazą danych poprawne!",3,255,0,0)
	end
end
addEventHandler("onResourceStart",resourceRoot,connect)

local iloscpobran = 0
local ilosczapytan = 0

function pobierzTabeleWynikow(...)
	local h=dbQuery(SQL,...)
	if (not h) then 
		return nil
	end
	local rows = dbPoll(h,-1)
	iloscpobran = iloscpobran+1
	--outputDebugString((...) or "BRAK INFO POBRANIA",3)
	return rows
end

function pobierzWyniki(...)
	local h=dbQuery(SQL,...)
	if (not h) then 
		return nil
	end
	local rows = dbPoll(h,-1)
	if not rows then return nil end
	return rows[1]
end

function zapytanie(...)
	local h=dbQuery(SQL,...)
	local result,numrows=dbPoll(h,-1)
	outputLog((...) or "DB-NIEZIDENTYFIKOWANO")
	ilosczapytan = ilosczapytan + 1
	return numrows
end

function fetchRows(query)
	local result=mysql_query(SQL,query)
	if (not result) then return nil end
	local tabela={}

	while true do
    	local row = mysql_fetch_row(result)
	    if (not row) then break end
	    table.insert(tabela,row)
	end
	mysql_free_result(result)
	return tabela
end

--[[function prepareSet(...)
    if {...} then 
        local s = dbPrepareString(SQL, ...)
        local s2 = dbExec(SQL, s)
        return s2
    else
        return false
    end
end]]

function prepareSet(...)
	if(...)then
        	local s = dbPrepareString(SQL, ...);
		local qh = dbQuery(SQL, s);
		if not qh then return false end
		local result, num_affected_rows, last_insert_id = dbPoll(qh, -1)
		ilosczapytan = ilosczapytan + 1
		return result, num_affected_rows, last_insert_id
	end
end

setTimer(function()
	if ilosczapytan and iloscpobran then
		outputDebugString("Wygenerowano "..iloscpobran.." pobrań z bazy danych i "..ilosczapytan.." zapytań do DB.",3)
		ilosczapytan = 0
		iloscpobran = 0
	end
end,60000,0)