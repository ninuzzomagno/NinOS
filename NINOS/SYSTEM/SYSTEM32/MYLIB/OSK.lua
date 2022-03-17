OSK={
	posyiB=-63,
	posyfB=-9,
	posyiTC=380,
	posyfTC=108,
	reset=function(self)
		self.posyiB=-63
		self.posyfB=-9
		self.posyiTC=380
		self.posyfTC=108
		self.animazionein=true
		self.animazioneout=false
		self.selx=0
		self.sely=0
		self.testo=""
		end,
	caratteri={'q','w','e','r','t','y','u','i','o','p',"canc",'a','s','d','f','g','h','j','k','l','\n',"MAIUSC",'z','x','c','v','b','n','m',',','.',"MAIUSC","NUM"," ","NUM","TAST"}
}

function OSK:init()
	self.OSK_CHAR=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/MYLIB/KEYBOARD/tastiera.jpg")
	self.OSK_BARRA=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/MYLIB/KEYBOARD/barra.png")
	self.OSK_SEL=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/MYLIB/KEYBOARD/selected.png")
	self.animazionein=true
	self.animazioneout=false
	self.selx=0
	self.sely=0
	self.testo=""
end

function OSK:animation_in()
	self.posxiB,self.posyiB=anm:move(self.OSK_BARRA,0,self.posyiB,0,self.posyfB,0,3)
	self.posxiTC,self.posyiTC=anm:move(self.OSK_CHAR,0,self.posyiTC,0,self.posyfTC,0,8)
	if self.posyiB==self.posyfB and self.posyiTC==self.posyfTC then
		self.animazionein=false
	end
end

function OSK:animation_out()
	self.posxiB,self.posyiB=anm:move(self.OSK_BARRA,0,self.posyiB,0,-63,0,3)
	self.posxiTC,self.posyiTC=anm:move(self.OSK_CHAR,0,self.posyiTC,0,380,0,8)
	if self.posyiB==-63 and self.posyiTC==380 then
		self.animazioneout=false
	end
end

function OSK:selected()
	if buttons.right then
		if self.sely==0 then
			self.selx=self.selx+1
			if self.selx==11 then
				self.sely=1
				self.selx=0
			end
		elseif self.sely==1 then
			self.selx=self.selx+1
			if self.selx==10 then
				self.sely=2
				self.selx=0
			end
		elseif self.sely==2 then
			self.selx=self.selx+1
			if self.selx==11 then
				self.sely=3
				self.selx=0
			end
		elseif self.sely==3 then
			self.selx=self.selx+1
			if self.selx==4 then
				self.sely=0
				self.selx=0
			end
		end
	elseif buttons.left then
		if self.sely==0 then
			self.selx=self.selx-1
			if self.selx==-1 then
				self.sely=3
				self.selx=3
			end
		elseif self.sely==1 then
			self.selx=self.selx-1
			if self.selx==-1 then
				self.sely=0
				self.selx=10
			end
		elseif self.sely==2 then
			self.selx=self.selx-1
			if self.selx==-1 then
				self.sely=1
				self.selx=9
			end
		elseif self.sely==3 then
			self.selx=self.selx-1
			if self.selx==-1 then
				self.sely=2
				self.selx=10
			end
		end
	elseif buttons.cross then
		if self.sely==0 then
			if self.caratteri[self.selx+1]=="canc" then
				self.testo=""
			else
				self.testo=self.testo..self.caratteri[self.selx+1]
			end
		elseif self.sely==1 then
			self.testo=self.testo..self.caratteri[12+self.selx]
		elseif self.sely==2 then
			if self.caratteri[self.selx+22]=="MAIUSC" then
			else
				self.testo=self.testo..self.caratteri[22+self.selx]
			end
		elseif self.sely==3 then
		end
		--self.testo=self.testo..carattere[
	elseif buttons.square and self.testo~="" then
		self.testo=string.sub(self.testo,1,-2)
	end
	image.blit(self.OSK_SEL,4+43*self.selx,111+41*self.sely)
	--draw.fillrect(3+43*(self.selx),112+(41*self.sely),37,37,color.new(106,162,166,100))
end

function OSK:blit()
	self:reset()
	while true do
		screen.clear(color.new(162,162,162))
		buttons.read()
		if self.animazionein==true then
			OSK:animation_in()
		else
			if buttons.circle then
				self.animazioneout=true
				self.testo=""
			elseif buttons.start then
				self.animazioneout=true
			elseif self.animazioneout==true then
				self:animation_out()
				if self.animazioneout==false then
					return self.testo
				end
			else
				image.blit(self.OSK_BARRA,0,-9)
				image.blit(self.OSK_CHAR,0,108)
				screen.print(10,10,self.testo,1,color.new(255,255,255))
				self:selected()
			end
		end
		screen.flip()
	end
end

function string_wpixeltowletter(wpixel,size)
	return wpixel/screen.textwidth("a",size)
end