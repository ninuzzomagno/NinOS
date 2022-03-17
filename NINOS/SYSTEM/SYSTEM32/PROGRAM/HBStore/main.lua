files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS")

local icona=image.load("SYSTEM/SYSTEM32/PROGRAM/HBStore/icona.png")
local sfondo=image.load("SYSTEM/SYSTEM32/PROGRAM/HBStore/store.jpg")
local SEL=true

local MENU=MH_new(0,0,color.new(0,0,0,0),color.new(40,92,149),bianco,bianco,0.8)
	MENU:add("Applicazioni")
	MENU:selected(1)
	MENU:add("Giochi")

function SELECTED_APP(t)
	local img_prec=image.load("SYSTEM/SYSTEM32/ICONE/prec.png")
	local back=BT_IMG_new(2,215,img_prec,img_prec)
	local download=BT_new(320,50,100,25,"Download",0.7,bianco,nero,"cross",color.new(243,218,011),color.new(229,190,001),10)
	download:connect("clicked",function()
		http.getfile(t.link,FILE_DIALOG(__FDSELDIR) or kernel.PATH_INI..t.nome..".zip")
	end)

	while true do
		buttons.read()
		image.blit(sfondo,0,0)
		image.blit(t.icona,15,40)
		screen.print(60,50,t.nome,1,bianco)
		screen.print(20,90,t.desc,0.7,bianco,color.new(0,0,0,0),__ALEFT,440)
		startbar:blit()
		MENU:blit()
		download:blit()
		PROG_ESCI()
		back:blit()
		if back:isClicked()==true then return end
		mouse:blit()
		screen.flip()
	end
end

function DISPLAY(t,y)
	if mouse:getx()>=10 and mouse:getx()<=470 and mouse:gety()>=30+50*(y-1) and mouse:gety()<=75+50*(y-1) then
		draw.fillrect(10,30+50*(y-1),460,45,color.new(20,72,129))
		if buttons.cross then
			SELECTED_APP(t)
		end
	else
		draw.fillrect(10,30+50*(y-1),460,45,color.new(40,92,149))
	end
	image.blit(t.icona,12,32+50*(y-1))
	screen.print(50,35+50*(y-1),t.nome,0.8,bianco)
	screen.print(50,50+50*(y-1),t.desc,0.6,bianco)
end

function HOMEBREW_STORE()
	
	while wlan.isconnected()==false do 
		buttons.read()
		image.blit(sfondo,0,0)
		screen.print(240-screen.textwidth("Connessione internet assente",0.8)/2,136,"Connessione internet assente.",0.8,rosso)
		PROG_ESCI()
		startbar:blit()
		mouse:blit()
		screen.flip()
	end
	
	if files.exists("SYSTEM/SYSTEM32/PROGRAM/HBSTORE/hbstore.ini")==false then
		if http.getfile("http://ninosweb-psp-shell.000webhostapp.com/hbstore.ini","SYSTEM/SYSTEM32/PROGRAM/HBStore/hbstore.ini")==false then 
			MSG:type("Errore","Impossibile scaricare il database dello store",__MBCANC,__MBICONERROR) 
			return 
		end
	end

	--if files.exists("SYSTEM/SYSTEM32/PROGRAM/HBSTORE/icone.zip")==false then
	--	if http.getfile("http://ninosweb-psp-shell.000webhostapp.com/icone.zip","SYSTEM/SYSTEM32/PROGRAM/HBStore/icone.zip")==false then 
	--		MSG:type("Errore","Impossibile scaricare il database dello store",__MBCANC,__MBICONERROR) 
	--		return 
	--	end
	--end
	
	local max_app=ini.read("SYSTEM/SYSTEM32/PROGRAM/HBStore/hbstore.ini","INFO","totale_app",0)
	local max_giochi=ini.read("SYSTEM/SYSTEM32/PROGRAM/HBStore/hbstore.ini","INFO","totale_giochi",0)
	local MAX=3
	local MIN=1

	local APP={}
	local GAME={}
	if SEL then
		for i=MIN,MAX do
			for y=1,3 do
				APP[y]={}
				APP[y].nome=ini.read("SYSTEM/SYSTEM32/PROGRAM/HBStore/hbstore.ini","APP"..i,"nome","")
				APP[y].desc=ini.read("SYSTEM/SYSTEM32/PROGRAM/HBStore/hbstore.ini","APP"..i,"descrizione","")
				APP[y].ver=ini.read("SYSTEM/SYSTEM32/PROGRAM/HBStore/hbstore.ini","APP"..i,"versione","")
				APP[y].link=ini.read("SYSTEM/SYSTEM32/PROGRAM/HBStore/hbstore.ini","APP"..i,"link","")
				APP[y].icona=icona
				buttons.read()
				if buttons.r and i+1<=max_app then
					MAX+=1
					MIN+=1
				elseif buttons.l and i-1>=1 then
					MAX-=1
					MIN-=1
				end
			end
		end
	else
	end

	while true do
		buttons.read()
		image.blit(sfondo,0,0)
		for i=1,3 do
			DISPLAY(APP[i],i,icona,sfondo)
		end
		startbar:blit()
		MENU:blit()
		PROG_ESCI()
		mouse:blit()
		screen.flip()
	end

end
--HOMEBREW_STORE()
thread:new(8,image.load("SYSTEM/SYSTEM32/PROGRAM/HBStore/icona.png"),HOMEBREW_STORE)
