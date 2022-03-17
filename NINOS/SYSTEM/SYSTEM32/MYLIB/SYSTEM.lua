screensaver={}

function screensaver:init()
	self.T=timer.new(0)
	procBack:new("screensaverVER",true,function()
		while true do
			if screensaver.T:time() == 0 then screensaver.T:start() end
			if buttons.analogy>5 or buttons.analogy<-5 or buttons.analogx>5 or buttons.analogx<-5 or buttons.up or buttons.left or buttons.right or buttons.down or buttons.square or buttons.cross or buttons.triangle or buttons.circle then
				screensaver.T:reset(0)
			elseif screensaver.T:time()>300000 then
				procBack:PauseResume("screensaverRUN")
				screensaver.T:reset(0)
			end
			coroutine.yield()
		end
	end)
	procBack:new("screensaverRUN",false,function()
		while true do
			while true do
				buttons.read()
				screen.print(240-screen.textwidth(string.sub(os.getdate(),17,-4),2)/2,80,string.sub(os.getdate(),17,-4),2,bianco)
				screen.print(240-screen.textwidth(string.sub(os.getdate(),4,14),1.5)/2,140,string.sub(os.getdate(),4,14),1.5,bianco)
				if buttons.analogy>5 or buttons.analogy<-5 or buttons.analogx>5 or buttons.analogx<-5 or buttons.up or buttons.left or buttons.right or buttons.down or buttons.square or buttons.cross or buttons.triangle or buttons.circle then
					procBack:PauseResume("screensaverRUN")
					screensaver.T:reset(0)
					break
				end
				batteria:blit(400,200)
				screen.flip()
			end
			coroutine.yield()
		end
	end)
end

function onNetConnection(state)
	screen.clip(100,70,280,100)
	local msg=nil
	draw.fillrect(100,70,380,120,CurrentTheme.systemColor3)
	if state==2 then msg="Connessione in corso....."
	elseif state==3 then msg="Ottenendo IP....."
	elseif state==4 then 
		msg="Connesso"
		screen.clip()
	else
		screen.clip()
	end
	screen.print(110,90,msg,0.7,nero)
	screen.flip()
end

HEADPHONE={
	col = hw.headphone(),
	show = false
}

function HEADPHONE:init()
	self.col = hw.headphone()
	self.show = self.col
end

function HEADPHONE:update()
	if hw.headphone() and not(self.col) then
		self.show = true
		self.col=true
	elseif not(hw.headphone()) and self.col then
		self.show=true
		self.col=false
	end
end

function HEADPHONE:blit()
	if self.show then
		if self.col then
			
		else
			
		end
	end
end

function UMD_read()
	if umd.present() then
		if UMD.present==false then 
			if timer.time(UMD.T)>0 then
				if UMD.posx>400 then 
					UMD.posx=UMD.posx-4
					draw.fillrect(UMD.posx,40,40,40,CurrentTheme.systemColor3)
					image.blit(UMD.icon,UMD.posx,40)
					if UMD.posx<=400 then
						UMD.TIME=UMD.T:time()
					end
				else
					if timer.time(UMD.T)>2000+UMD.TIME then
						UMD.present=true
						UMD.T:reset(0)
						UMD.TIME=0
						UMD.T:stop()
					end
					draw.fillrect(UMD.posx,40,40,40,CurrentTheme.systemColor3)
					image.blit(UMD.icon,UMD.posx,40)
				end
			elseif timer.time(UMD.T)==0 then
				timer.start(UMD.T)
				UMD.posx=480
				UMD.sound1:play()
			end
		end
	elseif UMD.present==true then
		if timer.time(UMD.T)>0 then
			if UMD.posx<480 then 
				if timer.time(UMD.T)>2000 then
					UMD.posx=UMD.posx+4
				end
				draw.fillrect(UMD.posx,40,40,40,CurrentTheme.systemColor3)
				image.blit(UMD.icon,UMD.posx,40)
			else
				UMD.present=false
				UMD.T:reset(0)
				UMD.T:stop()
			end
		elseif timer.time(UMD.T)==0 then
			timer.start(UMD.T)
			UMD.posx=400
			UMD.sound2:play()
		end
	end
end

function fsize (path)
	local file=io.open(path,"r")
    local current = file:seek()      
    local size = file:seek("end")    
    file:seek("set", current)    
	file:close()
	return size
end

function TimeSecTOMin(value)
	local min=math.floor(value)/60
	local sec=(min-math.floor(min))*60
	min=math.floor(min)
	return (min.." : "..sec)
end

function getMp3TimeMin(path)
	local value=getMp3TimeSec(path)
	return TimeSecTOMin(value)
end

function getMp3TimeSec(path)
	return fsize(path)/(GetBitrateMp3(path)/8)/1000
end

function GetBitrateMp3(path)
	local fd=io.open(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/MODULE/bitrateLOG.txt","w")
	fd:write(path)
	
	ris = os.initprx(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/MODULE/bitrate.prx")
	fd:write(ris)
	fd:close()
	if ris>0 then
		os.delay(100)
		--files.delete(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/MODULE/bitrateLOG.txt")
		local File=io.open(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/MODULE/bitratePRX.txt","r")
		local b=tonumber(File:read())
		File:close()
		files.delete(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/MODULE/bitratePRX.txt")
		return b
	end
	return 0
end

function FILE(PATH)
	if files.exists(PATH) then
		local file={
			path=string.sub(PATH,0,-(string.len(files.nopath(PATH))+2)),
			ext=files.ext(PATH),
			size=fsize(PATH),
			name=files.nopath(PATH)
		}
		return file
	end
	return nil
end

MS={}

path_copy_source=nil 
path_copy_des=nil
path_move=nil

function MS:max() 
	if kernel.PATH_INI=="ms0:/" then
		return os.infoms0().max
	elseif kernel.PATH_INI=="ef0:/" then
		return os.infoef0().max
	end
end

function MS:used()
	if kernel.PATH_INI=="ms0:/" then
		return os.infoms0().used
	elseif kernel.PATH_INI=="ef0:/" then
		return os.infoef0().used
	end
end

function MS:free()
	if kernel.PATH_INI=="ms0:/" then
		return os.infoms0().free
	elseif kernel.PATH_INI=="ef0:/" then
		return os.infoef0().free
	end
end

INSTALLWIZARD={
	sfondo=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/WIZARD_INST.png"),
	icon=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/wizard_icon.png")
}

function INSTALLWIZARD:init(FILE)
	self.file=FILE
	if thread:exists(99) then 
		MSG:type("Attenzione","E' gia' in corso l'installazione di un altro programma'",__MBCANC,__MBICONERROR)
	else
		thread:new(99,self.icon,function()
			local avvia=false
			local BT_avvia=BT_new(370,210,70,30,"Installa",0.6,bianco,nero,"cross",nero,bianco,15)
			
			BT_avvia:connect("clicked",function()
				if avvia==true then
					avvia=false
					BT_avvia.text="Continua"
				else
					avvia=true
					BT_avvia.text="Pausa"
				end
			end)

			local CKBT_app=CHECKBT_new(190,130,bianco,color.new(128,128,128),true)
			local CKBT_wid=CHECKBT_new(380,130,bianco,color.new(128,128,128),true)

			if files.extractfile(self.file.path.."/"..self.file.name,"config.ini",kernel.PATH_INI.."EXTRACT")==1 then
				local TIPO=ini.read(kernel.PATH_INI.."EXTRACT/config.ini","type","")
				if TIPO=="APP" then CKBT_app.sel=true 
				elseif TIPO=="WID" then CKBT_wid.sel=true
				else 
					--MSG:type("Attenzione","Il file "..self.file.name.." non e' un installer",__MBOK,__MBICONERROR)
					files.delete(kernel.PATH_INI.."EXTRACT")
					--thread:destroy(99,thread:getProc())
					dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/PSPRar/main.lua")
					return
				end
			else
				--MSG:type("Attenzione","Il file "..self.file.name.." non e' un installer",__MBOK,__MBICONERROR)
				files.delete(kernel.PATH_INI.."EXTRACT")
				--thread:destroy(99,thread:getProc())
				dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/PSPRar/main.lua")
				return
			end

			files.delete(kernel.PATH_INI.."EXTRACT")

			local LISTA=files.scan(self.file.path.."/"..self.file.name)
			local i=1
			while true do
				buttons.read()
				image.blit(self.sfondo,0,0)
				screen.print(150,80,self.file.path.."/"..self.file.name,0.6,color.new(128,128,128))
				PROG_ESCI()
				CKBT_app:blit()
				CKBT_wid:blit()
				BT_avvia:blit()
				startbar:blit()
				mouse:blit()
				screen.print(150,190,"Installazione -> "..string.sub(FILE.name,0,-5),0.7,nero)
				if avvia==true then
					if CKBT_app.sel==true then
						files.extractfile(self.file.path.."/"..self.file.name,LISTA[i].name,kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/"..string.sub(self.file.name,0,-5))
					else
						files.extractfile(self.file.path.."/"..self.file.name,LISTA[i].name,kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/WIDGET/"..string.sub(self.file.name,0,-5))
					end
					prbar(150,220,200,10,i,table.getn(LISTA),verde,bianco,false)
					i=i+1
					if i==table.getn(LISTA)+1 then break end
				else
					prbar(150,220,200,10,i,table.getn(LISTA),color.new(255,116,0),bianco,false)
				end
				screen.flip()
			end
			MSG:type("Wizard installer","Installazione "..string.sub(self.file.name,0,-5).." avvenuta con successo",__MBOK,__MBICONSUCCESS)
			self.file=nil
		end)
	end
end

function System()
	if buttons.held.hold then
		screen.display(0)
	elseif buttons.released.hold then 
		screen.display(1)
	elseif buttons.note then
		dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/Player/main.lua")
	end
	procBack:run()
end

function USBstop()
	kernel.usb.active=false
	usb.stop()
end

function USBrun()
	if kernel.usb.mode=="ms" then usb.mstick()
	elseif kernel.usb.mode=="fl0" then usb.flash0()
	elseif kernel.usb.mode=="umd" then usb.umd()
	end
end

PSPbar={}

function PSPbar:init()
	self.anm=nil
	self.show=false
	self.btnIndex=1
	self.posy=272
	self.img=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/pspbaricon.png")
	self.btn={}
	for i=1,4 do
		self.btn[i]={}
	end
	self.btn[1].fun=function() screen.shot() end
	self.btn[2].fun=function() 
		if MUSIC_PLAYER.song~=nil and sound.playing(MUSIC_PLAYER.song)==true then
			sound.stop(MUSIC_PLAYER.song)
		end
		MUSIC_PLAYER.index=MUSIC_PLAYER.index-1
		if MUSIC_PLAYER.index==0 then MUSIC_PLAYER.index=table.getn(MUSIC_PLAYER.list) end
		MUSIC_PLAYER.song = sound.load(MUSIC_PLAYER.list[MUSIC_PLAYER.index].path)
		sound.play(MUSIC_PLAYER.song)
	end  --prec
	self.btn[3].fun=function()	
		if MUSIC_PLAYER.song~=nil then
			sound.pause(MUSIC_PLAYER.song)
		else
			MUSIC_PLAYER.song=sound.load(MUSIC_PLAYER.list[MUSIC_PLAYER.index].path)
			sound.play(MUSIC_PLAYER.song)
		end
	end--pausa/play
	self.btn[4].fun=function()
		if MUSIC_PLAYER.song~=nil and sound.playing(MUSIC_PLAYER.song)==true then
			sound.stop(MUSIC_PLAYER.song)
		end
		MUSIC_PLAYER.index=MUSIC_PLAYER.index+1
		if MUSIC_PLAYER.index>table.getn(MUSIC_PLAYER.list) then MUSIC_PLAYER.index=1 end
		MUSIC_PLAYER.song = sound.load(MUSIC_PLAYER.list[MUSIC_PLAYER.index].path)
		sound.play(MUSIC_PLAYER.song)
	end--next

	procBack:new("pspbar",false,function()
		while true do
			if self.anm==nil and buttons.select then
				if self.show==true then
					self.anm=false
				else
					self.anm=true
				end
			end
			if self.anm==true then 
				self.posy=self.posy-4 
				if self.posy<170 then self.anm=nil self.show=true end
			elseif self.anm==false then
				self.posy=self.posy+4 
				if self.posy>272 then self.anm=nil self.show=false end
			end
			if self.show==true then
				if buttons.right then
					self.btnIndex=self.btnIndex+1
					if self.btnIndex>1+3*boolTOint(MUSIC_PLAYER==nil) then self.btnIndex=1 end
				elseif buttons.left then
					self.btnIndex=self.btnIndex-1
					if self.btnIndex<1 then self.btnIndex=1+3*boolTOint(MUSIC_PLAYER==nil) end
				end
			end
			if self.show==true or self.anm~=nil then
				draw.fillrect(90,self.posy,300,70,color.new(127,127,127))
				image.blit(self.img,110,self.posy+10,0,0,40,40)
				if MUSIC_PLAYER~=nil then
					image.blit(self.img,200,self.posy+10,40,0,40,40)
					if MUSIC_PLAYER.song~=nil then 
						if sound.playing(MUSIC_PLAYER.song)==true then
							image.blit(self.img,250,self.posy+10,160,0,40,40)
						else
							image.blit(self.img,250,self.posy+10,120,0,40,40)
						end
					else
						image.blit(self.img,250,self.posy+10,120,0,40,40)
					end
					image.blit(self.img,300,self.posy+10,80,0,40,40)
					screen.print(200,self.posy+55,MUSIC_PLAYER.list[MUSIC_PLAYER.index].path,0.5,nero,color.new(0,0,0,0),__SSEESAW,100)
				end
				screen.print(100,self.posy+55,"Screenshot",0.5,nero)
				image.blit(self.img,110+90*boolTOint(self.btnIndex==1)+(50*(self.btnIndex-2))*boolTOint(self.btnIndex<=2),self.posy+10,200,0,40,40)
				if buttons.square then 
					self.btn[self.btnIndex]:fun()
				end
			end
			coroutine.yield()
		end
	end)
end

function NEW_COLL_DESK(type)
	if type=="P" then
		local P=files.listdirs(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM")
		local tab={}
		for i=1,#P do
			tab[i]={}
			tab[i].name=P[i].name
			tab[i].path=P[i].path
		end
		P=nil
		local tabella=NEW_table(0,0,480,258,bianco,color.new(144,144,144),0.7,0.6,bianco,nero,color.new(144,144,144),tab,15)
		local label=LABEL_new(0,258,480,"Premere start per selezionare il programma da collegare al desktop",bianco,color.new(144,144,144))
		local ris=nil
		tabella:addCol("Nome","name")
		tabella:addCol("Path","path")
		Widget:focusOFF()
		while true do 
			buttons.read()
			ris=tabella:blit()
			if ris~=nil then 
				if ris~=-1 then return tab[ris]
				else return ris end
			end
			label:blit()
			mouse:blit()
			screen.flip()
		end
	else
		local P=files.listdirs(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/WIDGET")
		local tab={}
		for i=1,#P do
			tab[i]={}
			tab[i].name=P[i].name
			tab[i].path=P[i].path
			tab[i].attivo=tonumber(ini.read(P[i].path.."/config.ini","display","0"))
		end
		P=nil
		local tabella=NEW_table(0,0,480,258,bianco,color.new(144,144,144),0.7,0.6,bianco,nero,color.new(144,144,144),tab,15)
		local label=LABEL_new(0,258,480,"Premere X per selezionare il widget da attivare",bianco,color.new(144,144,144))
		local ris=nil
		tabella:addCol("Nome","name")
		tabella:addCol("Attivo","attivo")
		Widget:focusOFF()
		while true do 
			buttons.read()
			ris=tabella:blit()
			if buttons.cross then
				if tab[tabella.z].attivo==1 then 
					tab[tabella.z].attivo=0
					ini.write(tab[tabella.z].path.."/config.ini","display","0")
					table.remove(desktop.MODULE,tabella.z)
					table.remove(desktop.WIDGET,tabella.z)
					desktop.W_num=desktop.W_num-1
				else 
					tab[tabella.z].attivo=1
					ini.write(tab[tabella.z].path.."/config.ini","display","1")
					files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS")
					desktop.MODULE[#desktop.MODULE+1]=require("SYSTEM.SYSTEM32.WIDGET."..tab[tabella.z].name..".main")
					desktop.W_num=desktop.W_num+1
				end
			end
			if ris~=nil then 
				return
			end
			label:blit()
			mouse:blit()
			screen.flip()
		end
	end
end

DownloadTool={
	ini=false,
	funF=nil,
	funS=nil
}

function DownloadTool:init(url,savePath)
	if self.ini then
		MSG:type("Attenzione","C'e'gia' un download in corso'",__MBOK,__MBICONINFO)
	else
		self.btnS = BT_IMG_new(325,249,image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/download.png"),image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/downloadh.png"))
		self.btnS:connect("pressed",function()
			image.blit(MSG.sfondo,161,79,0,0,158,113) 
			prbar(181,115,118,12,__NET_THREAD_WRITTEN+1,__NET_THREAD_SIZE,verde,bianco,false)
			screen.print(240-(screen.textwidth("Download in corso...",0.7)/2),85,"Download in corso...",0.7,nero)
			screen.print(171,172,"Velocita' : "..(__NET_THREAD_VELOCITY).." kb/s",0.5,nero,color.new(0,0,0,0))
			screen.print(171,130,"Scaricati' : "..(__NET_THREAD_WRITTEN/100).." kb",0.5,nero,color.new(0,0,0,0))
			screen.print(171,145,"Dimensione file' : "..(__NET_THREAD_SIZE/100).." kb",0.5,nero,color.new(0,0,0,0))
		end)
		http.getfile(url,savePath,1)
		self.ini=true
	end
end

function DownloadTool:blit(offset)
	if self.ini then
		if __NET_THREAD_STATE== 2 or __NET_THREAD_STATE==0 then
			self.btnS:blit(offset)
		elseif __NET_THREAD_STATE==-1 then 
			self.ini=false
			if self.funF~=nil then 
				self:funF()
				self.funF=nil
			else
				MSG:type("ERRORE","Attenzione si e' verificato un errore durante il download",__MBCANC,__MBICONERROR)
			end
		elseif __NET_THREAD_STATE==1 then
			self.ini=false
			if self.funS~=nil then 
				self:funS()
				self.funS=nil
			else
				MSG:type("SUCCESSO","Il download e' stato completato con successo",__MBCANC,__MBICONERROR)
			end
		end
	end
end

function DownloadTool:connectF(f)
	self.funF=f
end

function DownloadTool:connectS(f)
	self.funS=f
end