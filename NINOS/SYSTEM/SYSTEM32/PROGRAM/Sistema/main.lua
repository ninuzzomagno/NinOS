 files.cdir(kernel.PATH_INI.."PSP/GAME/NinOS")

 function pagina8(sfondo,MENU,pagina)
	local upBTN=BT_new(170,70,180,20,"Cerca aggiornamenti",0.7,color.new(127,127,127),nero,"cross",color.new(200,200,200),color.new(127,127,127))
	upBTN:connect("clicked",UPDATE.controlla)
	while true do
		buttons.read()
		image.blit(sfondo,0,0)
		screen.print(160,40,"Update",1,nero)
		MENU:blit()
		upBTN:blit()
		PROG_ESCI()
		startbar:blit()
		mouse:blit()
		screen.flip()
		if pagina~=MENU:selected() then return MENU:selected() 
			elseif mouse:getx()>=0 and mouse:getx()<=30 and mouse:gety()>=0 and mouse:gety()<=25 and buttons.cross then
			return 0
		end
	end
 end

function pagina7(sfondo,MENU,pagina)
	local P=files.listdirs(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM")
	local H=files.listdirs(kernel.PATH_INI.."PSP/GAME")
	local tab={}
	for i=1,#P do
		tab[i]={}
		tab[i].name=P[i].name
		tab[i].path=P[i].path
		tab[i].type="APP"
	end
	local y=#P
	for i=1,#H do
		if H[i].name~="NINOS" then
			y+=1
			tab[y]={}
			tab[y].name=H[i].name
			tab[y].path=H[i].path
			tab[y].type="Homebrew"
		end
	end
	P=nil H=nil
	local tabella=NEW_table(148,26,326,207,bianco,color.new(139,139,139),0.7,0.6,bianco,nero,color.new(139,139,139),tab,12)
	local label=LABEL_new(148,233,326,"START : disinstalla programma",bianco,color.new(139,139,139))
	local ris=nil
	tabella:addCol("Nome","name")
	tabella:addCol("Path","path")
	tabella:addCol("Tipo","type")
	local RIS=nil
	while true do
		buttons.read()
		image.blit(sfondo,0,0)
		MENU:blit()
		PROG_ESCI()
		ris=tabella:blit()
		if ris~=nil then 
			if ris~=-1 then
				MSG_sys:type("Attenzione","Sei sicuro di voler disinstallare "..tab[ris].name.." ?",__MBOKCANC,__MBICONINFO)
				RIS=ris
			end
		end
		MSG_sys.result=MSG_sys:blit()
		if MSG_sys.result~=nil then 
			if MSG_sys.result ==__MBOK then
				files.delete(tab[RIS].path)
				table.remove(tab,RIS)
				MSG_sys:type("Disinstalla","Disinstallazione avvenuta con successo",__MBOK,__MBICONINFO)
			elseif MSG_sys.result==__MBCANC then
				RIS=nil
			end
		end
		label:blit()
		startbar:blit()
		mouse:blit()
		screen.flip()
		if pagina~=MENU:selected() then return MENU:selected() 
			elseif mouse:getx()>=0 and mouse:getx()<=30 and mouse:gety()>=0 and mouse:gety()<=25 and buttons.cross then
			return 0
		end
	end
end

function pagina6(sfondo,MENU,pagina)
	local selcol=nil
	local wave={} 
	local a=files.listfiles(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/DINAMICI")

	for i=1,table.getn(a) do
		wave[i]=image.load(a[i].path)
		image.scale(wave[i],25)
	end

	local scelta=1
	local initScelta=false

	local menu=MH_new(148,26,color.new(0,0,0,0),color.new(119,119,119),nero,bianco,0.7)
	menu:add("Sfondi statici")
	menu:add("Sfondi dinamici")
	menu:add("Temi")
	menu:connect(1,function() scelta=1 end)
	menu:connect(2,function() scelta=2 end)
	menu:connect(3,function() scelta=3 end)

	function ApplyBDinFun()
		ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","wavecolor_R",selcol.rSl.val)
		ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","wavecolor_G",selcol.gSl.val)
		ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","wavecolor_B",selcol.bSl.val)
		ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","dinamicBackground",1)
		sfondo_update()
	end

	function ApplyBStcFun(selPath)
		ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","back_desk",selPath)
		ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","dinamicBackground",0)
		sfondo_update()
	end

	local ApplyBtn=BT_new(160,220,50,23,"Applica",0.6,bianco,nero,"cross",rosso,rosso,0)

	function sfDIM()
		selcol:blit()
		ApplyBtn:blit()
	end

	function sfTemi()
		
	end

	function sfSTA()
		local j=1
		local x=158
		local z=1
		local size=table.getn(wave)
		if size>6 then size=6 end
		for i=1,size do 
			if mouse:getx()>=x and mouse:getx()<=x+96 and mouse:gety()>=70+65*(j-1) and mouse:gety()<=70+65*(j-1)+54 then
				draw.fillrect(x-2,70+65*(j-1)-2,100,58,rosso)
				if buttons.cross then
					ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","back_desk",a[i].path)
					ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","dinamicBackground","0")
					sfondo_update()
				end
			elseif mouse:getx()>=x and mouse:getx()<=x+96 and mouse:gety()>=70+65*(j-1) and mouse:gety()<=70+65*(j-1)+54 then
				draw.fillrect(x-2,70+65*(j-1)-2,100,58,rosso)
				if buttons.circle then
					ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","back_lock",a[i].path)
					ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","dinamicBackground","0")
					sfondo_update()
				end
			end
			image.blit(wave[i],x,70+65*(j-1))
			if i>=3 then 
				j=2
			else
				j=1
			end
			if i%3==0 then
				x=158
				z=1
			else
				z+=1
				x=158+(z-1)*105
			end
		end
		ApplyBtn:blit()
	end

	while true do
		buttons.read()
		image.blit(sfondo,0,0)
		draw.fillrect(148,26,326,20,color.new(139,139,139))
		MENU:blit()
		menu:blit()
		PROG_ESCI()
		if scelta==2 then 
			if ApplyBtn.fun~=ApplyBDinFun then
				ApplyBtn:connect("pressed",ApplyBDinFun)
				selcol=color_selector()
				selcol:rSl_init(160,70,100,rosso,rosso,ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","wavecolor_R",255))
				selcol:gSl_init(160,90,100,verde,verde,ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","wavecolor_G",255))
				selcol:bSl_init(160,110,100,color.new(0,0,255),color.new(0,0,255),ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","wavecolor_B",255))
				selcol:risC_init(400,70,50,50)
			end
			sfDIM()
		elseif scelta==1 then 
			if ApplyBtn.fun~=ApplyBStcFun then
				ApplyBtn:connect("pressed",ApplyBStcFun)
				selcol=nil
				a=files.listfiles(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI")
				for i=1,table.getn(a) do
					wave[i]=image.load(a[i].path)
					image.resize(wave[i],96,54)
				end
			end
			sfSTA()
		else sfTemi() end 
		startbar:blit()
		mouse:blit()
		screen.flip()
		if pagina~=MENU:selected() then return MENU:selected() 
			elseif mouse:getx()>=0 and mouse:getx()<=30 and mouse:gety()>=0 and mouse:gety()<=25 and buttons.cross then
			return 0
		end
	end
end

function pagina5(sfondo,MENU,pagina)

	local USB_MS=CHECKBT_new(180,80,bianco,rosso,"Memory stick",nero)
	local USB_UMD=CHECKBT_new(180,130,bianco,rosso,"Umd disk",nero)
	local USB_F0=CHECKBT_new(180,180,bianco,rosso,"Flash0",nero)
	local USB_AUTO=CHECKBT_new(180,230,bianco,rosso,"Connessione usb automatica",nero)

	if kernel.usb.autoconnect then 
		if kernel.usb.mode=="ms" then USB_MS.sel=true
		elseif kernel.usb.mode=="fl0" then USB_F0.sel=true
		elseif kernel.usb.mode=="umd" then USB_UMD.sel=true
		end
		USBrun()
	else
		if kernel.usb.mode=="ms" then USB_MS.sel=false
		elseif kernel.usb.mode=="fl0" then USB_F0.sel=false
		elseif kernel.usb.mode=="umd" then USB_UMD.sel=false
		end
	end

	USB_AUTO.sel=kernel.usb.autoconnect

	USB_AUTO:connect(function()
		kernel.usb.autoconnect=USB_AUTO.sel
		if USB_AUTO.sel then
			ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","usb_auto","true")
		else
			ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","usb_auto","false")
		end
	end)

	USB_MS:connect(function()
		local connected=false
		if usb.isconnected() then connected=true USBstop() end
		USB_UMD.sel=false
		USB_F0.sel=false
		ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","usb_mode","ms")
		USB_MS.sel=true
		kernel.usb.mode="ms"
		if connected then usb.mstick() end
	end)

	USB_UMD:connect(function()
		local connected=false
		if usb.isconnected() then connected=true USBstop() end
		USB_MS.sel=false
		USB_F0.sel=false
		ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","usb_mode","umd")
		USB_UMD.sel=true
		kernel.usb.mode="umd"
		if connected then
			if umd.init() and umd.present() then
				usb.umd()
			else 
				MSG_sys:type("Errore","Vano UMD vuoto",__MBCANC,__MBICONERROR)
			end
		end
	end)

	USB_F0:connect(function()
		local connected=false
		if usb.isconnected() then connected=true USBstop() end
		USB_MS.sel=false
		USB_UMD.sel=false
		ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","usb_mode","fl0")
		USB_F0.sel=true
		kernel.usb.mode="fl0"
		if connected then usb.flash0() end
	end)

	while true do
		buttons.read()
		image.blit(sfondo,0,0)
		screen.print(220,40,"Selezionare modalita' usb",0.7,nero)
		MENU:blit()
		PROG_ESCI()
		USB_MS:blit()
		USB_UMD:blit()
		USB_F0:blit()
		USB_AUTO:blit()
		startbar:blit()
		mouse:blit()
		screen.flip()
		if pagina~=MENU:selected() then return MENU:selected() 
			elseif mouse:getx()>=0 and mouse:getx()<=30 and mouse:gety()>=0 and mouse:gety()<=25 and buttons.cross then
			return 0
		end
	end
end

function pagina4(sfondo,MENU,pagina)
	local wifi_toggle=BT_TOGGLE_new(200,28,true)
	local ftp_toggle=BT_TOGGLE_new(250,55,false)

	ftp_toggle:connect(function()
		if ftp_toggle.stato==false then
			ftp.init()
		else
			ftp.term()
		end
	end)

	local add_wifi=BT_new(260,28,80,25,"Aggiungi",0.6,color.new(128,128,128),nero,"cross",color.new(0,0,0,0),color.new(0,0,0,0))
	local del_wifi=BT_new(320,28,80,25,"Elimina",0.6,color.new(128,128,128),nero,"cross",color.new(0,0,0,0),color.new(0,0,0,0))
	while true do
		buttons.read()
		image.blit(sfondo,0,0)
		screen.print(160,35,"Wi-fi",0.7,nero)
		screen.print(160,62,"Server FTP",0.7,nero)
		MENU:blit()
		wifi_toggle:blit(wlan.isconnected())
		ftp_toggle:blit(ftp.state())
		add_wifi:blit()
		del_wifi:blit()
		PROG_ESCI()
		startbar:blit()
		mouse:blit()
		screen.flip()
		if pagina~=MENU:selected() then return MENU:selected() 
			elseif mouse:getx()>=0 and mouse:getx()<=30 and mouse:gety()>=0 and mouse:gety()<=25 and buttons.cross then
			return 0
		end
	end
end

function pagina3(sfondo,MENU,pagina)
	local res_imp=BT_IMG_new(380,130,image.load("SYSTEM/SYSTEM32/ICONE/ripristino2.png"),image.load("SYSTEM/SYSTEM32/ICONE/ripristino2h.png"))
	res_imp:connect("clicked",resetImp)
	local res_os=BT_IMG_new(200,130,image.load("SYSTEM/SYSTEM32/ICONE/ripristino.png"),image.load("SYSTEM/SYSTEM32/ICONE/ripristinoh.png"))

	while true do
		buttons.read()
		image.blit(sfondo,0,0)
		res_imp:blit()
		res_os:blit()
		MENU:blit()
		startbar:blit()
		PROG_ESCI()
		mouse:blit()
		screen.flip()
		if pagina~=MENU:selected() then return MENU:selected() 
			elseif mouse:getx()>=0 and mouse:getx()<=30 and mouse:gety()>=0 and mouse:gety()<=25 and buttons.cross then
			return 0
		end
	end
end

function pagina2(sfondo,MENU,pagina)

	local SL=SLIDER_new(220,203,120,color.new(119,119,119),rosso,1,10,ini.read("SYSTEM/SYSTEM32/CONF/Sistema.ini","velocita",5))
	SL:connect(function ()
		ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","velocita",SL:getVal())
		mouse:ch_vel(SL:getVal())
	end)

	local cpu_M=CHECKBT_new(213,151,bianco,color.new(0,66,255),"333 Mhz",nero)
	local cpu_md=CHECKBT_new(303,151,bianco,color.new(0,66,255),"222 Mhz",nero)
	local cpu_m=CHECKBT_new(395,151,bianco,color.new(0,66,255),"100 Mhz",nero)

	local X=0
	local Y=0
	local NICK=os.nick() 
	local CPU=os.cpu()

	if CPU==333 then
		cpu_M.sel=true
	elseif CPU==222 then 
		cpu_md.sel=true
	elseif CPU==100 then
		cpu_m.sel=true
	end

	cpu_M:connect(function ()
		cpu_M.sel=true
		os.cpu(333)
		ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","cpu",os.cpu())
		cpu_md.sel=false
		cpu_m.sel=false
	end)

	cpu_md:connect(function ()
		cpu_M.sel=false
		cpu_m.sel=false
		cpu_md.sel=true
		os.cpu(222)
		ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","cpu",os.cpu())
	end)

	cpu_m:connect(function ()
		cpu_m.sel=false
		MSG_sys:type("Attenzione","Impostando la frequenza della CPU al minimo il sistema potrebbe rallentare",__MBOKCANC,__MBICONINFO)
	end)

	while true do
		buttons.read()
		image.blit(sfondo,0,0)
		screen.print(230,106,kernel.verOS,0.5,nero)
		screen.print(240,126,kernel.verBI,0.5,nero)
		screen.print(200,55,NICK,0.7,nero)
		prbar(200,80,250,15,os.infoms0().used,os.infoms0().max,color.new(0,255,0),color.new(196,195,195),false)
		screen.print(220,80,(os.infoms0().used).." bytes ".." / "..(os.infoms0().max).." bytes",0.5,nero)
		prbar(240,172,200,15,(os.totalram()-os.ram()),os.totalram(),color.new(0,255,0),color.new(196,195,195),false)
		screen.print(245,172,(os.totalram()-os.ram()).." bytes ".." / "..(os.totalram()).." bytes",0.5,nero)
		if MSG_sys:blit() == __MBOK then
			cpu_m.sel=true
    		os.cpu(100)
			ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","cpu",os.cpu())
			cpu_md.sel=false
			cpu_M.sel=false
		end
		SL:blit()
		MENU:blit()
		cpu_M:blit()
		cpu_md:blit()
		cpu_m:blit()
		PROG_ESCI()
		startbar:blit()
		mouse:blit()
		screen.flip()
		if pagina~=MENU:selected() then return MENU:selected() 
			elseif mouse:getx()>=0 and mouse:getx()<=30 and mouse:gety()>=0 and mouse:gety()<=25 and buttons.cross then
			return 0
		end
	end

end

function pagina1(sfondo,MENU,pagina,R,C,IMG_ACC,IMG_ACC_LIST,IMG_ACC_IN)
	local r=0 
	local c=0
	local pass_butt=BT_new(370,60,80,25,"Password",0.7,color.new(128,128,128),nero,"cross",color.new(0,0,0,0),color.new(0,0,0,0))
	local user_butt=BT_new(370,39,80,25,"Username",0.7,color.new(128,128,128),nero,"cross",color.new(0,0,0,0),color.new(0,0,0,0))
	
	pass_butt:connect("clicked",function()
	tpass=osk.init("Inserisci nuova password","")
		ini.write("SYSTEM/SYSTEM32/CONF/Account.ini","USER1","password",tpass)
	end)
	user_butt:connect("clicked",function()
		tuser=osk.init("Inserisci nuovo username","")
		ini.write("SYSTEM/SYSTEM32/CONF/Account.ini","USER1","username",tuser)
	end)

	while true do
		buttons.read()
		image.blit(sfondo,0,0)
		screen.print(255,43,tuser,0.7,rosso)
		screen.print(240,65,tpass,0.7,rosso)
		draw.fillrect(168+C*60,118+R*60,44,44,rosso)
		for i=1,10 do
			if mouse:getx()>170+c*60 and mouse:getx()<210+c*60 and mouse:gety()>120+r*60 and mouse:gety()<160+r*60 then
				draw.fillrect(168+c*60,118+r*60,44,44,nero)
				if buttons.cross then 
					ini.write("SYSTEM/SYSTEM32/CONF/Account.ini","USER1","immagine",IMG_ACC_LIST[i].path)
					IMG_ACC_IN=i
					if IMG_ACC_IN>5 then R=1 else R=0 end
					C=IMG_ACC_IN-((R*5)+1)
				end
			end
			image.blit(IMG_ACC[i],170+c*60,120+r*60)
			if c==4 then c=0 r=r+1 else c=c+1 end	
		end
		user_butt:blit()
		pass_butt:blit()
		MENU:blit()
		PROG_ESCI()
		startbar:blit()
		mouse:blit()
		screen.flip()
		r=0 c=0
		if pagina~=MENU:selected() then return MENU:selected() 
			elseif mouse:getx()>=0 and mouse:getx()<=30 and mouse:gety()>=0 and mouse:gety()<=25 and buttons.cross then
			return 0
		end
	end
end

function SISTEMA_AVVIO_PROG()
	local menu={"Account","Sistema","Ripristino","Rete","Usb","Sfondi","Disinstalla","Update"}
	local MENU=MV_new(6,26,142,221,color.new(139,139,139),color.new(119,119,119),0.7,nero,bianco,false,false,8)
	
	for i=1,table.getn(menu) do
		MENU:add(menu[i])
	end

	local SIS={}
	SIS[1]=image.load("SYSTEM/SYSTEM32/PROGRAM/Sistema/Sistemadef.jpg")
	SIS[2]=image.load("SYSTEM/SYSTEM32/PROGRAM/Sistema/Sistema1.jpg")
	SIS[3]=image.load("SYSTEM/SYSTEM32/PROGRAM/Sistema/Sistema2.jpg")
	SIS[4]=image.load("SYSTEM/SYSTEM32/PROGRAM/Sistema/Sistema3.jpg")
	SIS[5]=image.load("SYSTEM/SYSTEM32/PROGRAM/Sistema/Sistema4.jpg")

	local c=0
	local r=0
	local R=0
	local C=0
	local IMG_ACC={}			
	local IMG_ACC_LIST=nil
	local IMG_ACC_IN=0
	local IMG_ACC_ATT=nil
	local pagina=imp_sys_pag or 0
	MENU:selected(pagina)
	imp_sys_pag=nil
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

	while true do
		if pagina==0 then
			buttons.read()
			image.blit(SIS[1],0,0)
			for i=1,table.getn(menu) do
				if mouse:getx()>30+c*150 and mouse:getx()<150+c*150 and mouse:gety()>50+r*70 and mouse:gety()<80+r*70 then
					draw.rect(30+c*150,50+r*70,120,30,nero)
					if buttons.cross then
						pagina=i
						MENU:selected(i)
					end
				end
				draw.fillrect(30+c*150,50+r*70,120,30,color.new(212,212,212))
				screen.print((90+c*150)-(screen.textwidth(menu[i],0.8)/2),60+r*70,menu[i],0.8,nero)
				if c==2 then c=0 r=r+1 else c=c+1 end	
			end
			r=0 c=0
			PROG_ESCI()
			startbar:blit()
			mouse:blit()
			screen.flip()
		elseif pagina==1 then
			pagina=pagina1(SIS[2],MENU,pagina,R,C,IMG_ACC,IMG_ACC_LIST,IMG_ACC_IN)
		elseif pagina==2 then
			pagina=pagina2(SIS[3],MENU,pagina)
		elseif pagina==3 then
			pagina=pagina3(SIS[4],MENU,pagina)
		elseif pagina==4 then
			pagina=pagina4(SIS[5],MENU,pagina)
		elseif pagina==5 then
			pagina=pagina5(SIS[5],MENU,pagina)
		elseif pagina==6 then
			pagina=pagina6(SIS[5],MENU,pagina)
		elseif pagina==7 then
			pagina=pagina7(SIS[5],MENU,pagina)
		elseif pagina==8 then
			pagina=pagina8(SIS[5],MENU,pagina)
		end
	end
end
--SISTEMA_AVVIO_PROG()
thread:new(4,image.load("SYSTEM/SYSTEM32/PROGRAM/Sistema/icona.png"),SISTEMA_AVVIO_PROG)