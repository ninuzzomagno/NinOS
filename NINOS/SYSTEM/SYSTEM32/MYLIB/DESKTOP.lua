DESKTOP=1
MAX_DESKTOP=tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","max_desk",1))

desktop={
	i=0,
	sel=0
}

deskop1={
	i=0,
	sel=0
}

DESK_POPUP={
	show=false
}


function switchDesk()
	if DESKTOP==1 and MAX_DESKTOP==2 then DESKTOP=2
	elseif DESKTOP==2 then DESKTOP=1 end
end

function POPUP_desktop_control()
	if buttons.triangle then
		if desktop.sel==0 then
			DESK_POPUP:init(0)
			return
		elseif desktop:hover(desktop.sel) then	
			DESK_POPUP:init(desktop.sel)
			desktop.sel=0
			return
		end
	end
	if buttons.circle then
		DESK_POPUP.show=false
		DESK_POPUP.menu=nil
		Widget:focusOFF()
	end
	if DESK_POPUP.show then
		DESK_POPUP:blit()
	end
end


function DESK_POPUP:init(pop_prog)

	Widget:focusON()
	
	self.show=false

	if pop_prog~=0 then
		self.sel=pop_prog
		self.menu=MV_new(mouse:getx(),mouse:gety(),0,0,CurrentTheme.MenuBackColor,CurrentTheme.MenuBackColorHov,0.5,CurrentTheme.MenuBackColorItem,CurrentTheme.MenuBackColorItemHov,true,true,1)

		self.menu:add("Avvia")
		self.menu:connect(1,function()
			dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/"..desktop.PROG[self.sel].nome.."/main.lua")
		end)

		self.menu:add("Percorso file")
			self.menu:connect(2,function()
				explorer_path=kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/"..desktop.PROG[self.sel].nome
				dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/EXPLORER/main.lua")
			end)

		self.menu:add("Elimina")
			self.menu:connect(3,function()
				ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/"..desktop.PROG[self.sel].nome.."/config.ini","display",0)
				table.remove(desktop.PROG,self.sel)
				desktop.P_num-=1
			end)

		if mouse:getx()+self.menu.w > 480 then 
			self.menu.x=480-self.menu.w
		end
		if mouse:gety()+self.menu.h > 247 then 
			self.menu.y=247-self.menu.h
		end

	else
		self.sel=0
		self.menu=MV_new(mouse:getx(),mouse:gety(),0,0,CurrentTheme.MenuBackColor,CurrentTheme.MenuBackColorHov,0.5,CurrentTheme.MenuBackColorItem,CurrentTheme.MenuBackColorItemHov,true,true,2)
		self.menu:add("Crea collegamento")
			self.menu:connect(1,function()
				if self.P_num==15 then 
					MSG_sys:type("Attenzione","Sono presenti troppe icone sul desktop",__MBCANC,__MBICONERROR)
				else
					local added=NEW_COLL_DESK("P")
					if added==-1 then return end
					ini.write(added.path.."/config.ini","display","1")
					desktop:reload("P")
					return
				end
			end)
		
		self.menu:add("Widget")
			self.menu:connect(2,function()
			if self.W_num==4 then 
					MSG_sys:type("Attenzione","Sono presenti troppi widget sul desktop",__MBCANC,__MBICONERROR)
				else
					NEW_COLL_DESK("W")
					return
				end
			end)

		self.menu:add("Sfondo")
			self.menu:connect(3,function()
				imp_sys_pag=6
				dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/SISTEMA/main.lua")
			end)

		if MAX_DESKTOP==2 then 
			self.menu:add("Add desktop",true)
		else 
			self.menu:add("Add desktop")
				self.menu:connect(4,function()
					MAX_DESKTOP=2
					ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","max_desk",MAX_DESKTOP)
					thread.lista[2]={}
					thread.proc_att[2]=0
				end)
		end

		if MAX_DESKTOP==2 then 
			self.menu:add("Elimina desktop 2")
				self.menu:connect(5,function()
					MAX_DESKTOP=1
					DESKTOP=1
					DELETE_DESKTOP_bool=true
					DELETE_DESKTOP_function_coroutine=coroutine.create(DELETE_DESKTOP_function)
				end)
		else 
			self.menu:add("Elimina desktop 2",true)
		end

		if mouse:getx()+self.menu.w > 480 then 
			self.menu.x=480-self.menu.w
		end
		if mouse:gety()+self.menu.h > 247 then 
			self.menu.y=247-self.menu.h
		end

	end

	self.show=true

end

function DELETE_DESKTOP_function()
	ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","max_desk",MAX_DESKTOP)
	for i=1,table.getn(thread.lista[2]) do
		thread.lista[2][i].del=true
	end
	thread.lista[2]=nil
	thread.proc_att[2]=nil
end

function DESK_POPUP:blit()
	if self.show==true then
		self.menu:blit()
		if self.menu.sel~=0 then 
			Widget:focusOFF()
			self.show=false 
			self.menu=nil
		end
	end
end

function desktop:reload(t)
	if t=="P" then
		self.PROG=nil
		self.PROG={}
		local l=files.listdirs(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM")
		self.P_num=table.getn(l)
		local y=0
		local c=1
		local z=1
		local POSX_ini=40
		local POSY_ini=40
		for i=1,self.P_num do
			if tonumber(ini.read(l[i].path.."/config.ini","display",0))==1 and y<15 then
				y+=1
				self.PROG[y]={}
				self.PROG[y].icona=image.load(l[i].path.."/icona.png")
				image.center(self.PROG[y].icona)
				self.PROG[y].x=POSX_ini+80*(c-1)
				self.PROG[y].y=POSY_ini+60*(z-1)
				self.PROG[y].nome=l[i].name
				if y==5*z then z=z+1 c=0 end
				c=c+1 
			end
		end
		self.P_num=y
	else
		files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS")
		local y=0
		self.WIDGET=nil
		self.WIDGET={}
		self.MODULE=nil
		self.MODULE={}
		local l=files.listdirs(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/WIDGET")
		self.W_num=table.getn(l)
		for i=1,self.W_num do
			if tonumber(ini.read(l[i].path.."/config.ini","display","0"))==1 and y<4 then
				y+=1
				self.MODULE[y]=require("SYSTEM.SYSTEM32.WIDGET."..l[i].name..".main")
			end
		end
		self.W_num=y
	end
end

function desktop:init()
	LoadDefTheme()
	self.t=timer.new(0)
	self.t:stop()
	desktop:reload("P")
	desktop:reload("W")
end

function desktop:hover(i)
	if mouse:getx()>=self.PROG[i].x-20 and mouse:getx()<=self.PROG[i].x + 20 and mouse:gety()>=self.PROG[i].y-20 and mouse:gety()<=self.PROG[i].y + 20 then
		return true
	end
	return false
end

function desktop:double_click(i)
	if self.sel~=0 and self:hover(self.sel) and Widget:isFocus()==false then
		if buttons.held.cross and self.t:time()>=500 then
			self.PROG[self.sel].x=mouse:getx()-10
			self.PROG[self.sel].y=mouse:gety()-10
		elseif buttons.held.cross and self.t:time()==0 then
			self.t:start()
			self.PROG[self.sel].x_temp=self.PROG[self.sel].x
			self.PROG[self.sel].y_temp=self.PROG[self.sel].y
		end
		if buttons.released.cross then
			self.t:reset(0)
			--if self.PROG[self.sel].x+10<10 then self.PROG[self.sel].x=10 end
			--if self.PROG[self.sel].y+10<10 then self.PROG[self.sel].y=10 end
			self.PROG[self.sel].x_temp=nil
			self.PROG[self.sel].y_temp=nil
			self.sel = 0
		end
	end
	if self:hover(i)==true and Widget:isFocus()==false then
		if buttons.triangle then
			self.i=1
			self.sel=i
		elseif buttons.cross then
			self.i=self.i+1
			self.sel=i
		elseif buttons.square then
			startbar.maxListApp=table.getn(startbar.listApp)+1
			startbar.listApp[startbar.maxListApp]={
				icona=image.copy(self.PROG[i].icona),
				nome=self.PROG[i].nome
			}
			image.resize(startbar.listApp[startbar.maxListApp].icona,16,16)
			ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/startbar.ini","appMax",startbar.maxListApp)
			ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/startbar.ini","App"..startbar.maxListApp,"nome",self.PROG[i].nome)
			return
		end
		if self.i==2 then
			self.i=0
			self.sel=0
			if self.PROG[i].nome=="Browser" then
				MSG_sys:type("Attenzione","Avviando il browser internet si uscira' da NinOS. Si vuole avviare il browser?",__MBOKCANC,__MBICONINFO)
				MSG_sys:connect(__MBOK,function()
					dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/Browser/main.lua")
				end)
			else
				dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/"..self.PROG[i].nome.."/main.lua")
			end
		end
		if self.sel~=i then
			draw.fillrect(self.PROG[i].x-30,self.PROG[i].y-25,60,62,color.new(176,224,230,100))
		end
	end
end

function desktop:blit(offset)
	sfondo:blit(offset)
	if self.sel~=0 then
		if self.i<2 and self:hover(self.sel)==false and buttons.cross then
			self.i=0
			self.sel=0
		end
	end
	for i=1,self.P_num do
		self:double_click(i)
		if self.sel==i then
			draw.fillrect(self.PROG[i].x-30+(offset or 0),self.PROG[i].y-25,60,62,color.new(153,192,197,100))
		end
		image.blit(self.PROG[i].icona,self.PROG[i].x+(offset or 0),self.PROG[i].y)
		screen.print((offset or 0)+(self.PROG[i].x-30)+(60-screen.textwidth(self.PROG[i].nome,0.6))/2,self.PROG[i].y+22,self.PROG[i].nome,0.6,bianco)
		if self.sel~=0 and self.PROG[self.sel].x_temp~=nil and i==self.P_num then
			image.blit(self.PROG[self.sel].icona,self.PROG[self.sel].x+(offset or 0),self.PROG[self.sel].y)
			screen.print((offset or 0)+(self.PROG[self.sel].x-30)+(60-screen.textwidth(self.PROG[self.sel].nome,0.6))/2,self.PROG[self.sel].y+22,self.PROG[self.sel].nome,0.6,bianco)
		end
	end
	for i=1,self.W_num do
		self.WIDGET[i]()
	end
	startbar:blit(offset)
	POPUP_desktop_control()
	if DELETE_DESKTOP_bool~=nil then 
		coroutine.resume(DELETE_DESKTOP_function_coroutine)
		DELETE_DESKTOP_bool=nil
	end
	mouse:blit()
end