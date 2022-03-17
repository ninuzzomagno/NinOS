icone_file={}

function icone_file:init()
	self.conf=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/config.png")
	self.file=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/file.png")
	self.gif=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/gif.png")
	self.bmp=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/bmp.png")
	self.png=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/png.png")
	self.jpg=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/jpg.png")
	self.dir=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/excartella.png")
	self.ini=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/ico_ini.png")
	self.txt=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/ico_txt.png")
	self.html=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/html.png")
	self.htm=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/htm.png")
	self.lua=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/lua.png")
	self.iso=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/iso.png")
	self.cso=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/cso.png")
	self.mp3=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/mp3.png")
	self.obj=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/obj.png")
end

function Vlist_new(path,posx,posy,width,m,dir,icon,col,colh)
	local LISTA={
		path=path,
		x=posx,
		y=posy,
		w=width,
		key=key,
		ico=icon,
		txt_c=col,
		txt_ch=colh,
		lista={},
		sel=1,
		SEL=0,
		getSel=function(self)
			return self.SEL
			end,
	}

	image.reset(icone_file.dir)
	image.reset(icone_file.iso)
	image.reset(icone_file.file)
	image.reset(icone_file.cso)
	image.reset(icone_file.conf)
	image.reset(icone_file.gif)
	image.reset(icone_file.bmp)
	image.reset(icone_file.png)
	image.reset(icone_file.html)
	image.reset(icone_file.htm)
	image.reset(icone_file.jpg)
	image.reset(icone_file.lua)
	image.reset(icone_file.txt)
	image.reset(icone_file.ini)
	image.reset(icone_file.mp3)
	image.reset(icone_file.obj)		

	image.resize(icone_file.dir,15,15)

	if dir==true then
		LISTA.lista=files.listdirs(path)

	else
		LISTA.lista=files.list(path)
		image.resize(icone_file.iso,12,15)
		image.resize(icone_file.file,12,15)
		image.resize(icone_file.cso,12,15)
		image.resize(icone_file.conf,12,15)
		image.resize(icone_file.gif,12,15)
		image.resize(icone_file.bmp,12,15)
		image.resize(icone_file.png,12,15)
		image.resize(icone_file.html,12,15)
		image.resize(icone_file.htm,12,15)
		image.resize(icone_file.jpg,12,15)
		image.resize(icone_file.lua,12,15)
		image.resize(icone_file.txt,15,15)
		image.resize(icone_file.ini,15,15)
		image.resize(icone_file.mp3,15,15)
		image.resize(icone_file.obj,15,15)
	end

	LISTA.max=#LISTA.lista

	if LISTA.max==0 then
		LISTA.max=0
	elseif LISTA.max > m then
		LISTA.vmax=m
	else
		LISTA.vmax=LISTA.max
	end

	LISTA.maxletter=string_wpixeltowletter(LISTA.w,0.6)
	LISTA.INI=1

	if icon==true then
		LISTA.X=LISTA.x+18+(LISTA.w)/2
		LISTA.PAD=15
	else
		LISTA.PAD=0
		LISTA.X=LISTA.x+(LISTA.w)/2
	end

	function LISTA:empty()
		if self.max==0 then return true end
		return false
	end

	function LISTA:widgetHover()
		if mouse:getx()>=self.x and mouse:getx()<=self.x+self.w and mouse:gety()>=self.y and mouse:gety()<=self.y+screen.textheight(0.6)*self.max then
			return true 
		end
		return false
	end


	function LISTA:scorri()
		if self:widgetHover() and Widget:isFocus()==false then
			if buttons.l and self.sel>1 then
				self.sel=self.sel-1
				if self.sel<self.INI then
					self.INI=self.INI-1
					self.vmax=self.vmax-1
				end
			elseif buttons.r and self.sel<self.max then
				self.sel=self.sel+1
				if self.sel>self.vmax then
					self.vmax = self.vmax+1
					self.INI=self.INI+1
				end
			elseif buttons.cross then 
				self.SEL=self.sel
			else
				self.SEL=0
			end
		end
	end

	function LISTA:blit()
		if self:empty()==true then
			screen.print(self.x+(self.w/2)-screen.textwidth("La cartella e' vuota",0.6)/2,self.y+screen.textheight(0.6)*self.max/2,"La cartella e' vuota",0.6,rosso) 
		else
		local Y=self.y
		self:scorri()
		for i=self.INI,self.vmax do
			if self.ico == true then
				if self.lista[i].directory==true then
					image.blit(icone_file.dir,self.x,Y)
				else
					if self.lista[i].ext=="ini" or self.lista[i].ext=="obj" or self.lista[i].ext=="txt" or self.lista[i].ext=="conf" or self.lista[i].ext=="mp3" or self.lista[i].ext=="html" or self.lista[i].ext=="htm" or self.lista[i].ext=="lua" or self.lista[i].ext=="gif" or self.lista[i].ext=="iso" or self.lista[i].ext=="cso" or self.lista[i].ext=="jpg" or self.lista[i].ext=="png" or self.lista[i].ext=="bmp" then
						image.blit(icone_file[self.lista[i].ext],self.x,Y)
					else
						image.blit(icone_file.file,self.x,Y)
					end
				end
			end
			if i==self.sel then 
				if screen.textwidth(self.lista[i].name,0.6) > self.w then
					self.X = screen.print(self.X,Y,self.lista[i].name,0.6,self.txt_ch,color.new(0,0,0,0),__SSEESAW,self.w)
				else screen.print(self.x+self.PAD,Y,string.sub(self.lista[i].name,0,LISTA.maxletter),0.6,self.txt_ch) end
			else 
				if screen.textwidth(self.lista[i].name,0.6) > self.w then
					self.X = screen.print(self.X,Y,self.lista[i].name,0.6,self.txt_c,color.new(0,0,0,0),__SSEESAW,self.w)
				else screen.print(self.x+self.PAD,Y,string.sub(self.lista[i].name,0,LISTA.maxletter),0.6,self.txt_c) end
			end
			Y=Y+15
			if i==self.vmax then
				i=self.INI
				Y=self.y
			end
		end
		end
	end

	return LISTA

end

function lista_new(path,posx,posy,width,height,wtext,dir,text_c,POPUP)
	local LISTA={
		x=posx,
		y=posy,
		w=width,
		h=height,
		txt_c=text_c,
		X=1,
		Y=1,
		X_img=math.floor((width)/4),
		Y_img=math.floor((height)/4)+10,
		click=0,
		wtxt=wtext,
		lista={},
		sel=0,
		path=path,
		getSel=function(self)
			return self.SEL
		end,
		SEL=0
	}
	
	local SYS_POPUP=nil

	if POPUP~=nil and POPUP~=false then
		SYS_POPUP=SYS_POPUP_new(POPUP[1],POPUP[2],POPUP[3],POPUP[4],POPUP[5])
	end

	image.reset(icone_file.dir)
	image.reset(icone_file.iso)
	image.reset(icone_file.file)
	image.reset(icone_file.cso)
	image.reset(icone_file.conf)
	image.reset(icone_file.gif)
	image.reset(icone_file.bmp)
	image.reset(icone_file.png)
	image.reset(icone_file.html)
	image.reset(icone_file.htm)
	image.reset(icone_file.jpg)
	image.reset(icone_file.lua)
	image.reset(icone_file.txt)
	image.reset(icone_file.ini)
	image.reset(icone_file.mp3)
	image.reset(icone_file.obj)		

	image.center(icone_file.dir)

	if dir==true then
		LISTA.lista=files.listdirs(path)
	else
		LISTA.lista=files.list(path)
		image.center(icone_file.conf)
		image.center(icone_file.file)
		image.center(icone_file.iso)
		image.center(icone_file.cso)
		image.center(icone_file.jpg)
		image.center(icone_file.png)
		image.center(icone_file.bmp)
		image.center(icone_file.gif)
		image.center(icone_file.lua)
		image.center(icone_file.htm)
		image.center(icone_file.html)
		image.center(icone_file.ini)
		image.center(icone_file.txt)
		image.center(icone_file.mp3)
		image.center(icone_file.obj)
	end

	LISTA.max=table.getn(LISTA.lista)
	LISTA.INI=1
	LISTA.MAX=9

	if LISTA.max < LISTA.MAX then
		LISTA.MAX=LISTA.max
	end

	LISTA.maxletter=string_wpixeltowletter(LISTA.wtxt,0.6)

	function LISTA:hover(i,w,h)
		local IMG_W=w
		local IMG_H=h
		if mouse:getx() >=self.x+self.X*(self.X_img)-IMG_W and mouse:getx()<=self.x+self.X*(self.X_img)+IMG_H and mouse:gety() >=self.y+self.Y*(self.Y_img)-IMG_H and mouse:gety()<=self.y+self.Y*(self.Y_img)+IMG_H then
			if self.sel~=i then
				draw.fillrect(self.x+self.X*(self.X_img)-10-IMG_W,self.y+self.Y*(self.Y_img)-5-IMG_H,IMG_W*2+20,IMG_H*2+10,color.new(176,224,230,100))
			end
			return true
		end
		return false
	end

	function LISTA:empty()
		if self.max==0 then return true end
		return false
	end

	function LISTA:scorri()
		if Widget:isFocus()==false then 
			if buttons.r and self.MAX<self.max then
				self.INI=self.INI+9
				if self.MAX+9 >= self.max then
					self.MAX=self.max
				else
					self.MAX+=9
				end
				self.sel=0
				self.click=0
			elseif buttons.l and self.INI>1 then
				self.MAX=self.INI-1
				self.INI-=9
				self.sel=0
				self.click=0
			elseif buttons.triangle and SYS_POPUP~=nil then
				SYS_POPUP.elem=nil
				SYS_POPUP.path=self.path
				self.sel=0
			end
		end
	end

	function LISTA:double_click(i,w,h)
		if Widget:isFocus()==false then
		if self:hover(i,w,h)==true then
			if buttons.cross then
				if self.sel~=0 and self.sel==i then
					self.click=0
					self.SEL=self.sel
					self.sel=0
				elseif self.sel~=0 and self.sel~=i then
					self.click=1
					self.sel=i
				elseif self.sel==0 then
					self.click+=1
					self.sel=i
					self.X_txt=self.x+self.X*self.X_img
				end
			elseif buttons.triangle and SYS_POPUP~=nil then
				SYS_POPUP.elem=self.lista[i]
				self.sel=i
			end
		end
		end
	end
	
	function LISTA:blit()
		if self:empty()==true then
			screen.print(self.x+(self.w-screen.textwidth("La cartella e' vuota",0.8))/2,10+self.y+self.h/2,"La cartella e' vuota",0.8,rosso) 
			self:scorri()
		else
		self:scorri()
		for i=self.INI,self.MAX do
			if self.lista[i]~=nil then
			if self.lista[i].directory==true then
				if self.sel==i then
					draw.fillrect(self.x+self.X*(self.X_img)-10-20,self.y+self.Y*(self.Y_img)-5-19,60,48,color.new(153,192,197,100))
					if screen.textwidth(self.lista[i].name,0.6) > self.wtxt then
						self.X_txt=screen.print(self.X_txt,self.y+(self.Y*self.Y_img)+23,self.lista[i].name,0.6,self.txt_c,color.new(0,0,0,0),__SSEESAW,self.wtxt)
					else
						screen.print(self.x+(self.X*self.X_img)-screen.textwidth(string.sub(self.lista[i].name,1,self.maxletter),0.6)/2,self.y+(self.Y*self.Y_img)+23,string.sub(self.lista[i].name,1,self.maxletter),0.6,self.txt_c)
					end
				else
					screen.print(self.x+(self.X*self.X_img)-screen.textwidth(string.sub(self.lista[i].name,1,self.maxletter),0.6)/2,self.y+(self.Y*self.Y_img)+23,string.sub(self.lista[i].name,1,self.maxletter),0.6,self.txt_c)
				end
				image.blit(icone_file.dir,self.x+self.X*self.X_img,self.y+self.Y*self.Y_img)
				self:double_click(i,19,20)
			else
				local IMG_W=nil
				local IMG_H=nil
				if self.lista[i].ext=="ini" or self.lista[i].ext=="obj" or self.lista[i].ext=="txt" or self.lista[i].ext=="conf" or self.lista[i].ext=="mp3" or self.lista[i].ext=="html" or self.lista[i].ext=="htm" or self.lista[i].ext=="lua" or self.lista[i].ext=="gif" or self.lista[i].ext=="iso" or self.lista[i].ext=="cso" or self.lista[i].ext=="jpg" or self.lista[i].ext=="png" or self.lista[i].ext=="bmp" then
					IMG_W=image.getw(icone_file[self.lista[i].ext])/2
					IMG_H=image.geth(icone_file[self.lista[i].ext])/2
					image.blit(icone_file[self.lista[i].ext],self.x+self.X*self.X_img,self.y+self.Y*self.Y_img)
					self:double_click(i,IMG_W ,IMG_H)
				else
					IMG_W=image.getw(icone_file.file)/2
					IMG_H=image.geth(icone_file.file)/2
					image.blit(icone_file.file,self.x+self.X*self.X_img,self.y+self.Y*self.Y_img)
					self:double_click(i,IMG_W ,IMG_H)
				end
				if self.sel==i then
					draw.fillrect(self.x+self.X*(self.X_img)-10-IMG_W,self.y+self.Y*(self.Y_img)-5-IMG_H,IMG_W*2+20,IMG_H*2+10,color.new(153,192,197,100))
					--if screen.textwidth(self.lista[i].name,0.6) > self.wtxt then
						--self.X_txt=screen.print(self.X_txt,self.y+(self.Y*self.Y_img)+23,self.lista[i].name,0.6,self.txt_c,color.new(0,0,0,0),__SSEESAW,self.wtxt)
					--else
						screen.print(self.x+(self.X*self.X_img)-screen.textwidth(string.sub(self.lista[i].name,1,self.maxletter),0.6)/2,self.y+(self.Y*self.Y_img)+23,string.sub(self.lista[i].name,1,self.maxletter),0.6,self.txt_c)
					--end
				else
					screen.print(self.x+(self.X*self.X_img)-screen.textwidth(string.sub(self.lista[i].name,1,self.maxletter),0.6)/2,self.y+(self.Y*self.Y_img)+23,string.sub(self.lista[i].name,1,self.maxletter),0.6,self.txt_c)
				end
			end
			if i%3==0 then 
				self.X=1 
				if self.Y==3 then
					self.Y=1
				else
					self.Y=self.Y+1
				end
			else
				self.X=self.X+1
			end
			end
			if i==self.MAX then
				self.X=1
				self.Y=1
			end
		end
		end
		if SYS_POPUP~=nil then SYS_POPUP:blit() end
	end

	return LISTA

end

function draw_pixel(x,y,col)
	draw.line(x-1,y,x,y,col)
end

--function New_display_List_img(posx,posy,row,column,scale,listaImg)
--	local tab={
--		x=posx,
--		y=posy,
--		r=row,
--		c=column,
--		size=scale,
--		tabImg=listaImg
--	}

--	function tab:blit()
		
--	end

--	return tab

--end