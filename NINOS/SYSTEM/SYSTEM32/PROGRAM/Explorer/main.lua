files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS")

local POP={}
POP[1]=color.new(34,117,209)
POP[2]=color.new(22,90,166)
POP[3]=bianco
POP[4]=nero
POP[5]=true

function SEARCH(text,L,M)
	local t=timer.new(0)
	local MAX=table.getn(L.lista)
	while MAX>0 do
		if string.find(string.lower(L.lista[MAX].name),string.lower(text))==nil then
			table.remove(L.lista,MAX)
		end
		MAX=MAX-1
	end
	if M then
		L.max=table.getn(L.lista)
		L.INI=1
		L.MAX=9
		if L.max < L.MAX then
			L.MAX=L.max
		end
	else
		L.max=table.getn(L.lista)
		if L.max==0 then
			L.max=0
		elseif L.max > 13 then
			L.vmax=13
		else
			L.vmax=L.max
		end
		L.INI=1
	end
	return L
end

function CHANGE_PATH(LISTA,PATH,MATR)
	if LISTA:getSel()~=0 then
		if LISTA.lista[LISTA:getSel()].directory==true then
			PATH=LISTA.lista[LISTA:getSel()].path
			if MATR==false then
				LISTA=Vlist_new(PATH,160,37,380,13,false,true,nero,rosso)
			else
				LISTA=lista_new(PATH,130,0,380,220,90,false,nero,POP)
			end
		else
			local index=LISTA:getSel()
			if LISTA.lista[index].ext=="ini" or LISTA.lista[index].ext=="txt" or LISTA.lista[index].ext=="lua" or LISTA.lista[index].ext=="htm" or LISTA.lista[index].ext=="html" or  LISTA.lista[index].ext=="conf" then
				psword_path_file=LISTA.lista[LISTA:getSel()].path
				dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/PSWORD/main.lua")
			elseif LISTA.lista[index].ext=="jpg" or LISTA.lista[index].ext=="bmp" or LISTA.lista[index].ext=="gif" or LISTA.lista[index].ext=="png" then
				paintshop_path=LISTA.lista[LISTA:getSel()].path
				dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/PAINTSHOP/main.lua")
			elseif LISTA.lista[index].ext=="zip" or LISTA.lista[index].ext=="rar" then
				INSTALLWIZARD:init(FILE(LISTA.lista[LISTA:getSel()].path))
			else
				MSG:type("Attenzione","Non e' stato trovato nessun programma con cui aprire il file",__MBCANC,__MBICONERROR)
			end
			LISTA.SEL=0
		end
	end
	if buttons.circle and (string.sub(PATH,1,1)=="m" and PATH~=kernel.PATH_INI or string.sub(PATH,1,1)=="f" and string.sub(PATH,1,-4)~="flash") then
		local NOPATH=files.nopath(PATH)
		PATH=string.sub(PATH,1,-(1+string.len(NOPATH)))
		if string.sub(PATH,1,1)=="m" and PATH~=kernel.PATH_INI or string.sub(PATH,1,1)=="f" and string.sub(PATH,1,-4)~="flash" then
			PATH=string.sub(PATH,1,-2)
		end
		if MATR==false then
			LISTA=Vlist_new(PATH,160,37,380,13,false,true,nero,rosso)
		else
			LISTA=lista_new(PATH,130,0,380,220,90,false,nero,POP)
		end
	end
	return LISTA,PATH
end

function FILE_AVVIO_PROG()
	local sfondo=image.load("SYSTEM/SYSTEM32/PROGRAM/EXPLORER/fileman.png")
	local menu=MV_new(6,27,144,215,color.new(34,117,209),color.new(22,90,166),0.7,bianco,nero,false,false,2)

	local MSG=MSGBOX:new() 
	MSG:connect(__MBOK,function()
		if REI==6 then
			ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/EXPLORER/config.ini","msc_path",FILE_DIALOG(__FDSELDIR) or kernel.PATH_INI.."Musica")
		elseif REI==7 then
			ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/EXPLORER/config.ini","img_path",FILE_DIALOG(__FDSELDIR) or kernel.PATH_INI.."Immagini")
		end
	end)

	menu:add("Archivio interno")
	menu:add("Flash0")
	menu:add("Flash1")
	menu:add("Giochi")
	menu:add("Homebrew")
	menu:add("Musica")
	menu:add("Immagini")

	menu:selected(1)

	local MENU=1
	local PATH=explorer_path or kernel.PATH_INI
	explorer_path=nil
	local MATR=nil
	local LISTA=nil

	if ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/EXPLORER/config.ini","VIEW","true")=="true" then
		LISTA=lista_new(PATH,130,0,380,220,90,false,nero,POP)
		MATR=true
	else
		LISTA=Vlist_new(PATH,160,37,380,13,false,true,nero,rosso)
		MATR=false
	end

	local REI=nil
	local TEXTBOX=TXT_new(6,228,144,bianco,color.new(22,90,166),"Cerca in "..PATH)
	while true do
		buttons.read()
		image.blit(sfondo,0,0)
		LISTA,PATH=CHANGE_PATH(LISTA,PATH,MATR)
		if buttons.select then
			if MATR==false then
				LISTA=lista_new(PATH,130,0,380,220,90,false,nero,POP)
				MATR=true
				ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/EXPLORER/config.ini","VIEW","true")
			else
				LISTA=Vlist_new(PATH,160,37,380,13,false,true,nero,rosso)
				MATR=false
				ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/EXPLORER/config.ini","VIEW","false")
			end
		end
		if string.len(PATH)>30 then
			screen.print(150,6,string.sub(PATH,0,27).."...",0.7,bianco)
		else
			screen.print(150,6,PATH,0.7,bianco)
		end
		if MENU~=menu:selected() then
			if menu:selected()==1 then PATH=kernel.PATH_INI
			elseif menu:selected()>1 and menu:selected()<4 then PATH=string.lower(string.sub(menu:getLabel(menu:selected()),0,-1)..":/")
			elseif menu:selected()==4 then PATH=kernel.PATH_INI.."ISO"
			elseif menu:selected()==5 then PATH=kernel.PATH_INI.."PSP/GAME"
			elseif menu:selected()==6 then PATH=ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/EXPLORER/config.ini","msc_path",kernel.PATH_INI.."Musica")
			elseif menu:selected()==7 then PATH=ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/EXPLORER/config.ini","img_path",kernel.PATH_INI.."Immagini")
			end
			if files.exists(PATH)==false and menu:selected()>5 then 
				MSG:type("Attenzione","Path non trovata.Si vuole selezionare una cartella da collegare a \""..menu:getLabel(menu:selected()).."\" ?",__MBOKCANC,__MBICONERROR)
				PATH=kernel.PATH_INI
				REI=menu:selected()
				menu:selected(MENU)				
			else
				if MATR==false then
					LISTA=Vlist_new(PATH,160,37,380,13,false,true,nero,rosso)
				else
					LISTA=lista_new(PATH,130,0,380,220,90,false,nero,POP)
				end
				MENU=menu:selected()
				TEXTBOX.text="Cerca.."
			end
		end
		PROG_ESCI()
		LISTA:blit()
		if MATR then 
			scrollbar(467,30,239,3,LISTA.INI,9,LISTA.max,color.new(0,0,0,0,0),color.new(34,117,209))
		else
			scrollbar(467,30,239,3,LISTA.sel,LISTA.vmax-LISTA.INI+1,LISTA.max,color.new(0,0,0,0,0),color.new(34,117,209))
		end
		menu:blit()
		TEXTBOX:blit()
		if TEXTBOX:hover() and buttons.start and TEXTBOX.text~="" then
			LISTA=SEARCH(TEXTBOX.text,LISTA,MATR)
		end
		MSG:blit()
		startbar:blit()
		mouse:blit()
		screen.flip()
	end
end
--FILE_AVVIO_PROG()
thread:new(3,image.load("SYSTEM/SYSTEM32/PROGRAM/EXPLORER/icona.png"),FILE_AVVIO_PROG)