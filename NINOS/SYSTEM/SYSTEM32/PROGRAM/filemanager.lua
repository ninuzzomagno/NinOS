files.cdir("ms0:/PSP/GAME/NINOS")
require=("SYSTEM.SYSTEM32.ASR")

local fileman_sfondo = image.load("SYSTEM/SYSTEM32/PROGRAM/fileman.png")
local ico_fileg=image.load("SYSTEM/SYSTEM32/ICONE/exfile.png")
local ico_cartella=image.load("SYSTEM/SYSTEM32/ICONE/excartella.png")
local ico_jpg=image.load("SYSTEM/SYSTEM32/ICONE/jpg.png")
local ico_png=image.load("SYSTEM/SYSTEM32/ICONE/png.png")
local ico_fmusica=image.load("SYSTEM/SYSTEM32/ICONE/exmusica.png")
local ico_iso=image.load("SYSTEM/SYSTEM32/ICONE/iso.png")
local ico_cso=image.load("SYSTEM/SYSTEM32/ICONE/cso.png")
local ico_homebrew=image.load("SYSTEM/SYSTEM32/ICONE/homebrew.png")
local control=image.load("SYSTEM/SYSTEM32/PROGRAM/control.png")
local default=image.load("SYSTEM/SYSTEM32/ICONE/default.png")
local PATH=nil 
local FILE=nil 
local tFILE=nil
local l_file= nil
local l_max = nil
local A=1 
local z=-1 
local Z=-1 
local max=9 
local X=210 
local Y=60 
local c=0 
local r=0 
local id=nil 
local pagina=1 
local xP=nil 
local yP=nil
local NOPATH=nil 
local POPUP_B=false
local DISPLAY_IMG=nil 
local T=false

image.resize(default,72,40)
image.center(ico_fmusica)
image.center(ico_iso)
image.center(ico_cso)
image.center(ico_homebrew)
image.center(ico_cartella)
image.center(ico_fileg)
image.center(ico_jpg)
image.center(ico_png)
image.center(default)

function FILE_MAN_PRESS_X_ON_FILE()
if T==false then
	if buttons.cross and mouse:getx()>=195 and mouse:getx()<=225 then
		if mouse:gety()>=40 and mouse:gety()<=80 then z=0 Z=0 id=A
		elseif mouse:gety()>=110 and mouse:gety()<=150 then z=0 Z=1 id=A+3
		elseif mouse:gety()>=180 and mouse:gety()<=220 then z=0 Z=2 id=A+6 end
	elseif buttons.cross and mouse:getx()>=305 and mouse:getx()<= 335 then
		if mouse:gety()>=40 and mouse:gety()<=80 then z=1 Z=0 id=A+1
		elseif mouse:gety()>=110 and mouse:gety()<=150 then z=1 Z=1 id=A+4
		elseif mouse:gety()>=180 and mouse:gety()<=220 then z=1 Z=2 id=A+7 end
	elseif buttons.cross and mouse:getx()>=415 and mouse:getx()<=445 then
		if mouse:gety()>=40 and mouse:gety()<=80 then z=2 Z=0 id=A+2
		elseif mouse:gety()>=110 and mouse:gety()<=150 then z=2 Z=1 id=A+5
		elseif mouse:gety()>=180 and mouse:gety()<=220 then z=2 Z=2 id=A+8 end
	elseif buttons.circle and (pagina==1 and PATH~="ms0:") or (pagina==2 and PATH~="flash0:") or (pagina==3 and PATH~="flash1:") or (pagina==4 and PATH~="flash2:") or (pagina==5 and PATH~="flash3:") or (pagina==6 and PATH~="umd:")    then
		NOPATH=files.nopath(PATH)
		PATH=string.sub(PATH,1,-1-(string.len(NOPATH)+1))
		l_file=files.list(PATH)
		l_max = table.getn(l_file)
		A=1 max=9 z=-1 Z=-1 id=nil
		if max>l_max then max = l_max end
	end
	if id~=nil and id>l_max then id=nil z=-1 Z=-1 end
	if buttons.released.cross and z~=-1 and Z~=-1 and id~=nil then FILE_MAN_reload() z=-1 Z=-1 id=nil end
end
end

function FILE_MAN_PRESS_T_ON_FILE()
if T==true then
	if mouse:getx()>=195 and mouse:getx()<=225 then
		if mouse:gety()>=40 and mouse:gety()<=80 then z=0 Z=0 id=A xP=mouse:getx() yP=mouse:gety() POPUP_B=true
		elseif mouse:gety()>=110 and mouse:gety()<=150 then z=0 Z=1 id=A+3 xP=mouse:getx() yP=mouse:gety() POPUP_B=true
		elseif mouse:gety()>=180 and mouse:gety()<=220 then z=0 Z=2 id=A+6 xP=mouse:getx() yP=mouse:gety() POPUP_B=true end
	elseif mouse:getx()>=305 and mouse:getx()<= 335 then
		if mouse:gety()>=40 and mouse:gety()<=80 then z=1 Z=0 id=A+1 xP=mouse:getx() yP=mouse:gety() POPUP_B=true
		elseif mouse:gety()>=110 and mouse:gety()<=150 then z=1 Z=1 id=A+4 xP=mouse:getx() yP=mouse:gety() POPUP_B=true
		elseif mouse:gety()>=180 and mouse:gety()<=220 then z=1 Z=2 id=A+7 xP=mouse:getx() yP=mouse:gety() POPUP_B=true end
	elseif mouse:getx()>=415 and mouse:getx()<=445 then
		if mouse:gety()>=40 and mouse:gety()<=80 then z=2 Z=0 id=A+2 xP=mouse:getx() yP=mouse:gety() POPUP_B=true
		elseif mouse:gety()>=110 and mouse:gety()<=150 then z=2 Z=1 id=A+5 xP=mouse:getx() yP=mouse:gety() POPUP_B=true
		elseif mouse:gety()>=180 and mouse:gety()<=220 then z=2 Z=2 id=A+8 xP=mouse:getx() yP=mouse:gety() POPUP_B=true end
	end
	if id==nil or id~=nil and id>l_max then z=-1 Z=-1 id=nil xP=mouse:getx() yP=mouse:gety() POPUP_B=true end
	if buttons.released.triangle then T=false xP=mouse:getx() yP=mouse:gety() end
end
end

function FILE_MAN_POPUP()
	if id~=nil then
 if l_file[id].directory then     					--menu per cartelle
    if xP+123>474 then xP=mouse:getx()-123 end
    if yP+104>250 then yP=mouse:gety()-104 end
    draw.fillrect(xP,yP,125,104,color.new(224,224,224))
    if mouse:getx()>=xP+7 and mouse:getx()<=xP+116 and mouse:gety()>=yP+2 and mouse:gety()<=yP+15 then
        screen.print(xP+7,yP+2,"Apri",0.6,rosso)
        if buttons.cross then
            PATH=l_file[id].path
	     xP=nil yP=nil POPUP_B=false FILE_MAN_reload() return
        end
    else
        screen.print(xP+7,yP+2,"Apri",0.6,nero)
    end
    draw.line(xP+5,yP+17,xP+118,yP+17,nero)
    if mouse:getx()>=xP+7 and mouse:getx()<=xP+116 and mouse:gety()>=yP+19 and mouse:gety()<=yP+34 then
        screen.print(xP+7,yP+19,"Rinomina",0.6,rosso)
	 if buttons.cross then
		path_cartella=osk.init("","")
        	files.rename(l_file[id].path,path_cartella)
		xP=nil yP=nil id=nil POPUP_B=false FILE_MAN_reload() return
	 end
    else
        screen.print(xP+7,yP+19,"Rinomina",0.6,nero)
    end
    draw.line(xP+5,yP+34,xP+118,yP+34,nero)
    if bINCOLLA==true then
        if mouse:getx()>=xP+7 and mouse:getx()<=xP+116 and mouse:gety()>=yP+36 and mouse:gety()<=yP+51 then
            screen.print(xP+7,yP+36,"Incolla",0.6,rosso)
            
        else
            screen.print(xP+7,yP+36,"Incolla",0.6,nero)
        end
        if mouse:getx()>=xP+7 and mouse:getx()<=xP+116 and mouse:gety()>=yP+53 and mouse:gety()<=yP+68 then
            screen.print(xP+7,yP+53,"Annulla copia",0.6,rosso)
            if buttons.cross then
                copy_path_source=nil
            end
        else
            screen.print(xP+7,yP+53,"Annulla copia",0.6,nero)
        end
    else 
        screen.print(xP+7,yP+36,"Incolla",0.6,color.new(155,155,155))
        screen.print(xP+7,yP+53,"Annulla copia",0.6,color.new(155,155,155))
    end
    draw.line(xP+5,yP+51,xP+118,yP+51,nero)
    if mouse:getx()>=xP+7 and mouse:getx()<=xP+116 and mouse:gety()>=yP+70 and mouse:gety()<=yP+85 then
        screen.print(xP+7,yP+70,"Elimina",0.6,rosso)
	 if buttons.cross then 
		files.delete(l_file[id].path)
		xP=nil yP=nil POPUP_B=false id=nil FILE_MAN_reload() return
	 end
    else screen.print(xP+7,yP+70,"Elimina",0.6,nero) end
    draw.line(xP+5,yP+68,xP+118,yP+68,nero)
    if mouse:getx()>=xP+7 and mouse:getx()<=xP+116 and mouse:gety()>=yP+87 and mouse:gety()<=yP+102 then
        screen.print(xP+7,yP+87,"Crea collegamento",0.6,rosso)
	 if buttons.cross then 
		
	 end
    else screen.print(xP+7,yP+87,"Crea collegamento",0.6,nero) end
    draw.line(xP+5,yP+85,xP+118,yP+85,nero)

    if buttons.circle or (buttons.cross and (not(mouse:getx()>xP and mouse:getx()<xP+125 and mouse:gety()>yP and mouse:gety()<yP+104)))then
        xP=nil yP=nil POPUP_B=false id=nil FILE_MAN_reload() 
    elseif buttons.triangle then
        xP=mouse:getx() yP=mouse:gety() id=nil z=-1 Z=-1
        return
    end					--fine menu per cartelle
 else							--menu per file
    if xP+70>474 then xP=mouse:getx()-70 end
    if yP+102>250 then yP=mouse:gety()-102 end						
    draw.fillrect(xP,yP,70,102,color.new(224,224,224))
    if mouse:getx()>=xP+7 and mouse:getx()<=xP+63 and mouse:gety()>=yP+2 and mouse:gety()<=yP+15 then
        screen.print(xP+7,yP+2,"Apri",0.6,rosso)
        if buttons.cross then
            PATH=l_file[id].path
	     xP=nil yP=nil POPUP_B=false FILE_MAN_reload() return
        end
    else
        screen.print(xP+7,yP+2,"Apri",0.6,nero)
    end
    draw.line(xP+5,yP+17,xP+65,yP+17,nero)
    if mouse:getx()>=xP+7 and mouse:getx()<=xP+63 and mouse:gety()>=yP+19 and mouse:gety()<=yP+34 then
        screen.print(xP+7,yP+19,"Rinomina",0.6,rosso)
	 if buttons.cross then
		path_cartella=osk.init("","")
        	files.rename(l_file[id].path,path_cartella.."."..l_file[id].ext)
		xP=nil yP=nil id=nil POPUP_B=false FILE_MAN_reload() return
	 end
    else
        screen.print(xP+7,yP+19,"Rinomina",0.6,nero)
    end
    draw.line(xP+5,yP+34,xP+65,yP+34,nero)
    if mouse:getx()>=xP+7 and mouse:getx()<=xP+63 and mouse:gety()>=yP+36 and mouse:gety()<=yP+51 then
            screen.print(xP+7,yP+36,"Taglia",0.6,rosso)
            if buttons.cross then
		 copy_path_source = l_file[id].path
		 COPY_MODE=1
		 xP=nil yP=nil POPUP_B=false id=nil return
	     end
    else screen.print(xP+7,yP+36,"Taglia",0.6,nero) end
        if mouse:getx()>=xP+7 and mouse:getx()<=xP+63 and mouse:gety()>=yP+53 and mouse:gety()<=yP+68 then
            screen.print(xP+7,yP+53,"Copia",0.6,rosso)
            if buttons.cross then
                copy_path_source = l_file[id].path
		  COPY_MODE=0
		  xP=nil yP=nil POPUP_B=false id=nil return
            end
        else screen.print(xP+7,yP+53,"Copia",0.6,nero) end
    draw.line(xP+5,yP+51,xP+65,yP+51,nero)
    if mouse:getx()>=xP+7 and mouse:getx()<=xP+63 and mouse:gety()>=yP+70 and mouse:gety()<=yP+85 then
            screen.print(xP+7,yP+70,"Elimina",0.6,rosso)
           if buttons.cross then 
		files.delete(l_file[id].path)
		xP=nil yP=nil POPUP_B=false id=nil FILE_MAN_reload() return
	 end
    else screen.print(xP+7,yP+70,"Elimina",0.6,nero) end
    draw.line(xP+5,yP+68,xP+65,yP+68,nero)
    if mouse:getx()>=xP+7 and mouse:getx()<=xP+63 and mouse:gety()>=yP+87 and mouse:gety()<=yP+102 then
            screen.print(xP+7,yP+87,"Proprietà",0.6,rosso)
           if buttons.cross then 
		xP=nil yP=nil POPUP_B=false id=nil FILE_MAN_reload() return
	 end
    else screen.print(xP+7,yP+87,"Proprietà",0.6,nero) end
    draw.line(xP+5,yP+85,xP+65,yP+85,nero)
    if buttons.circle or (buttons.cross and (not(mouse:getx()>xP and mouse:getx()<xP+70 and mouse:gety()>yP and mouse:gety()<yP+102)))then
        xP=nil yP=nil POPUP_B=false id=nil FILE_MAN_reload() 
    elseif buttons.triangle then
        xP=mouse:getx() yP=mouse:gety() id=nil z=-1 Z=-1
        return
    end
 end				--fine menu file
else
    if xP+123>474 then xP=474-123 end
    if yP+87>250 then yP=250-87 end
    draw.fillrect(xP,yP,123,70,color.new(224,224,224))
    if mouse:getx()>=xP+7 and mouse:getx()<=xP+116 and mouse:gety()>=yP+2 and mouse:gety()<=yP+15 then
        screen.print(xP+7,yP+2,"Nuova cartella",0.6,rosso)
        if buttons.cross then
            path_cartella=osk.init("La cartella verrà creata nella cartella corrente","")
            if path_cartella ~=nil then
                files.mkdir(PATH.."/"..path_cartella)
		  xP=nil yP=nil POPUP_B=false id=nil FILE_MAN_reload() return
            end
        end
    else
        screen.print(xP+7,yP+2,"Nuova cartella",0.6,nero)
    end
    draw.line(xP+5,yP+17,xP+118,yP+17,nero)
    if mouse:getx()>=xP+7 and mouse:getx()<=xP+116 and mouse:gety()>=yP+19 and mouse:gety()<=yP+34 then
        screen.print(xP+7,yP+19,"Nuovo file di testo",0.6,rosso)
	 if buttons.cross then
		path_cartella=osk.init("Il file verrà creato nella cartella corrente","")
        	FILE=io.open(PATH.."/"..path_cartella..".txt","w")
		tFILE=FILE:write("File vuoto")
		FILE:close()
		xP=nil yP=nil POPUP_B=false id=nil FILE_MAN_reload() return
	 end
    else
        screen.print(xP+7,yP+19,"Nuovo file di testo",0.6,nero)
    end
    draw.line(xP+5,yP+34,xP+118,yP+34,nero)
    if copy_path_source~=nil then
        if mouse:getx()>=xP+7 and mouse:getx()<=xP+116 and mouse:gety()>=yP+36 and mouse:gety()<=yP+51 then
            screen.print(xP+7,yP+36,"Incolla",0.6,rosso)
            if buttons.cross then
		 if COPY_MODE==1 then
			files.move(copy_path_source,PATH) 
		 else
		     	files.copy(copy_path_source,PATH)
		 end
		 xP=nil yP=nil POPUP_B=false id=nil copy_path_source=nil FILE_MAN_reload() return
	     end
        else
            screen.print(xP+7,yP+36,"Incolla",0.6,nero)
        end
        if mouse:getx()>=xP+7 and mouse:getx()<=xP+116 and mouse:gety()>=yP+53 and mouse:gety()<=yP+68 then
            screen.print(xP+7,yP+53,"Annulla copia",0.6,rosso)
            if buttons.cross then copy_path_source=nil end
        else
            screen.print(xP+7,yP+53,"Annulla copia",0.6,nero)
        end
    else 
        screen.print(xP+7,yP+36,"Incolla",0.6,color.new(155,155,155))
        screen.print(xP+7,yP+53,"Annulla copia",0.6,color.new(155,155,155))
    end
    draw.line(xP+5,yP+51,xP+118,yP+51,nero)
    if buttons.circle or (buttons.cross and (not(mouse:getx()>xP and mouse:getx()<xP+123 and mouse:gety()>yP and mouse:gety()<yP+70)))then
        xP=nil yP=nil POPUP_B=false FILE_MAN_reload()
    elseif buttons.triangle then
        xP=mouse:getx() yP=mouse:gety()
        return
    end

end
end

function FILE_MAN_reload()
	if id~=nil then
		if l_file[id].directory then
			PATH=l_file[id].path
			l_file=files.list(PATH)
			l_max = table.getn(l_file)
			max=9 A=1 id=nil z=-1 Z=-1
			if max>l_max then max = l_max end
		elseif l_file[id].ext=="pbp" or l_file[id].ext=="iso" or l_file[id].ext=="cso" then
			game.launch(l_file[id].path)
		elseif l_file[id].ext=="mp3" or l_file[id].ext=="wav" then
		elseif l_file[id].ext=="txt" or l_file[id].ext=="ini" or l_file[id]=="lua" or l_file[id].ext=="html" then
		elseif l_file[id].ext=="jpg" or l_file[id].ext=="png" or l_file[id]=="bmp" or l_file[id].ext=="gif" then
			DISPLAY_IMG=image.load(l_file[id].path)
			if DISPLAY_IMG==nil then
				MSGshow=true MSGtitolo="Errore" MSGerrore="Immagine troppo grande per essere caricata"
			else image.center(DISPLAY_IMG) PATH=l_file[id].path end
		end
	else
		l_file=files.list(PATH)
		l_max = table.getn(l_file)
		max=9 A=1 id=nil z=-1 Z=-1
		if max>l_max then max = l_max end
	end
end

function FILE_MAN_menu()
	if pagina==1 then draw.fillrect(6,27,145,27,color.new(34,117,209)) 
	elseif pagina==2 then draw.fillrect(6,54,145,27,color.new(34,117,209))
	elseif pagina==3 then draw.fillrect(6,81,145,27,color.new(34,117,209)) 
	elseif pagina==4 then draw.fillrect(6,108,145,27,color.new(34,117,209))
	elseif pagina==5 then draw.fillrect(6,135,145,27,color.new(34,117,209))
	elseif pagina==6 then draw.fillrect(6,162,145,27,color.new(34,117,209)) end
	screen.print((157-screen.textwidth("Memory stick",0.7))/2,35,"Memory stick",0.7,nero)
	screen.print((157-screen.textwidth("Flash0",0.7))/2,62,"Flash0",0.7,nero)
	screen.print((157-screen.textwidth("Flash1",0.7))/2,89,"Flash2",0.7,nero)
	screen.print((157-screen.textwidth("Flash2",0.7))/2,116,"Flash3",0.7,nero)
	screen.print((157-screen.textwidth("Flash3",0.7))/2,143,"Flash3",0.7,nero)
	screen.print((157-screen.textwidth("Disco UMD",0.7))/2,170,"Disco UMD",0.7,nero)
	if mouse:getx()>=6 and mouse:getx()<=151 and buttons.cross then
		if mouse:gety()>27 and mouse:gety()<54 then 
			PATH="ms0:" 
			l_file=files.list(PATH)
			l_max = table.getn(l_file)
			A=1 max=9 z=-1 Z=-1 pagina=1
			if max>l_max then max = l_max end
		elseif mouse:gety()>54 and mouse:gety()<81 then
			PATH="flash0:"
			l_file=files.list(PATH)
			l_max = table.getn(l_file)
			A=1 max=9 z=-1 Z=-1 pagina=2
			if max>l_max then max = l_max end
		elseif mouse:gety()>81 and mouse:gety()<108 then
			PATH="flash1:"
			l_file=files.list(PATH)
			l_max = table.getn(l_file)
			A=1 max=9 z=-1 Z=-1 pagina=3
			if max>l_max then max = l_max end
		elseif mouse:gety()>108 and mouse:gety()<135 then
			PATH="flash2:"
			l_file=files.list(PATH)
			l_max = table.getn(l_file)
			A=1 max=9 z=-1 Z=-1 pagina=4
			if max>l_max then max = l_max end
		elseif mouse:gety()>135 and mouse:gety()<162 then
			PATH="flash3:"
			l_file=files.list(PATH)
			l_max = table.getn(l_file)
			A=1 max=9 z=-1 Z=-1 pagina=5
			if max>l_max then max = l_max end
		elseif mouse:gety()>162 and mouse:gety()<189 then
			PATH="umd:"
			l_file=files.list(PATH)
			l_max = table.getn(l_file)
			A=1 max=9 z=-1 Z=-1 pagina=6
			if max>l_max then max = l_max end
		end
	end
end

function FILE_AVVIO_PROG()

PATH="ms0:"
l_file=files.list(PATH)
l_max = table.getn(l_file)
if max>l_max then max = l_max end

while true do
	screen.clear(nero)
	buttons.read()
	image.blit(fileman_sfondo,0,0)
	if string.len(PATH)>30 then screen.print(140,7,string.sub(PATH,1,30).."...",0.7,nero)
	else screen.print(140,7,PATH,0.7,nero) end
	FILE_MAN_menu()
	if DISPLAY_IMG~=nil then
		image.blit(control,156,27)
		image.blit(DISPLAY_IMG,314,136)
		if buttons.circle then 
			DISPLAY_IMG=nil  
			NOPATH=files.nopath(PATH)
			PATH=string.sub(PATH,1,-1-(string.len(NOPATH)+1))
		elseif buttons.triangle then 
			--image.center(DISPLAY_IMG,0,0)
			ini.write("ms0:/PSP/GAME/NinOS/SYSTEM/SYSTEM32/ACC/Sistema.ini","background_desk",PATH)
			back_desk=DISPLAY_IMG 
			--image.center(DISPLAY_IMG)
		end
	else
	if z~=-1 and Z~=-1 then draw.fillrect(X+110*z-25,Y+Z*70-30,50,60,color.new(176,224,230)) end
	for i=A,max do
		if l_file[i].ext=="mp3" or l_file[i].ext=="wav" then image.blit(ico_fmusica,X+110*c,Y+70*r)
		elseif l_file[i].directory then image.blit(ico_cartella,X+110*c,Y+70*r)
		elseif l_file[i].ext=="jpg" then image.blit(ico_jpg,X+110*c,Y+70*r)
		elseif l_file[i].ext=="png" then image.blit(ico_png,X+110*c,Y+70*r)
		elseif l_file[i].ext=="iso" then	image.blit(ico_iso,X+110*c,Y+70*r)
		elseif l_file[i].ext=="cso" then image.blit(ico_cso,X+110*c,Y+70*r)
		elseif l_file[i].ext=="pbp" then image.blit(ico_homebrew,X+110*c,Y+70*r)
		else image.blit(ico_fileg,X+110*c,Y+70*r) end
		screen.print(X+110*c-screen.textwidth(string.sub(l_file[i].name,1,10),0.6)/2,Y+20+70*r,string.sub(l_file[i].name,1,10),0.6,nero)
		if c==2 then c=0 r=r+1 else c=c+1 end
	end
	c=0 r=0
	if buttons.l and A>3  then
		if max==A+8 or max==A+2 or max==A+5 then max = max-3
		elseif max==A+7 or max==A+4 or max==A+1 then max=max-2
		elseif max==A+6 or max==A+3 or max==A then max=max-1 end
		A=A-3
		z=-1 Z=-1
	elseif buttons.r and max<l_max then
		A=A+3
		z=-1 Z=-1
		if max+3>l_max then max=l_max
		else max=max+3 end
	end
	if buttons.triangle then T=true end 
	FILE_MAN_PRESS_X_ON_FILE()
	FILE_MAN_PRESS_T_ON_FILE()	
	if POPUP_B==true then FILE_MAN_POPUP() end
	if MSGshowB==true then 
		MSGreturn=MSGBOX(MSGtitolo,MSGerrore,__MBCANC,__MBICONERROR)
	end
	scrollbar(470,60,240,2,A,9,l_max,nero)
	end
	PROG_ESCI()
	startbar:blit()
	mouse:blit()
	screen.flip()

end
end

if thread:new(3,image.load("SYSTEM/SYSTEM32/ICONE/file_man.png"),FILE_AVVIO_PROG())==false then bsod("Impossibile creare thread per avviare il programma") end