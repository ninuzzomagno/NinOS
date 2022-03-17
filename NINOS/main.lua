files.cdir(kernel.PATH_INI.."PSP/GAME/NinOS")

function SISTEMA_pagina1(X,R,C,IMG_ACC_IN,IMG_ACC,IMG_ACC_LIST,IMG_ACC_ATT,menu,sistema1)
	X=60
	local r=0
	local c=0

	image.blit(sistema1,0,0)
	draw.fillrect(7,26,140,30,color.new(105,105,105))
	--screen.print(255,43,tuser,0.7,rosso)
	--screen.print(240,65,tpass,0.7,rosso)
	draw.fillrect(168+C*X,118+R*X,44,44,rosso)
	for i=1,10 do
		if mouse:getx()>170+c*X and mouse:getx()<210+c*X and mouse:gety()>120+r*X and mouse:gety()<160+r*X then
			draw.fillrect(168+c*X,118+r*X,44,44,nero)
			if buttons.cross then 
				ini.write("SYSTEM/SYSTEM32/CONF/Account.ini","USER1","immagine",IMG_ACC_LIST[i].path)
				IMG_ACC_IN=i
				if IMG_ACC_IN>5 then R=1 else R=0 end
				C=IMG_ACC_IN-((R*5)+1)
			end
		end
		image.blit(IMG_ACC[i],170+c*X,120+r*X)
		if c==4 then c=0 r=r+1 else c=c+1 end	
	end
	r=0 c=0
end


function SISTEMA_pagina2(X,Y,CPU,NICK,menu,sistema2)
	image.blit(sistema2,0,0)
	draw.fillrect(7,56,140,30,color.new(105,105,105))
	if CPU==333 then
		X=215 Y=153
	elseif CPU==222 then 
		X=305 Y=153
	elseif CPU==100 then
		X=397 Y=153
	end 
	if X>0 and Y>0 then
 		draw.fillrect(X,Y,7,7,color.new(0,66,255))
	end
	if (mouse:getx()>=213 and mouse:getx()<=224 and mouse:gety()>=151 and mouse:gety()<=162 and buttons.released.cross) then
    	X=215 Y=153
    	os.cpu(333)
		ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","cpu",os.cpu())
		CPU = 333
	elseif (mouse:getx()>=303 and mouse:getx()<=314 and mouse:gety()>=151 and mouse:gety()<=162 and buttons.released.cross) then
    	X=305 Y=153
    	os.cpu(222)
		ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","cpu",os.cpu())
		CPU=222
	elseif(mouse:getx()>=395 and mouse:getx()<=406 and mouse:gety()>=151 and mouse:gety()<=162 and buttons.released.cross and CPU~=100) then
		MSG:type("Attenzione","Impostando la frequenza della CPU al minimo il sistema potrebbe rallentare",__MBOKCANC,__MBICONINFO)
	end
	screen.print(200,55,NICK,0.7,nero)
	prbar(200,80,250,15,os.infoms0().used,os.infoms0().max,color.new(0,255,0),color.new(196,195,195),false)
	screen.print(220,80,(os.infoms0().used).." bytes ".." / "..(os.infoms0().max).." bytes",0.5,nero)
	prbar(240,172,200,15,(os.totalram()-os.ram()),os.totalram(),color.new(0,255,0),color.new(196,195,195),false)
	screen.print(245,172,(os.totalram()-os.ram()).." bytes ".." / "..(os.totalram()).." bytes",0.5,nero)
	if MSG:blit() == __MBOK then
		X=397 Y=153
    	os.cpu(100)
		ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","cpu",os.cpu())
		CPU=100
	end
end

function SISTEMA_pagina3(menu,sistema3,ripristino,ripristinoh,ripristino2,ripristino2h)
		image.blit(sistema3,0,0)
		draw.fillrect(7,87,140,30,color.new(105,105,105))
		if mouse:getx()<200 or mouse:getx()>250 or mouse:getx()>=200 and mouse:getx()<=250 and mouse:gety()<130 or mouse:gety()>180 then
    		image.blit(ripristino,200,130)
		else
    		image.blit(ripristinoh,200,130)
    		if buttons.cross then
				MSGshowB=true
         		if files.exists("ms0:/PSP/GAME/NINOS/vecchia_versione.rar")==false then
					MSGtitolo="Errore"
					MSGerrore="Il file immagine della vecchia versione dell'OS non è stato trovato"
				else
					MSGtitolo="Attenzione"
					MSGerrore="Procedere con il ripristino della vecchia versione dell'OS?"
				end
    		end
		end
		if mouse:getx()<380 or mouse:getx()>430 or mouse:getx()>=380 and mouse:getx()<=430 and mouse:gety()<130 or mouse:gety()>180 then
			image.blit(ripristino2,380,130)
		else
			image.blit(ripristino2h,380,130)
			if buttons.cross then
				files.delete("SYSTEM/SYSTEM32/CONF/Account.ini")
				ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","velocita","5")
				ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","cpu","222")
				ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","background_lock","ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/default.jpg")
				ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","background_desk","ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/default.jpg")
				os.delay(1000)
				riavvia()
			end
		end
		if MSGshowB==true then
			if(MSGtitolo~=nil and MSGtitolo=="Errore") then
				--(MSGtitolo,MSGerrore,__MBCANC,__MBICONERROR)
			elseif(MSGtitolo~=nil and MSGtitolo=="Attenzione")then
				--MSGBOX(MSGtitolo,MSGerrore,__MBOKCANC,__MBICONINFO)
			end
		end
end

function SISTEMA_pagina4(menu,sistema4)
	image.blit(sistema4,0,0)
	draw.fillrect(7,118,140,30,color.new(105,105,105))
	if mouse:getx()>=254 and mouse:getx()<=384 and mouse:gety()>=130 and mouse:gety()<=160 then
		draw.fillrect(254,130,150,30,color.new(128,128,128))
		screen.print(255,136,"Cerca aggiornamenti",0.7,rosso)
		if buttons.cross then
			aggiornamento()
		end
	else
		draw.fillrect(254,130,150,30,bianco)
		screen.print(255,136,"Cerca aggiornamenti",0.7,nero)
	end
end

function SISTEMA_default(menu,sistemadef)
local r=0 
local c=0
while true do
	buttons.read()
	image.blit(sistemadef,0,0)
	for i=1,5 do
		if mouse:getx()>30+c*150 and mouse:getx()<150+c*150 and mouse:gety()>60+r*100 and mouse:gety()<90+r*100 then
			draw.rect(30+c*150,60+r*100,120,30,nero)
			if buttons.cross then 
				return i
			end
		end
		draw.fillrect(30+c*150,60+r*100,120,30,color.new(212,212,212))
		screen.print((90+c*150)-(screen.textwidth(menu[i],0.8)/2),70+r*100,menu[i],0.8,nero)
		if c==2 then c=0 r=r+1 else c=c+1 end	
	end
	r=0 c=0
	startbar:blit()
	PROG_ESCI()
	mouse:blit()
	screen.flip()
end
end

function SISTEMA_AVVIO_PROG()

local X=0 
local Y=0 
local pagina=0
local NICK=os.nick() 
local CPU=os.cpu()
local r=0 
local c=0
local R=0 
local C=0
local L=0
local IMG_ACC={}
local IMG_ACC_LIST=nil
local IMG_ACC_IN=0
local IMG_ACC_ATT=nil

IMG_ACC_LIST=files.listfiles("SYSTEM/SYSTEM32/ACC/IMGPR")
IMG_ACC_IN=0
IMG_ACC_ATT=ini.read("SYSTEM/SYSTEM32/CONF/Account.ini","USER1","immagine","")

for i=1,10 do
	IMG_ACC[i]=image.load(IMG_ACC_LIST[i].path)
	image.resize(IMG_ACC[i],40,40)
	if IMG_ACC_ATT==IMG_ACC_LIST[i].path then
		IMG_ACC_IN=i
	end
end

if IMG_ACC_IN>5 then R=1 else R=0 end
C=IMG_ACC_IN-((R*5)+1)

local menu={"Account","Sistema","Ripristino","Aggiorna","Sfondi","Widget"}
local MENU=MV_new(6,26,142,221,color.new(139,139,139),color.new(119,119,119),0.7,nero,bianco,false,false,10)

MENU:add(menu[1])
MENU:add(menu[2])
MENU:add(menu[3])
MENU:add(menu[4])
MENU:add(menu[5])

local sistemadef=image.load("SYSTEM/SYSTEM32/PROGRAM/Sistema/Sistemadef.jpg")
local sistema1=image.load("SYSTEM/SYSTEM32/PROGRAM/Sistema/Sistema1.jpg")
local sistema5=image.load("SYSTEM/SYSTEM32/PROGRAM/Sistema/Sistema5.jpg")
local sistema2=image.load("SYSTEM/SYSTEM32/PROGRAM/Sistema/Sistema2.jpg")
local sistema3=image.load("SYSTEM/SYSTEM32/PROGRAM/Sistema/Sistema3.jpg")
local sistema4=image.load("SYSTEM/SYSTEM32/PROGRAM/Sistema/Sistema4.jpg")
local ripristino=image.load("SYSTEM/SYSTEM32/ICONE/ripristino.png")
local ripristinoh=image.load("SYSTEM/SYSTEM32/ICONE/ripristinoh.png")
local ripristino2=image.load("SYSTEM/SYSTEM32/ICONE/ripristino2.png")
local ripristino2h=image.load("SYSTEM/SYSTEM32/ICONE/ripristino2h.png")

if sistema1==nil or sistema2==nil or sistema3==nil or sistema4==nil or ripristino==nil or ripristinoh==nil or ripristino2==nil or ripristino2h==nil then
	bsod("Mancano alcuni file di sistema")
end

while true do
	buttons.read()
	if MENU:selected()==0 then
		MENU:selected(SISTEMA_default(menu,sistemadef))
	elseif MENU:selected()==2 then
		SISTEMA_pagina2(X,Y,CPU,NICK,menu,sistema2)
	elseif MENU:selected()==1 then
		SISTEMA_pagina1(X,R,C,IMG_ACC_IN,IMG_ACC,IMG_ACC_LIST,IMG_ACC_ATT,menu,sistema1)
	elseif MENU:selected()==3 then
		SISTEMA_pagina3(menu,sistema3,ripristino,ripristinoh,ripristino2,ripristino2h)
	elseif MENU:selected()==4 then
		SISTEMA_pagina4(menu,sistema4)
	end
	MENU:blit()
	startbar:blit()
	PROG_ESCI()
	mouse:blit()
	screen.flip()
end
end

SISTEMA_AVVIO_PROG()
--if thread:new(4,image.load("SYSTEM/SYSTEM32/PROGRAM/Sistema/icona.png"),SISTEMA_AVVIO_PROG)==false then bsod("Impossibile creare thread per avviare il programma") end

