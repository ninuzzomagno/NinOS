sfondo={}

function sfondo:init(theme)
	self.dim=tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","dinamicBackground",-1))
	if self.dim==-1 then
		self.dim=tonumber(ini.read(theme,"dinamicBackground",1))
		local IMG=ini.read(theme,"backgroundIMG",1)
		if self.dim then
			self.wave=WAVE_new(IMG,color.new(tonumber(ini.read(theme,"backgroundCOL_R",255)),tonumber(ini.read(theme,"backgroundCOL_G",255)),tonumber(ini.read(theme,"backgroundCOL_B",255))),tonumber(ini.read(theme,"waveVel",3)))
		else
			self.background=image.load(IMG)
			image.center(self.background)
		end
	else
		if self.dim==1 then
			self.wave=WAVE_new(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/DINAMICI/Wave1.png",color.new(tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","wavecolor_R",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","wavecolor_G",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","wavecolor_B",255))),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","waveVel",3)))
		else
			self.background=image.load(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","back_desk",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/default.jpg"))
			image.center(self.background)
		end	
	end
end

function sfondo:blit(offset)
	if self.dim==1 then
		self.wave:blit()
	else
		image.blit(self.background,240+(offset or 0),136)
	end
end

function sfondo_update()
	sfondo.dim=tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","dinamicBackground",-1))
	if sfondo.dim==1 then
		sfondo.wave=WAVE_new(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/DINAMICI/Wave1.png",color.new(tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","wavecolor_R",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","wavecolor_G",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","wavecolor_B",255))),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","waveVel",3)))
	else
		sfondo.background=image.load(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","back_desk",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/default.jpg"))
		image.center(sfondo.background)
	end
end

anm={
	FADE_IN=function(self,a)
			self.OP=255
			self.acc=-a
			end,
	FADE_OUT=function(self,a)
			self.OP=0
			self.acc=a
			end,
	FADE_TOOGLE=function(self,a,ini_op)
			self.OP=ini_op
			self.acc=a
			end
}

function anm.move(self,img,posxi,posyi,posxf,posyf,accx,accy)
	image.blit(img,posxi,posyi)
	if posxi < posxf then
		posxi=posxi+accx
	elseif posxi > posxf then
		posxi=posxi-accx
	end
	if posyi < posyf then
		posyi=posyi+accy
	elseif posyi > posyf then
		posyi=posyi-accy
	end
	return posxi,posyi
end

function anm.blit_FADE(self)
	draw.fillrect(0,0,480,272,color.new(0,0,0,self.OP))
	self.OP=self.OP+self.acc
end

function anm.blit_FADE_T(self)
	draw.fillrect(0,0,480,272,color.new(0,0,0,self.OP))
	if self.OP>=255 then self.acc=-(math.abs(self.acc))
	elseif self.OP<=0 then self.acc=math.abs(self.acc) end
	self.OP=self.OP+self.acc
end