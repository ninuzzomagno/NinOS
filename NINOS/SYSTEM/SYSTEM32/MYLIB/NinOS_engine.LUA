__FDSELDIR=0
__FDOPFILE=1
__MBOK=1
__MBOKCANC=2
__MBCANC=3
__MBICONERROR=1
__MBICONINFO=2
__MBICONSUCCESS=3

Widget={
	zindex=0
}

function Widget:focusON()
	if self.zindex==0 then self.zindex=1 end
end

function Widget:focusOFF()
	if self.zindex==1 then self.zindex=0 end
end

function Widget:isFocus()
	if self.zindex==1 then return true end
	return false
end

--LOAD_VRAM=1

file_dialog={}
file_dialog[1]=image.load(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/SYSTEM32/PROGRAM/FILE_DIALOG_SEL_DIR.jpg")
file_dialog[2]=image.load(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/SYSTEM32/PROGRAM/FILE_DIALOG_OPEN_FILE.jpg")

function FILE_DIALOG(tipo,ext)

	local function FILE_DIALOG_ESCI()
		if mouse:getx()>=450 and mouse:getx()<=470 and mouse:gety()>=2 and mouse:gety()<=22 then
			image.blit(kernel.CHIUDI.img_h,450,2)
    		if buttons.cross then
				return 	-2	
    		end
		else image.blit(kernel.CHIUDI.img,450,2) end
		return -1
	end

	local NOME=nil
	local l_files={}
	local l_max=nil
	local PATH=kernel.PATH_INI
	local MAX=12
	local X=90
	local Y=10
	local INI=1
	local scroll_color=color.new(205,205,205)
	local scroll_colorH=color.new(105,105,105)
	local FILE_index=1
	local NOPATH=nil
	local N_FILE=0
	local N_DIR=0
	local EXT_INDEX=nil

	if tipo~=__FDSELDIR then
		if string.sub(ext,-1,-1)=="A" then
			EXT_INDEX=1
		elseif string.sub(ext,1,-2)=="img" then
			if string.sub(ext,-1,-1)=="B" then
				EXT_INDEX=2
			elseif string.sub(ext,-1,-1)=="J" then
				EXT_INDEX=3
			elseif string.sub(ext,-1,-1)=="P" then
				EXT_INDEX=4
			elseif string.sub(ext,-1,-1)=="G" then
				EXT_INDEX=5
			end
		elseif string.sub(ext,1,-2)=="txt" then
			if string.sub(ext,-1,-1)=="T" then
				EXT_INDEX=2
			elseif string.sub(ext,-1,-1)=="L" then
				EXT_INDEX=3
			elseif string.sub(ext,-1,-1)=="H" then
				EXT_INDEX=4
			elseif string.sub(ext,-1,-1)=="I" then
				EXT_INDEX=5
			end
		elseif string.sub(ext,1,-2)=="obj" then
			if string.sub(ext,-1,-1)=="O" then
				EXT_INDEX=2
			elseif string.sub(ext,-1,-1)=="M" then
				EXT_INDEX=3
			end
		end
	end

	local function FILE_DIALOG_RELOAD(l_file,l_max,MAX,FILE_index,PATH,Y,DIRECTORY,ext)
		local L_FILE={}
		local y=0
		N_FILE=0
	    N_DIR=0
		if DIRECTORY==true then
			L_FILE=files.listdirs(PATH)
		else
			l_file=files.list(PATH)
			for i=1,table.getn(l_file) do
				if l_file[i].directory then 
					N_DIR=N_DIR+1
					y=y+1
					L_FILE[y]={}
					L_FILE[y].name=l_file[i].name
					L_FILE[y].directory=true
					L_FILE[y].path=l_file[i].path
				else
					if string.sub(ext,1,-2)=="img" then
						if (string.sub(ext,-1,-1)=='A') or (string.sub(ext,-1,-1)=="B" and string.lower(l_file[i].ext)=="bmp") or (string.sub(ext,-1,-1)=="J" and string.lower(l_file[i].ext)=="jpg") or (string.sub(ext,-1,-1)=="P" and string.lower(l_file[i].ext)=="png") or (string.sub(ext,-1,-1)=="G" and string.lower(l_file[i].ext)=="gif") then
							N_FILE=N_FILE+1
							y=y+1
							L_FILE[y]={}
							L_FILE[y].name=l_file[i].name
							L_FILE[y].size=l_file[i].size
							L_FILE[y].directory=false
							L_FILE[y].ext=l_file[i].ext
							L_FILE[y].path=l_file[i].path
						end
					elseif string.sub(ext,1,-2)=="txt" then
						if (string.sub(ext,-1,-1)=="A") or (string.sub(ext,-1,-1)=="L" and l_file[i].ext=="lua") or (string.sub(ext,-1,-1)=="H" and l_file[i].ext=="html") or (string.sub(ext,-1,-1)=="T" and l_file[i].ext=="txt") or (string.sub(ext,-1,-1)=="I" and l_file[i].ext=="ini") then
							N_FILE=N_FILE+1
							y=y+1
							L_FILE[y]={}
							L_FILE[y].name=l_file[i].name
							L_FILE[y].size=l_file[i].size
							L_FILE[y].directory=false
							L_FILE[y].ext=l_file[i].ext
							L_FILE[y].path=l_file[i].path
						end
					elseif string.sub(ext,1,-2)=="obj" then
						if (string.sub(ext,-1,-1)=="A") or (string.sub(ext,-1,-1)=="O" and l_file[i].ext=="obj") or (string.sub(ext,-1,-1)=="M" and l_file[i].ext=="mtl") then
							N_FILE=N_FILE+1
							y=y+1
							L_FILE[y]={}
							L_FILE[y].name=l_file[i].name
							L_FILE[y].size=l_file[i].size
							L_FILE[y].directory=false
							L_FILE[y].ext=l_file[i].ext
							L_FILE[y].path=l_file[i].path
						end
					end
				end
			end
		end
		l_max=table.getn(L_FILE)
		MAX=12
		FILE_index=1
		INI=1
		Y=10

		if MAX>l_max and l_max~=0 then MAX=l_max 
		elseif l_max==0 then MAX=0 end
		return L_FILE,l_max,MAX,FILE_index,Y
	end

	local function FILE_DIALOG_CERCA()
		NOME=osk.init("","")
		local y=0
		local L_FILE={}
		local L_MAX=nil
		N_FILE=0
	    N_DIR=0
		for i=1,l_max do
			if string.find(string.lower(l_file[i].name),string.lower(NOME))~=nil then
				y=y+1
				L_FILE[y]={}
				L_FILE[y].name=l_file[i].name
				if not(l_file[i].directory) then
					L_FILE[y].size=l_file[i].size
					L_FILE[y].directory=false
					L_FILE[y].ext=l_file[i].ext
					N_FILE=N_FILE+1
				else
					N_DIR=N_DIR+1
					L_FILE[y].directory=true
				end
				L_FILE[y].path=l_file[i].path
			end
		end
		L_MAX=table.getn(L_FILE)
		return L_FILE,L_MAX
	end

	if tipo==__FDSELDIR then
		l_file,l_max,MAX,FILE_index,Y = FILE_DIALOG_RELOAD(l_file,l_max,MAX,FILE_index,PATH,Y,true,ext)
		while true do
			screen.clear(nero)
			buttons.read()
			image.blit(file_dialog[1],0,0)
			if string.len(PATH)>26 then
				screen.print(38,40,string.sub(PATH,1,23).."...",0.7,nero)
			else
				screen.print(38,40,PATH,0.7,nero)
			end
			if l_max~=0 then
				if string.len(l_file[FILE_index].name)<29 then
					screen.print(100,245,l_file[FILE_index].name,0.6,nero)
				else
					screen.print(100,245,string.sub(l_file[FILE_index].name,1,25).."...",0.6,nero)
				end
			end
			screen.print(334,246,"Directory",0.7,color.new(83,91,163))
			if NOME~=nil then screen.print(319,40,NOME,0.7,nero) end
			screen.print(157,68,l_max,0.7,color.new(70,102,175))
			for i=INI,MAX do
				if i==FILE_index then 
					if string.len(l_file[i].name)>38 then 
						X = screen.print(X,90+Y,string.sub(l_file[i].name,1,38),0.6,rosso,color.new(0,0,0,0),__SSEESAW,220)
					else
						screen.print(110,90+Y,l_file[i].name,0.6,rosso)
					end
				else 
					if string.len(l_file[i].name)>38 then screen.print(110,90+Y,string.sub(l_file[i].name,1,35).."...",0.6,nero)
					else screen.print(110,90+Y,l_file[i].name,0.6,nero) end
				end
				Y=Y+10
				if i==MAX then
					i=INI
					Y=10
				end
			end
			if mouse:getx()>=319 and mouse:getx()<=461 and mouse:gety()>=37 and mouse:gety()<=56 and buttons.cross then
				l_file,l_max = FILE_DIALOG_CERCA()
				MAX=12
				FILE_index=1
				INI=1
				Y=10

				if MAX>l_max then MAX=l_max end
			elseif mouse:getx()>=268 and mouse:getx()<=291 and mouse:gety()>=37 and mouse:gety()<=56 and buttons.cross then
				l_file,l_max,MAX,FILE_index,Y = FILE_DIALOG_RELOAD(l_file,l_max,MAX,FILE_index,PATH,Y,true,ext)
			elseif buttons.r and FILE_index<l_max then
				FILE_index=FILE_index+1
				if FILE_index > MAX then
					INI=INI+1
					MAX=MAX+1
				end
			elseif buttons.l and FILE_index>1 then
				FILE_index=FILE_index-1
				if FILE_index < INI then
					INI=INI-1
					MAX=MAX-1
				end
			elseif buttons.start then
					if l_max==0 then return PATH
					else return l_file[FILE_index].path end
			elseif buttons.cross then
				PATH=l_file[FILE_index].path
				l_file,l_max,MAX,FILE_index,Y = FILE_DIALOG_RELOAD(l_file,l_max,MAX,FILE_index,PATH,Y,true,ext)
			elseif buttons.circle and PATH~=kernel.PATH_INI then
				NOPATH=files.nopath(PATH)
				PATH=string.sub(PATH,1,-1-(string.len(NOPATH)))
				l_file,l_max,MAX,FILE_index,Y = FILE_DIALOG_RELOAD(l_file,l_max,MAX,FILE_index,PATH,Y,true,ext)
			end
			scrollbar(472,94,230,7,FILE_index,12,l_max,scroll_color,scroll_colorH)
			if FILE_DIALOG_ESCI()~=-1 then return nil end
			mouse:blit()
			screen.flip()
		end
	elseif tipo==__FDOPFILE then
		l_file,l_max,MAX,FILE_index,Y = FILE_DIALOG_RELOAD(l_file,l_max,MAX,FILE_index,PATH,Y,false,ext)
		while true do
			screen.clear(nero)
			buttons.read()
			image.blit(file_dialog[2],0,0)
			if string.len(PATH)>26 then
				screen.print(38,40,string.sub(PATH,1,23).."...",0.7,nero)
			else
				screen.print(38,40,PATH,0.7,nero)
			end
			if l_max~=0 then
				if string.len(l_file[FILE_index].name)<29 then
					screen.print(100,245,l_file[FILE_index].name,0.6,nero)
				else
					screen.print(100,245,string.sub(l_file[FILE_index].name,1,25).."...",0.6,nero)
				end
			end
			if EXT_INDEX==1 then screen.print(378,246,"All",0.7,nero) 
			elseif "img"==string.sub(ext,1,-2) then 
				if EXT_INDEX==2 then screen.print(378,246,"BMP",0.7,nero)
				elseif EXT_INDEX==3 then screen.print(378,246,"JPG",0.7,nero)
				elseif EXT_INDEX==4 then screen.print(378,246,"PNG",0.7,nero)
				elseif EXT_INDEX==5 then screen.print(378,246,"GIF",0.7,nero)
				end
			elseif "txt"==string.sub(ext,1,-2) then
				if EXT_INDEX==2 then screen.print(378,246,"TXT",0.7,nero)
				elseif EXT_INDEX==3 then screen.print(378,246,"LUA",0.7,nero)
				elseif EXT_INDEX==4 then screen.print(378,246,"HTML",0.7,nero)
				elseif EXT_INDEX==5 then screen.print(378,246,"INI",0.7,nero)
				end
			elseif "obj"==string.sub(ext,1,-2) then
				if EXT_INDEX==2 then screen.print(378,246,"OBJ",0.7,nero)
				elseif EXT_INDEX==3 then screen.print(378,246,"MTL",0.7,nero)
				end
			end
			if NOME~=nil then screen.print(319,40,NOME,0.7,nero) end
			screen.print(157,68,N_DIR,0.7,color.new(70,102,175))
			screen.print(407,68,N_FILE,0.7,color.new(70,102,175))
			for i=INI,MAX do
				if i==FILE_index then 
					if string.len(l_file[i].name)>38 then 
						X = screen.print(X,90+Y,string.sub(l_file[i].name,1,38),0.6,rosso,color.new(0,0,0,0),__SSEESAW,220)
					else
						screen.print(110,90+Y,l_file[i].name,0.6,rosso)
					end
				else 
					if string.len(l_file[i].name)>38 then screen.print(110,90+Y,string.sub(l_file[i].name,1,35).."...",0.6,nero)
					else screen.print(110,90+Y,l_file[i].name,0.6,nero) end
				end
				if not(l_file[i].directory) then screen.print(400,90+Y,math.floor((l_file[i].size)/1024).." KB",0.6,nero) end
				Y=Y+10
				if i==MAX then
					i=INI
					Y=10
				end
			end
			if buttons.cross then
				if mouse:getx()>=319 and mouse:getx()<=461 and mouse:gety()>=37 and mouse:gety()<=56 then
					l_file,l_max = FILE_DIALOG_CERCA()
					MAX=12
					FILE_index=1
					INI=1
					Y=10

					if MAX>l_max then MAX=l_max end
				elseif mouse:getx()>=329 and mouse:getx()<=457 and mouse:gety()>=242 and mouse:gety()<=261 then
					EXT_INDEX=EXT_INDEX+1
					if "img"==string.sub(ext,1,-2) then 
						if EXT_INDEX>5 then EXT_INDEX=1 ext=string.sub(ext,1,-2).."A"
						elseif EXT_INDEX == 2 then ext=string.sub(ext,1,-2).."B"
						elseif EXT_INDEX == 3 then ext=string.sub(ext,1,-2).."J"
						elseif EXT_INDEX == 4 then ext=string.sub(ext,1,-2).."P"
						elseif EXT_INDEX == 5 then ext=string.sub(ext,1,-2).."G"
						end
					elseif "txt"==string.sub(ext,1,-2) then
						if EXT_INDEX>5 then EXT_INDEX=1 ext=string.sub(ext,1,-2).."A"
						elseif EXT_INDEX == 2 then ext=string.sub(ext,1,-2).."T"
						elseif EXT_INDEX == 3 then ext=string.sub(ext,1,-2).."L"
						elseif EXT_INDEX == 4 then ext=string.sub(ext,1,-2).."H"
						elseif EXT_INDEX == 5 then ext=string.sub(ext,1,-2).."I"
						end
					elseif "obj"==string.sub(ext,1,-2) then
						if EXT_INDEX>3 then EXT_INDEX=1 ext=string.sub(ext,1,-2).."A"
						elseif EXT_INDEX == 2 then ext=string.sub(ext,1,-2).."O"
						elseif EXT_INDEX == 3 then ext=string.sub(ext,1,-2).."M"
						end
					end
					l_file,l_max,MAX,FILE_index,Y = FILE_DIALOG_RELOAD(l_file,l_max,MAX,FILE_index,PATH,Y,false,ext)
				elseif l_max~=0 and l_file[FILE_index].directory then 
					PATH=l_file[FILE_index].path
					l_file,l_max,MAX,FILE_index,Y = FILE_DIALOG_RELOAD(l_file,l_max,MAX,FILE_index,PATH,Y,false,ext)
				end
			elseif buttons.r and FILE_index<l_max and l_max~=0 then
				FILE_index=FILE_index+1
				if FILE_index > MAX then
					INI=INI+1
					MAX=MAX+1
				end
			elseif buttons.l and FILE_index>1 and l_max~=0 then
				FILE_index=FILE_index-1
				if FILE_index < INI then
					INI=INI-1
					MAX=MAX-1
				end
			elseif buttons.circle and PATH~=kernel.PATH_INI then
				NOPATH=files.nopath(PATH)
				PATH=string.sub(PATH,1,-1-(string.len(NOPATH)))
				l_file,l_max,MAX,FILE_index,Y = FILE_DIALOG_RELOAD(l_file,l_max,MAX,FILE_index,PATH,Y,false,ext)
			elseif l_max~=0 and buttons.start and l_file[FILE_index].directory==false then
				return l_file[FILE_index].path 
			end
			scrollbar(472,94,230,7,FILE_index,12,l_max,scroll_color,scroll_colorH)
			if FILE_DIALOG_ESCI()~=-1 then return nil end
			mouse:blit()
			screen.flip()
		end
	end
end

batteria={}

function batteria:init()
	self.batteria=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/iconBatteria.png")
	self.charge=0
	self.timer=nil
end

function batteria:blit(x,y)
	self.lv=batt.lifepercent()
	if batt.charging() then
		if self.timer==nil then self.timer=timer.new(0) self.timer:start() end
		image.blit(self.batteria,x,y,10*self.charge,0,10,19)
		if mouse:getx()>=x and mouse:getx()<=x+10 and mouse:gety()>=y and mouse:gety()<=y+19 then
			draw.fillrect(x-10,y-15,30,15,color.new(147,147,147))
		    screen.print(x-7,y-15,self.lv.." %",0.5,color.new(225,247,0))
		end
		if self.timer:time()>300 then
		self.charge=self.charge+1
		if self.charge>4 then self.charge=0 end
		self.timer:reset(0)
		self.timer:start()
		end
	else
		if self.timer~=nil then self.timer=nil end
		if self.lv >=80 and self.lv <=100 then
			image.blit(self.batteria,x,y,40,0,10,19)
			if mouse:getx()>=x and mouse:getx()<=x+10 and mouse:gety()>=y and mouse:gety()<=y+19 then
				draw.fillrect(x-15,y-15,42,15,color.new(147,147,147))
			    screen.print(x-10,y-15,self.lv.." %",0.5,color.new(0,255,0))
			end
		elseif self.lv>=60 and self.lv <=79 then
			image.blit(self.batteria,x,y,30,0,10,19)
			if mouse:getx()>=x and mouse:getx()<=x+10 and mouse:gety()>=y and mouse:gety()<=y+19 then
				draw.fillrect(x-10,y-15,30,15,color.new(147,147,147))
			    screen.print(x-7,y-15,self.lv.." %",0.5,color.new(225,247,0))
			end
		elseif self.lv >=40 and self.lv <=59 then
			image.blit(self.batteria,x,y,20,0,10,19)
			if mouse:getx()>=x and mouse:getx()<=x+10 and mouse:gety()>=y and mouse:gety()<=y+19 then
			    draw.fillrect(x-10,y-15,30,15,color.new(147,147,147))
			    screen.print(x-7,y-15,self.lv.." %",0.5,color.new(235,226,61))
			end
		elseif self.lv >=16 and self.lv <=39 then
			image.blit(self.batteria,x,y,10,0,10,19)
			if mouse:getx()>=x and mouse:getx()<=x+10 and mouse:gety()>=y and mouse:gety()<=y+19 then
				draw.fillrect(x-10,y-15,30,15,color.new(147,147,147))
			    screen.print(x-7,y-15,self.lv.." %",0.5,color.new(214,112,10))
			end
		elseif self.lv >=0 and self.lv <=15 then
		    image.blit(self.batteria,x,y,0,0,10,19)
		    if mouse:getx()>=x and mouse:getx()<=x+10 and mouse:gety()>=y and mouse:gety()<=y+19 then
		        draw.fillrect(x-10,y-15,30,15,color.new(147,147,147))
		        screen.print(x-7,y-15,self.lv.." %",0.5,color.new(255,0,0))
		    end
		end
	end
end

function prbar(x,y,w,h,i,f,ca,cd,ver,round)
	local per=(100*i)/f
	if round==nil then
		if ver==false then
			draw.fillrect(x,y,w,h,cd)
			draw.fillrect(x,y,w*per/100,h,ca)
		else
			draw.fillrect(x,y,w,h,cd)
			draw.fillrect(x,y+h-h*per/100,w,h*per/100,ca)
		end
	else
		if ver==false then
			draw_round_fillrect(x,y,w,h,round,cd)
			draw_round_fillrect(x,y,w*per/100,h,round,ca)
		else
			draw_round_fillrect(x,y,w,h,round,cd)
			draw_round_fillrect(x,y+h-h*per/100,w,h*per/100,round,ca)
		end
	end
	return per
end

function scrollbar(x,yi,yf,w,i,max,f,colore,coloreH)
	if f>max then
		local h=(yf-yi)*max/f
		local pos=(yf-h-yi)*((i-1)/(f-1))
		draw.fillrect(x,yi,w,yf-yi,colore)
		draw.fillrect(x,yi+pos,w,h,coloreH)
	end
end

MSGBOX={
	sound=sound.load(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/AUDIO/error.mp3"),
	sfondo=image.load(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/SYSTEM32/ICONE/msgbox.png")
}

function MSGBOX:new()
	local MSG={
		button=nil,
		icona=nil,
		titolo=nil,
		errore=nil,
		soundB=true,
		showB=false,
		result=nil
	}

	function MSG:connect(IDBTN,f)
		self.IDfunBTN=IDBTN
		self.fun=f
	end

	function MSG:type(titolo,errore,MBID,MBICONID)
		self.titolo=titolo
		self.errore=errore
		self.icona=MBICONID
		self.button=MBID
		self.showB=true
	end

	function MSG:blit()
		if self.showB==true then
			if self.soundB==true then 
				sound.play(MSGBOX.sound,8) 
				Widget:focusON()
				self.soundB=false 
			end
			image.blit(MSGBOX.sfondo,161,79,0,0,158,113)
			if self.button == __MBOK  then 
				if mouse:getx()>=230 and mouse:getx()<=250 and mouse:gety()>=169 and mouse:gety()<=189 then
					image.blit(MSGBOX.sfondo,230,169,163,68,20,20)
					if buttons.cross then 
						self.showB=false
						self.soundB=true
						self.titolo=nil
						self.errore=nil
						if self.IDfunBTN~=nil and self.IDfunBTN==__MBOK then
							self:fun()
							self.IDfunBTN=nil
							self.fun=nil
						end
						Widget:focusOFF()
						return __MBOK
					end     
				else
					image.blit(MSGBOX.sfondo,230,169,188,68,20,20)
				end
			elseif self.button ==__MBOKCANC then
				if mouse:getx()>=260 and mouse:getx()<=280 and mouse:gety()>=169 and mouse:gety()<=189 then
					image.blit(MSGBOX.sfondo,260,169,163,68,20,20)
					image.blit(MSGBOX.sfondo,200,169,188,93,20,20)
					if buttons.cross then
						self.showB=false
						self.soundB=true
						self.titolo=nil
						self.errore=nil
						if self.IDfunBTN~=nil and self.IDfunBTN==__MBOK then
							self:fun()
							self.IDfunBTN=nil
							self.fun=nil
						end
						Widget:focusOFF()
						return __MBOK
					end
				elseif  mouse:getx()>=200 and mouse:getx()<=220 and mouse:gety()>=169 and mouse:gety()<=189 then
					image.blit(MSGBOX.sfondo,260,169,188,68,20,20)
					image.blit(MSGBOX.sfondo,200,169,163,93,20,20)
					if buttons.cross then
						self.showB=false
						self.soundB=true
						self.titolo=nil
						self.errore=nil
						if self.IDfunBTN~=nil and self.IDfunBTN==__MBCANC then
							self:fun()
							self.IDfunBTN=nil
						end
						Widget:focusOFF()
						return ___MBCANC
					end
				else
					image.blit(MSGBOX.sfondo,260,169,188,68,20,20)
					image.blit(MSGBOX.sfondo,200,169,188,93,20,20)
				end
			elseif self.button ==__MBCANC then
				if mouse:getx()>=230 and mouse:getx()<=250 and mouse:gety()>=169 and mouse:gety()<=189 then
					image.blit(MSGBOX.sfondo,230,169,163,93,20,20)        
					if buttons.cross then
						self.showB=false
						self.soundB=true
						self.titolo=nil
						self.errore=nil
						if self.IDfunBTN~=nil and self.IDfunBTN==__MBCANC then
							self:fun()
							self.IDfunBTN=nil
						end
						Widget:focusOFF()
						return __MBCANC
					end     
				else
					image.blit(MSGBOX.sfondo,230,169,188,93,20,20)
				end
			end
			if self.icona==__MBICONERROR then image.blit(MSGBOX.sfondo,171,115,163,38,25,25) 
			elseif self.icona==__MBICONSUCCESS then image.blit(MSGBOX.sfondo,171,115,192,8,25,25) 
			elseif self.icona==__MBICONINFO then image.blit(MSGBOX.sfondo,171,115,163,8,25,25) end
			screen.print(240-(screen.textwidth(self.titolo,0.7)/2),85,self.titolo,0.7,nero)
			screen.print(205,110,self.errore,0.5,nero,color.new(0,0,0,0),__ALEFT,105)
		end
	end

	return MSG

end

VOLUME={}

function VOLUME:init()
	self.vol=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/iconVolume.png")
	self.t_show = timer.new(0)
	self.show=false
end

function VOLUME:blit(offset)
	if hw.volume() > 0 then
       	image.blit(self.vol,378+(offset or 0),250,19,0,19,19)
       	if mouse:getx()>=378 and mouse:getx()<=397 and mouse:gety()>=247 and mouse:gety()<=272 and buttons.cross then
           		hw.volume(0)
       	end
    else
      	image.blit(self.vol,378+(offset or 0),250,0,0,19,19)
       	if mouse:getx()>=378 and mouse:getx()<=397 and mouse:gety()>=247 and mouse:gety()<=272 and buttons.cross then
           		hw.volume(15)
       	end
    end
	if buttons.released.volup or buttons.released.voldown or buttons.held.volup or buttons.held.voldown then
		timer.reset(self.t_show)
		timer.start(self.t_show)
		self.show=true
	end
	if self.show==true and timer.time(self.t_show) <= 1000 then
		draw.fillrect(15,15,25,90,nero)
		prbar(25,25,5,60,hw.volume(),30,CurrentTheme.systemColor2,bianco,true)
		screen.print(18,90,hw.volume(),0.6,bianco)
	else
		timer.stop(self.t_show)
		self.show=false
	end
end

function rectVAL(X,Y,W,H)
	local rect={
		x = X,
		y = Y,
		w = W,
		h = H
	}
end

function BT_IMG_new(posx,posy,IMG,rect,recth)
	local BT={
		x=posx,
		y=posy,
		img=IMG,
		rect=rect,
		rectH=recth,   
		active=true,
		connect=function(self,h,func,a) self.handle=h self.fun=func self.arg=a end,
		disable=function(self) 
					if self.active==true then 
						self.active=false 
					else 
						self.active=true 
					end 
				end,
		isDisabled=function(self)
						if self.active==false then return true end
						return false
				  end,
		hover=function (self)
					if mouse:getx()>=self.x and mouse:getx()<=self.x+self.rect.w and mouse:gety()>=self.y and mouse:gety()<=self.y+self.rect.h then
						return true
					end
					return false
			  end,
		isClicked = function(self)
						if self:hover() and buttons.cross then
							return true
						end
						return false
				  end,
		isPressed=function(self)
						if self:hover() and buttons.held.cross then
							return true
						end
						return false
				  end
	}

	function BT:blit(offset)
		if not(self:hover()) then
			image.blit(self.img,self.x+(offset or 0),self.y,self.rect.x,self.rect.y,self.rect.w,self.rect.h)
		else
			if self.rectH~=nil then 
				image.blit(self.img,self.x+(offset or 0),self.y,self.rectH.x,self.rectH.y,self.rectH.w,self.rectH.h) 
			else 
				image.blit(self.img,self.x+(offset or 0),self.y,self.rect.x,self.rect.y,self.rect.w,self.rect.h) 
			end
			if not(self:isDisabled()) then
				if self.handle=="pressed" and self:isPressed() then
					self.fun(self.arg)
				elseif self.handle=="clicked" and self:isClicked() then
					self.fun(self.arg)
				end
			end
		end
	end

	return BT

end

function BT_new(posx,posy,width,height,txt,txt_size,txt_col,txt_colh,key,bk_colore,bk_coloreh,round)
	local BT={
		x = posx,
		y = posy,
		w = width,
		h = height,
		text=txt,
		text_s=txt_size,
		text_c=txt_col,
		text_ch=txt_colh,
		key=key,
		round_angle=round,
		bk_col=bk_colore,
		bk_col_hv=bk_coloreh,
		active=true,
		connect=function(self,h,func) self.handle=h self.fun=func end,
		disable=function(self) 
					if self.active==true then 
						self.active=false 
					else 
						self.active=true 
					end 
				end,
		isDisabled=function(self)
						if self.active==false then return true end
						return false
				  end,
		hover=function (self)
					if mouse:getx()>=self.x and mouse:getx()<=self.x+self.w and mouse:gety()>=self.y and mouse:gety()<=self.y+self.h then
						return true
					end
					return false
			  end,
		isClicked = function(self)
						if self:hover() and buttons[self.key] then
							return true
						end
						return false
				  end,
		isPressed=function(self)
						if self:hover() and buttons.held[self.key] then
							return true
						end
						return false
				  end,
		chg_text=function(self,testo) self.text=testo end
	}

	function BT:blit(offset)
		if not(self:hover()) then
			if self.round_angle~=nil then
				draw_round_fillrect(self.x+(offset or 0),self.y,self.w,self.h,self.round_angle,self.bk_col)
			else
				draw.fillrect(self.x+(offset or 0),self.y,self.w,self.h,self.bk_col)
			end
			screen.print((offset or 0)+self.x+(self.w-screen.textwidth(self.text,self.text_s))/2,self.y+5+(self.h-screen.textheight(self.text_s))/2,self.text,self.text_s,self.text_c)
		else
			if self.round_angle~=nil then
				draw_round_fillrect(self.x+(offset or 0),self.y,self.w,self.h,self.round_angle,self.bk_col_hv)
			else
				draw.fillrect(self.x+(offset or 0),self.y,self.w,self.h,self.bk_col_hv)
			end
			screen.print((offset or 0)+self.x+(self.w-screen.textwidth(self.text,self.text_s))/2,self.y+5+(self.h-screen.textheight(self.text_s))/2,self.text,self.text_s,self.text_ch)
			if not(self:isDisabled()) then
				if self.handle=="pressed" and self:isPressed() then
					self.fun()
				elseif self.handle=="clicked" and self:isClicked() then
					self.fun()
				end
			end
		end
	end

	return BT

end

function TXT_new(posx,posy,width,txt_color,bk_colore,txt)
	local TXT={
		x=posx,
		y=posy,
		w=width,
		text=txt,
		X=posx+width/2,
		text_c=txt_color,
		bk_col=bk_colore,
		delete=function(self) self.text="" end,
		text_ins=function(self)
					if self:hover() and buttons.cross then
						self.text=osk.init("","")
					end
					return self.text 
				end
	}

--	function TXT:connect(f)
--		self.f=f
--	end

	function TXT:hover()
		if mouse:getx()>=self.x and mouse:getx()<=self.x+self.w and mouse:gety()>=self.y and mouse:gety()<=self.y+14 then
			mouse.cursore=mouse.cursor_text
			draw_rect(self.x,self.y,self.w-1,14,nero)
			return true
		end
		mouse.cursore=mouse.cursor_def
		return false
	end

	function TXT:blit()
		draw.fillrect(self.x,self.y,self.w,14,self.bk_col)
		if self.text~=nil then
			if self:hover() and self.text~=nil then
				if screen.textwidth(self.text)>self.w-6 then
					self.X=screen.print(self.X,self.y+1,self.text,0.6,self.text_c,color.new(0,0,0,0),__SSEESAW,(self.w)-10)
				else
					screen.print(self.x+2,self.y+1,self.text,0.6,self.text_c)
				end
			elseif not(self:hover()) then
				if screen.textwidth(self.text)>self.w-4 then
					screen.print(self.x+2,self.y+1,string.sub(self.text,0,18).."...",0.6,self.text_c)   --da correggere
				else
					screen.print(self.x+2,self.y+1,self.text,0.6,self.text_c)
				end
			end
		end
		self:text_ins()
		end

	return TXT
end

mouse={}

function mouse:init()
	self.cursor_rid=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/mouse_rid.png")
	self.cursor_text=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/mouse_textbox.png")
	self.cursor_def=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/mouse.png")
	self.vel=ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","velocita","5")
	self.x = 240
	self.y = 136
	self.cursore=self.cursor_def
	self.getx=function(self) return self.x end
	self.gety=function(self) return self.y end
end

function mouse:blit()
	local analogX=buttons.analogx
	local analogY=buttons.analogy
	if analogX>20 then 
		self.x=self.x+(self.vel*analogX/128)
	elseif analogX<-20 then
		self.x=self.x-(self.vel*(-analogX)/128)
	end
	if analogY<-20 then
		self.y=self.y-(self.vel*(-analogY)/128)
	elseif analogY>20 then
		self.y=self.y+(self.vel*analogY/128)
	end
	if self.x+image.getw(self.cursore) > 485 then
		self.x=485-image.getw(self.cursore)
	elseif self.x < 0 then
		self.x=0
	end
	if self.y+image.geth(self.cursore)> 282 then
		self.y=282-image.geth(self.cursore)
	elseif self.y < 0  then
		self.y=0
	end
	image.blit(self.cursore,self.x,self.y)
end

function mouse.ch_vel(self,velocita)
	self.vel=velocita
	ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONFIG/mouse.txt","velocita",velocita)
end

function MENU(posx,posy,bk_colore,bk_coloreh,txt_col,txt_colh,txt_s,pad)
	local MENU={
		MH=MH_new(posx,posy,bk_colore,bk_coloreh,txt_col,txt_colh,txt_s),
		MV={},
		add=function(self,testo) self.MH:add(testo) end,
		add_s=function(self,testo,id,disable) self.MV[id]:add(testo,disable or false) end
	}

	function MENU.submenu(self,id)
		local posx=self.MH.x
		local posy=(self.MH.y+screen.textheight(self.MH.text_s))
		for i=1,self.MH.MX_m do
			if id==i then break end
			posx=posx+screen.textwidth(self.MH.list[i].text,self.MH.text_s)+20 
		end
		self.MV[id]=MV_new(posx,posy,0,0,self.MH.bk_col,self.MH.bk_colh,self.MH.text_s,self.MH.text_c,self.MH.text_ch,true,true,pad)
	end

	function MENU.connect(self,id_H,id_V,func)
		self.MV[id_H].list[id_V].fun=func
	end

	function MENU.blit(self)	
		self.MH:blit()
		if self.MV~=nil and self.MH.sel~=0 then
			Widget:focusON()
			self.MV[self.MH:selected()]:blit()
			if self.MV[self.MH:selected()].sel~=0 then
				MENU:res()
				Widget:focusOFF()
			end
		else
			Widget:focusOFF()
		end
	end

	function MENU.res(self)
		self.MV[self.MH.sel].sel=0 self.MH.sel=0
	end

	return MENU

end

function MH_new(posx,posy,bk_colore,bk_coloreh,txt_col,txt_colh,txt_s)
	local MENU={
		text_c=txt_col,
		text_ch=txt_colh,
		text_s=txt_s,
		bk_col=bk_colore,
		bk_colh=bk_coloreh,
		MX_m=0,
		x=posx,
		y=posy,
		list={},
		sel=0,
		selected=function(self,S) if S~=nil then self.sel=S else return self.sel end end
	}

	function MENU.add(self,testo)
		self.MX_m=self.MX_m+1
		self.list[self.MX_m]={}
		self.list[self.MX_m].text=testo
	end

	function MENU:connect(id,FUN)
		self.list[id].fun=FUN
	end

	function MENU.blit(self)
		Widget:focusON()
		draw.fillrect(self.x,self.y,480-(self.x*2),screen.textheight(self.text_s),self.bk_col)
		local X=self.x+10
		for i=1,self.MX_m do
			if (mouse:getx()>=X-10 and mouse:getx()<=X+10+screen.textwidth(self.list[i].text,self.text_s) and mouse:gety()>=self.y and mouse:gety()<=self.y+screen.textheight(self.text_s)) then
				draw.fillrect(X-10,self.y,20+screen.textwidth(self.list[i].text,self.text_s),screen.textheight(self.text_s),self.bk_colh)
				screen.print(X,self.y+5,self.list[i].text,self.text_s,self.text_ch)
				if buttons.cross then
					if self.list[i].fun~=nil then
						self.list[i]:fun()
					else
						if self.sel~=i then
							self.sel=i
						elseif self.sel==i then
							self.sel=0
						end
					end
				end
			elseif self.sel==i then
				draw.fillrect(X-10,self.y,20+screen.textwidth(self.list[i].text,self.text_s),screen.textheight(self.text_s),self.bk_colh)
				screen.print(X,self.y+5,self.list[i].text,self.text_s,self.text_ch)
			else
				screen.print(X,self.y+5,self.list[i].text,self.text_s,self.text_c)
			end
			X=X+screen.textwidth(self.list[i].text,self.text_s)+20
		end
		Widget:focusOFF()
	end

	return MENU

end

function MV_new(posx,posy,width,height,bk_colore,bk_coloreh,txt_s,txt_c,txt_ch,aw,ah,pad)
	local MV={
		x=posx,
		y=posy,
		w=width,
		h=height,
		bk_col=bk_colore,
		bk_colh=bk_coloreh,
		text_s=txt_s,
		text_c=txt_c,
		text_ch=txt_ch,
		MX_m=0,
		list={},
		padding=pad,
		sel=0,
		selected=function(self,S) if S~=nil then self.sel=S else return self.sel end end,
		getLabel=function(self,i) return self.list[i].text end,
		autow=aw,
		autoh=ah
	}

	function MV:add(testo,disabled,picture)
		self.MX_m=self.MX_m+1
		self.list[self.MX_m]={}
		self.list[self.MX_m].text=testo
		self.list[self.MX_m].pic=picture
		if picture~=nil then
			image.resize(self.list[self.MX_m].pic,(screen.textheight(self.text_s)+self.padding)-6,(screen.textheight(self.text_s)+self.padding)-6)
			image.center(self.list[self.MX_m].pic)
		end
		self.list[self.MX_m].dis=disabled or false
		if self.autow==true then
			if self.MX_m==1 then
				if self.list[1].pic~=nil then
					self.w=screen.textwidth(self.list[1].text,self.text_s)+15+screen.textheight(self.text_s)+self.padding
				else
					self.w=screen.textwidth(self.list[1].text,self.text_s)+10
				end
			else
				for i=1,(self.MX_m) do
					if self.list[i].pic~=nil then
						local width=15+screen.textwidth(self.list[i].text,self.text_s)+screen.textheight(self.text_s)
						if  width > self.w then--screen.textwidth(self.list[i+1].text,self.text_s) and screen.textwidth(self.list[i].text,self.text_s) > self.w then
							self.w=width--screen.textwidth(self.list[i].text,self.text_s)+15+screen.textheight(self.text_s)+self.padding
						end
					else
						local width=10+screen.textwidth(self.list[i].text,self.text_s) 
						if width> self.w then --and screen.textwidth(self.list[i].text,self.text_s) > self.w
							self.w=width--screen.textwidth(self.list[i].text,self.text_s)+10
						end
					end
				end
			end
		end
		if self.autoh==true then
			self.h=(screen.textheight(self.text_s)+self.padding)*self.MX_m
		end
	end

	function MV:connect(id,FUN)
		self.list[id].fun=FUN
	end

	function MV.blit(self)
		draw.fillrect(self.x,self.y,self.w,self.h,self.bk_col)
		local  Y=(self.y+self.padding)
		for i=1,self.MX_m do
			if self.list[i].dis==false then
				if (mouse:getx()>=self.x and mouse:getx()<=self.x+self.w and mouse:gety()>Y-self.padding and mouse:gety()<Y+screen.textheight(self.text_s)) or (self.sel==i) then
					draw.fillrect(self.x,Y-self.padding,self.w,self.padding+screen.textheight(self.text_s),self.bk_colh)
					if self.list[i].pic~=nil then
						screen.print(self.x+10+screen.textheight(self.text_s),Y,self.list[i].text,self.text_s,self.text_c)
					else
						screen.print(self.x+5,Y,self.list[i].text,self.text_s,self.text_ch)
					end
					--screen.print(self.x+(self.w-screen.textwidth(self.list[i].text,self.text_s))/2,Y,self.list[i].text,self.text_s,self.text_ch)
					if buttons.cross and self.sel~=i then
						self.sel=i
						if self.list[i].fun~=nil then
							self.list[i]:fun()
						end
					end
				else
					if self.list[i].pic~=nil then
						screen.print(self.x+10+screen.textheight(self.text_s),Y,self.list[i].text,self.text_s,self.text_c)
					else
						screen.print(self.x+5,Y,self.list[i].text,self.text_s,self.text_c)
					end
					--screen.print(self.x+(self.w-screen.textwidth(self.list[i].text,self.text_s))/2,Y,self.list[i].text,self.text_s,self.text_c)
				end
			else
				if self.list[i].pic~=nil then
					screen.print(self.x+10+screen.textheight(self.text_s),Y,self.list[i].text,self.text_s,self.text_c)
				else
					screen.print(self.x+5,Y,self.list[i].text,self.text_s,self.text_c)
				end
				--screen.print(self.x+(self.w-screen.textwidth(self.list[i].text,self.text_s))/2,Y,self.list[i].text,self.text_s,self.text_c)
			end	
			if self.list[i].pic~=nil then
				image.blit(self.list[i].pic,self.x+5+screen.textheight(self.text_s)/2,Y+((self.h/self.MX_m)/2)-3)
			end
			Y=Y+screen.textheight(self.text_s)+self.padding
		end
	end

	return MV

end

function LABEL_new(posx,posy,width,testo,testo_color,bk_color)
	local LABEL={
		x=posx,
		y=posy,
		w=width,
		txt=testo,
		txt_c=testo_color,
		bk_c=bk_color,
		X=posx+width/2
	}
	function LABEL:blit()
		draw.fillrect(self.x,self.y,self.w,14,self.bk_c)
		if screen.textwidth(self.txt)>self.w-4 then
			self.X=screen.print(self.X,self.y+1,self.txt,0.6,self.txt_c,color.new(0,0,0,0),__SSEESAW,(self.w)-10)
		else
			screen.print(self.x+2,self.y+1,self.txt,0.6,self.txt_c)
		end
	end
	return LABEL
end

function DIALOG_new(posx,posy,width,INI,bk_color,img)
	local dialog={
		x=posx,
		y=posy,
		w=width,
		h=0,
		bk_c=bk_color,
		img=img,
		LAB={},
		TXT={}
	}

	if img~=nil then 
		dialog.h=image.geth(img)+10
		dialog.ix=(width/2)-image.getw(img)/2
		dialog.iy=(height/2)-image.geth(img)/2
	end

	function dialog:add_label(testo,posx,width,text_c,bk_col)
		self.L_MAX=#self.LAB+1
		self.LAB[self.L_MAX]=LABEL_new(posx,posy,width,testo,testo_s,testo_color,bk_color)
	end

	function dialog:add_textbox(posx,posy,width,txt_color,bk_colore)
		self.T_MAX=#self.TXT+1
		self.TXT[self.T_MAX]=TXT_new(posx,posy,width,txt_color,bk_colore)
	end

	function dialog:blit()
		draw.fillrect(self.x,self.y,self.w,self.h,self.bk_c)
		if self.img~=nil then
			image.blit(self.img,self.ix+self.x,self.iy+self.y)
		end
		for i=1,self.L_MAX do
			self.LAB[i]:blit()
		end
		for i=1,self.T_MAX do
			self.TXT[i]:blit()
		end
	end

	return dialog

end

function PROG_ESCI()
	kernel.CHIUDI:blit()
	kernel.RIDUCI:blit()
end

startbar={
	listApp={},
	maxListApp=0
}

function startbar:init()
	startbar.maxListApp=ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/startbar.ini","appMax",0)
	for i=1,startbar.maxListApp do
		local NOME=ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/startbar.ini","App"..i,"nome","")
		startbar.listApp[i]={}
		startbar.listApp[i].icona=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/"..NOME.."/icona.png")
		startbar.listApp[i].nome=NOME
		image.resize(startbar.listApp[i].icona,16,16)
	end
	batteria:init()
	VOLUME:init()
	thread:init()
	startbar.BT_start=BT_IMG_new(0,247,image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/iconStartBar.png"),{x=0,y=0,w=56,h=25},{x=56,y=0,w=56,h=25})
	startbar.BT_start:connect("clicked",HOME)
	startbar.BT_not=BT_new(470,247,20,25,"",0,color.new(0,0,0,0),color.new(0,0,0,0),"cross",color.new(69,69,69),color.new(109,109,109))
	startbar.BT_not:connect("clicked",NOTIFICATION_MENU)
	if hw.getmodel()~="Street" then
		startbar.BT_wifi=BT_IMG_new(347,249,image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/iconWifi.png"))
		startbar.BT_wifi:connect("clicked",function()
			if wlan.isconnected()==true then wlan.disconnect()
			elseif wlan.isconnected()==false then 
				local t=wlan.getconfigs() 
				for i=1,table.getn(t) do
					if wlan.connect(i)==0 then 
						MSG_sys:type("Connessione riuscita","Connesso a "..t[i].ssid.." con livello del segnale pari a "..wlan.strength().."%",__MBOK,__MBICONSUCCESS)
						return
					end
				end
				MSG_sys:type("Connessione fallita","Impossibile stabilire una connessione tra la console e l'access point",__MBCANC,__MBICONERROR)
			end
		end)
	end
end

function startbar:blit(offset)
	draw.fillrect((offset or 0),247,480,25,CurrentTheme.systemColor1)
 	batteria:blit(460+(offset or 0),250)
    screen.print(409+(offset or 0),248,string.sub(os.getdate(),17,-4),0.5)
    screen.print(399+(offset or 0),258,string.sub(os.getdate(),4,14),0.4)
    startbar.BT_start:blit(offset)
	if hw.getmodel()~="Street" then 
		if wlan.isconnected()==false then 
			startbar.BT_wifi.rect={
				x=75,
				y=0,
				w=25,
				h=18
			}
		elseif wlan.isconnected()==true then
			if wlan.strength()>=0 and wlan.strength()<=33 then
				startbar.BT_wifi.rect={
					x=0,
					y=0,
					w=25,
					h=18
				}	
			elseif wlan.strength()>=34 and wlan.strength()<=66 then
				startbar.BT_wifi.rect={
					x=25,
					y=0,
					w=25,
					h=18
				}
			else
				startbar.BT_wifi.rect={
					x=50,
					y=0,
					w=25,
					h=18
				}
			end
		end
		startbar.BT_wifi:blit(offset) 
		DownloadTool:blit(offset)
	end
	startbar.BT_not:blit(offset)
	VOLUME:blit(offset)
	if offset==0 or offset==nil then
		thread:blit()
	end
	startbar:blitListApp(offset)
	notification_menu:blit(offset)
	System()
	MSG_sys:blit()
end

function startbar:blitListApp(offset)
	for i=1,startbar.maxListApp do 
		if (mouse:getx()>(75+(i-1)*36) and mouse:getx()< ((75+(i-1)*36)+36) and mouse:gety()>247) then
			draw.fillrect((75+(i-1)*36),247,36,25,color.new(80,80,80))
			if buttons.cross then 
				dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/"..self.listApp[i].nome.."/main.lua")
			elseif buttons.circle then
				for y=1,startbar.maxListApp do
					if i~=y then
						ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/startbar.ini","App"..y,"nome",ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/startbar.ini","App"..i,"nome",""))
					else
						table.remove(startbar.listApp,i)
					end
				end
				startbar.maxListApp-=1

				ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/startbar.ini","appMax",startbar.maxListApp)
				return 
			end
		end
		image.blit(self.listApp[i].icona,((offset or 0)+85+(i-1)*36),251)
	end
end

function SLIDER_new(posx,posy,width,color,color_C,ini,fin,v)
	local SLIDER={
		x=posx,
		y=posy,
		w=width,
		col=color,
		col_C=color_C,
		v_i=ini,
		v_f=fin,
		val=v,
		c_y=posy+3,
		getVal=function(self) return self.val end,
		connect=function(self,f) self.fun=f end
	}

	function SLIDER:hover()
		if mouse:getx()>=self.x and mouse:getx()<=self.x+self.w and mouse:gety()>=self.y and mouse:gety()<=self.y+6 then
			return true
		end
		return false
	end

	function SLIDER:blit()
		if self:hover() and buttons.held.cross then
			self.val=(mouse:getx()-self.x)*self.v_f/self.w
			if self.val==0 then self.val=self.val+1 end
		elseif self:hover() and buttons.released.cross and self.fun~=nil then
			self.fun()
		end
		draw.fillrect(self.x,self.y,self.w,6,self.col)
		draw.gradcircle((self.val*self.w/self.v_f)+self.x,self.c_y,8,self.col_C,self.col_C,30)
	end

	return SLIDER

end

function CHECKBT_new(posx,posy,bk_col,bk_colh,text,textc,dis)
	local CHECKBT={
		x=posx,
		y=posy,
		bk_c=bk_col,
		bk_ch=bk_colh,
		txt=text,
		txtc=textc,
		sel=false,
		disable=dis or false,
		arg=nil
	}

	function CHECKBT:connect(f,arg)
		self.fun=f
		self.arg=arg
	end

	function CHECKBT:getVal()
		return self.sel 
	end

	function CHECKBT:hover()
		if Widget:isFocus()==false then
			if mouse:getx()>=self.x and mouse:getx()<=self.x+11 and mouse:gety()>=self.y and mouse:gety()<=self.y+11 then
				return true
			end
		end
		return false
	end

	function CHECKBT:blit()
		if self.disable==false then
			if self:hover() and buttons.cross then
				if self.sel==true then
					self.sel=false
					if self.fun~=nil then
						self:fun(self.arg)
					end
				else 
					self.sel=true
					if self.fun~=nil then
						self:fun(self.arg)
					end 
				end 
			end
		end
		draw.fillrect(self.x,self.y,11,11,self.bk_c)
		screen.print(self.x+16,self.y,self.txt,0.6,self.txtc)
		if self.sel==true then
			draw.fillrect(self.x+2,self.y+2,7,7,self.bk_ch)
		end
	end

	return CHECKBT

end

function draw_rect(x,y,w,h,c)
	draw.line(x-1,y,x+w+2,y,c)
	draw.line(x-1,y,x,y+h,c)
	draw.line(x+w+2,y,x+w+2,y+h,c)
	draw.line(x-1,y+h,x+w+2,y+h,c)
end

function draw_round_fillrect(posx,posy,width,height,round,color)
	draw.gradcircle(posx+round,posy+round,round,color,color,40)
	draw.gradcircle(posx+width-round,posy+round,round,color,color,40)
	draw.gradcircle(posx+round,posy+height-round,round,color,color,40)
	draw.gradcircle(posx+width-round,posy+height-round,round,color,color,40)
	draw.fillrect(posx+round,posy,width-2*round,height,color)
	draw.fillrect(posx,posy+round,round,height-2*round,color)
	draw.fillrect(posx+width-round,posy+round,round,height-2*round,color)
end

function BT_TOGGLE_new(posx,posy,dis)
	local BT={
		x=posx,
		y=posy,
		run=fun,
		stato=st,
		disable=dis,
		img_toggle=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/toggle.png")
	}

	function BT:connect(f)
		self.run=f
	end

	function BT:hover()
		if mouse:getx()>=self.x and mouse:getx()<=self.x+50 and mouse:gety()>=self.y and mouse:gety()<=self.y+25 then
			return true
		end
		return false
	end
	
	function BT:clicked()
		if self:hover() and buttons.cross then
			return true
		end
		return false
	end

	function BT:blit(cond)
		if self.stato==true then
			image.blit(self.img_toggle,self.x,self.y,52,0,50,25)
		else
			image.blit(self.img_toggle,self.x,self.y,0,0,50,25)
		end
		if self:clicked() and self.disable==false then 
			self:run()
		end
		BT:init(cond)
	end

	function BT:init(cond)
		self.stato=cond
	end

	return BT

end

function TXTBOX_MULTI(posx,posy,width,height,txt_col,bk_colore,border_color,txt_size)
	local TXT={
		x=posx,
		y=posy,
		w=width,
		h=height,
		txt_c=txt_col,
		bk_col=bk_colore,
		bor_col=border_color or color.new(0,0,0,0),
		txt=nil,
		txt_s=txt_size,
		testo=nil
	}

	function TXT:connect_file(file)
		self.testo=io.open(file.path.."/"..file.name,"r")
		self.maxRIGHE=math.floor(((self.h-4)/screen.textheight(self.txt_s)))
		local i=1
		while true do
			local txt=self.testo:read("*line")
			if txt==nil or i>self.maxRIGHE then 
				break
			end
			if screen.textwidth(txt,self.txt_s) > self.w then
				local r=math.floor(screen.textwidth(txt,self.txt_s)/self.w)/2
				self.maxRIGHE=self.maxRIGHE-r
			end
			txt=i..")   "..txt.."\n" 
			if self.txt==nil then
				self.txt=txt
			else
				self.txt=self.txt..txt
			end
			i=i+1
		end
	end

	function TXT:hover()
		if mouse:getx()>=self.x and mouse:getx()<=self.x+self.w and mouse:gety()>=self.y and mouse:gety()<=self.y+self.h then
			return true
		end
		return false
	end

	function TXT:sc_txt()
		if self:hover() then
			if buttons.r then
				local i=self.maxRIGHE+(self.add or 1)
				self.add=i
				self.maxRIGHE=math.floor(((self.h-4)/screen.textheight(self.txt_s)))
				self.txt=nil
				while true do
					local txt=self.testo:read("*line")
					if txt==nil or i>self.maxRIGHE+self.add-1 then 
						break
					end
					if screen.textwidth(txt,self.txt_s) > self.w then
						local r=math.floor(screen.textwidth(txt,self.txt_s)/self.w)/2
						self.maxRIGHE=self.maxRIGHE-r
					end
					txt=i..")   "..txt.."\n" 
					if self.txt==nil then
						self.txt=txt
					else
						self.txt=self.txt..txt
					end
					i=i+1
				end
			elseif buttons.l then
			end
		end
	end

	function TXT:blit()
		draw.fillrect(self.x,self.y,self.w,self.h,self.bk_col)
		draw_rect(self.x,self.y,self.w,self.h,self.bor_col)
		screen.print(self.x+2,self.y+2,self.txt or "",self.txt_s,self.txt_c,color.new(0,0,0,0),__ALEFT,self.w-4)
		self:sc_txt()
	end

	return TXT

end

function WAVE_new(path,colore,v)

	local wave={
		img=image.load(path),
		col=colore,
		x=240,
		vel=v,
	}

	image.center(wave.img)

	function wave:blit()
		draw.fillrect(0,0,480,247,wave.col)
		image.blit(wave.img,wave.x,136)
		image.blit(wave.img,wave.x-480,136)
		wave.x+=wave.vel
		if wave.x>720 then wave.x=240 end
	end

	if wave.img==nil then return nil
	else return wave end

end

function NEW_table(posx,posy,width,height,backCol,heaCol,sizeH,sizeT,colorH,colorh,colort,tab,max)
	local TABLE={
		x=posx,
		y=posy,
		w=width,
		h=height,
		sizeHeader=sizeH,
		sizeText=sizeT,
		backCol=backCol,
		heaCol=heaCol,
		colorHeaderTxt=colorH,
		colorHoverTxt=colorh,
		colorTxt=colort,
		tab=tab,
		z=1,
		ini=1,
		Header={}
	}

	if tab~=nil then
		TABLE.max=#TABLE.tab
	else
		TABLE.max=0
	end

	if TABLE.max > max then
		TABLE.vmax=max
	else
		TABLE.vmax=TABLE.max
	end

	function TABLE:addCol(text,P)
		local h=table.getn(self.Header)+1
		self.Header[h]={}
		self.Header[h].txt=text
		self.Header[h].par=P
		for i=1,h do 
			self.Header[i].div=self.w/h
		end
	end

	function TABLE:blit()
		local div=0
		draw.fillrect(self.x,self.y,self.w,self.h,self.backCol)
		draw.fillrect(self.x,self.y,self.w,screen.textheight(self.sizeHeader)-2,self.heaCol)
		local hover=false
		for i=1,#self.Header do
			if screen.textwidth(self.Header[i].txt,self.sizeHeader)<self.Header[i].div-10 then
				screen.print(self.x+div+(self.Header[i].div-screen.textwidth(self.Header[i].txt,self.sizeHeader))/2,self.y+2,self.Header[i].txt,self.sizeHeader,self.colorHeaderTxt)
			else
				local testo=string.sub(self.Header[i].txt,1,string_wpixeltowletter(self.Header[i].div-10,self.sizeHeader))
				screen.print(self.x+div+(self.Header[i].div-screen.textwidth(testo,self.sizeHeader))/2,self.y+2,testo,self.sizeHeader,self.colorHeaderTxt)
			end
			div+=self.Header[i].div
			if i~=#self.Header then
				draw.line(self.x+div,self.y,self.x+div,self.y+self.h,self.heaCol)
				if Widget:isFocus()==false then
					if mouse:getx()>=self.x+div-20 and mouse:getx()<=self.x+div+20 and mouse:gety()>=self.y and mouse:gety()<=self.y+self.h then
						hover=true
						if buttons.held.cross then
							if i<table.getn(self.Header) then
								local h=self.Header[1].div
								for y=2,i do
									h+=self.Header[y].div
								end
								self.Header[i+1].div = self.Header[i+1].div+h-(mouse:getx()-self.x)
								self.Header[i].div = self.Header[i].div-(h-(mouse:getx()-self.x))
								h=nil
							end
						end
					end
				end
			end
		end
		if hover then mouse.cursore=mouse.cursor_rid
		else mouse.cursore=mouse.cursor_def
		end
		div=0
		if tab~=nil and #tab~=0 then
		local c=1
		for i=self.ini,self.vmax do
			for y=1,#self.Header do
				if i==self.z then
					if screen.textwidth(self.tab[i][self.Header[y].par],self.sizeText)<self.Header[y].div-20 then
						screen.print(5+self.x+div,self.y-10+screen.textheight(self.sizeHeader)+((screen.textheight(self.sizeText)-5)*c),self.tab[i][self.Header[y].par] or "",self.sizeText,self.colorHoverTxt)
					else
						screen.print(5+self.x+div,self.y-10+screen.textheight(self.sizeHeader)+((screen.textheight(self.sizeText)-5)*c),string.sub(self.tab[i][self.Header[y].par] or "",1,string_wpixeltowletter(self.Header[y].div-20,self.sizeText)),self.sizeText,self.colorHoverTxt)
					end
				else
					if screen.textwidth(self.tab[i][self.Header[y].par],self.sizeText)<self.Header[y].div-20 then
						screen.print(5+self.x+div,self.y-10+screen.textheight(self.sizeHeader)+((screen.textheight(self.sizeText)-5)*c),self.tab[i][self.Header[y].par] or "",self.sizeText,self.colorTxt)
					else
						screen.print(5+self.x+div,self.y-10+screen.textheight(self.sizeHeader)+((screen.textheight(self.sizeText)-5)*c),string.sub(self.tab[i][self.Header[y].par] or "",1,string_wpixeltowletter(self.Header[y].div-20,self.sizeText)),self.sizeText,self.colorTxt)
					end
				end
				div+=self.Header[y].div
			end
			c+=1
			if c>(self.vmax-self.ini+1) then c=1 end
			div=0
		end
		if Widget:isFocus()==false then 
			if mouse:getx()>=self.x and mouse:getx()<=self.x+self.w and mouse:gety()>=self.y and mouse:gety()<=self.y+self.h then 
				if buttons.l and self.z>1 then
					self.z=self.z-1
					if self.z<self.ini then
						self.ini=self.ini-1
						self.vmax=self.vmax-1
					end
				elseif buttons.r and self.z<self.max then
					self.z=self.z+1
					if self.z>self.vmax then
						self.vmax = self.vmax+1
						self.ini=self.ini+1
					end
				elseif buttons.start then
					mouse.cursore=mouse.cursor_def
					return self.z
				elseif buttons.circle then
					mouse.cursore=mouse.cursor_def
					return -1
				end
			end
		end
		end
		return nil
	end

	return TABLE

end

function SIDEMENU_new(posx,posy,bk_col,bk_colh,txt_s,txt_c,txt_ch)
	local SIDE={
		x=posx,
		y=posy,
		side=s,
		menu=MV_new(0,0,0,0,bk_col,bk_colh,txt_s,txt_c,txt_ch,true,true,2),
		show=false,
		anim=false,
		img=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/sideMenuIcon.png")
	}

	function SIDE:hover()
		if mouse:getx()>=self.x+10 and mouse:getx()<=self.x+30 and mouse:gety()>=self.y+10 and mouse:gety()<=self.y+25 then 
			return true
		end
		return false
	end

	function SIDE:addItem(testo,fun,pic,dis)
        self.menu:add(testo,dis,pic)
		self.menu:connect(self.menu.MX_m,fun)
    end

	function SIDE:blit()
		if self:hover() and buttons.cross then 
			if self.show==false then self.show=true Widget:focusON()
			else self.show=false Widget:focusOFF() end 
		end
		if self.show then
			draw.fillrect(self.x,self.y,self.menu.w+20,self.menu.h+45,self.menu.bk_col)
			self.menu:blit()
		end
		image.blit(self.img,self.x+10,self.y+10)
	end

	SIDE.menu.y=posy+10+23
	SIDE.menu.x=posx+10

	return SIDE

end