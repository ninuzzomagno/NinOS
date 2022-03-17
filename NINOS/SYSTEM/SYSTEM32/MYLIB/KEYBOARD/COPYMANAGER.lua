COPY_MAN={
	transferProcess=0
}

function COPY_MAN:init()
	self.TransferPROC={}
	self.CHIUDI=BT_IMG_new(450,2,thread.imgKernel,{x=0,y=0,w=20,h=20},{x=20,y=0,w=20,h=20})
	self.RIDUCI=BT_IMG_new(425,2,thread.imgKernel,{x=40,y=0,w=20,h=20},{x=60,y=0,w=20,h=20})

	self.CHIUDI:connect("clicked",function()
	end)

	self.RIDUCI:connect("clicked",function()
	end)

	self.iconBTN=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/iconPlayPausaAnnulla.png")
	self.icon=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/trasferimento.png")
	thread:new(10,self.image,COPY_MAN.main)

	function COPY_MAN:BTN_PLAY_PAUSE()

	end

	function COPY_MAN:BTN_ANNULLA()
		if COPY_MAN.TransferPROC[val].m==true then
			COPY_MAN.TransferPROC[val].delete=true
		else
			
		end
	end

end

function COPY_MAN:new(pathI,pathO,move)    --move=true sposta move=false copia
	if self.transferProcess>0 and self.err(fsize(pathI))==0 then 
		self.add(pathI,pathO,move)
		local bool,ris=thread:exists(10,1,1)
		if bool==false then
			bool,ris=thread:exists(10,1,2)
			thread.lista[2][ris].new=true
		else
			thread.lista[1][ris].new=true
		end
	elseif self:err(fsize(pathI))==0 then
		self:init()
	end
end

function COPY_MAN:err(size)
	if self.TransferPROC>3 then
		MSG_sys:type("Attenzione","Ci sono troppi processi di spostamento. Attendere..",__MBOK,__MBICONINFO)
		return 1
	elseif MS:used()+size>MS:max() then
		MSG_sys:type("Errore","Memoria insufficiente",__MBCANC,__MBICONERROR)
		return 1
	end 
	return 0
end

function COPY_MAN:main()
	while true do
		screen.clear(bianco)
		buttons.read()

		CHIUDI:blit()
		RIDUCI:blit()

		for i=1,self.transferProcess do
			if self:copy(i)==1 then
				if self.transferProcess>1 then 
					for y=1 self.transferProcess do
						self.TransferPROC[i].buffer=1024*24/(self.transferProcess-1)
					end
				end
				table.remove(self.TransferPROC,i)
				self.transferProcess-=1
				break
			end
		end

		startbar:blit()
		mouse:blit()
		screen.flip()

		if self.transferProcess==0 then break end

	end
end

function COPY_MAN:add(pathI,pathO,move)		--move=true sposta move=false copia

	self.transferProcess=self.transferProcess+1
	self.TransferPROC[self.transferProcess]={
		pI=pathI,
		pO=pathO,
		m=move,
		data=0,
		buffer=1024*24/self.transferProcess,
		scritti=0,
		PLAY_BTN=BT_IMG_new(375,20+50*self.transferProcess,self.iconBTN,{x=0,y=0,w=25,h=25},{x=75,y=0,w=25,h=25}),
		ANNULLA_BTN=BT_IMG_new(420,20+50*self.transferProcess,self.iconBTN,{x=100,y=0,w=25,h=25},{x=125,y=0,w=25,h=25})
	}

	self.TransferPROC[self.transferProcess].PLAY_BTN:connect("clicked",self.BTN_PLAY_PAUSE)
	self.TransferPROC[self.transferProcess].ANNULLA_BTN:connect("clicked",self.BTN_ANNULLA)

	self.TransferPROC[self.transferProcess].OLD=io.open(self.TransferPROC[self.transferProcess].pathI,"r")
	self.TransferPROC[self.transferProcess].NEW=io.open(self.TransferPROC[self.transferProcess].pathO.."/"..files.nopath(path),"w")

	procBack:new("copyMan"..self.transferProcess,false,self.copyB)

end

function COPY_MAN:copy(indexFile)
	self.TransferPROC[indexFile].data=self.TransferPROC[indexFile].OLD:read(self.TransferPROC[indexFile].buffer)
	if self.TransferPROC[indexFile].data==nil then
		self.TransferPROC[indexFile].NEW:close()
		self.TransferPROC[indexFile].OLD:close()
		if self.TransferPROC[indexFile].move==true then
			files.delete(self.TransferPROC[indexFile].pI)
		end
		return 1
	end
	self.TransferPROC[indexFile].NEW:write(self.TransferPROC[indexFile].data)
	self.TransferPROC[indexFile].scritti+=self.TransferPROC[indexFile].data
	return 0
end