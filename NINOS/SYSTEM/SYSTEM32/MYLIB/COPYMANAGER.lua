COPY_MAN={
	transferProcess=0
}

function COPY_MAN:new(pathI,pathO,move)    --move=true sposta move=false copia
	if self.transferProcess>0 and self:err(fsize(pathI))==0 then 
		self:add(pathI,pathO,move)
		local bool,ris=thread:exists(10,1,1)
		if bool==false then
			bool,ris=thread:exists(10,1,2)
			thread.lista[2][ris].new=true
		else
			thread.lista[1][ris].new=true
		end
	elseif self:err(fsize(pathI))==0 then
		self:init(pathI,pathO,move)
	end
end

function COPY_MAN:err(size)
	if self.transferProcess>2 then
		MSG_sys:type("Attenzione","Ci sono troppi processi di spostamento. Attendere..",__MBOK,__MBICONINFO)
		return 1
	elseif MS:used()+size>MS:max() then
		MSG_sys:type("Errore","Memoria insufficiente",__MBCANC,__MBICONERROR)
		return 1
	end 
	return 0
end
 
function COPY_MAN:init(pathI,pathO,move)
	self.TransferPROC={}

	self.CHIUDI=BT_IMG_new(450,2,thread.imgKernel,{x=0,y=0,w=20,h=20},{x=20,y=0,w=20,h=20})
	self.RIDUCI=BT_IMG_new(425,2,thread.imgKernel,{x=40,y=0,w=20,h=20},{x=60,y=0,w=20,h=20})

	self.CHIUDI:connect("clicked",function()
		MSG_sys:type("Attenzione","Ci sono spostamenti in corso. Annullarli?",__MBOKCANC,__MBICONINFO)
	end)

	self.RIDUCI:connect("clicked",function()
		--avvia processi background
		thread:pause(10,1)
	end)

	self.iconBTN=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/iconPlayPausaAnnulla.png")
	self.icon=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/trasferimento.png")
	

	function COPY_MAN:BTN_PLAY_PAUSE()
		for i=1,self.transferProcess do
			if self.TransferPROC[i].PLAY_BTN:hover() then 
				if self.TransferPROC[i].pausa==false then 
					self.TransferPROC[i].pausa=true 
					if self.transferProcess>1 then 
						local pause=0
						for z=1,self.transferProcess do
							if self.TransferPROC[z].pausa==true then pause+=1 end
						end
						for y=1,self.transferProcess do
							self.TransferPROC[y].buffer=1024*90/(self.transferProcess-pause)
						end
					end
				else 
					self.TransferPROC[i].pausa=false 
					for y=1,self.transferProcess do
						self.TransferPROC[y].buffer=1024*90/self.transferProcess
					end
				end
				return
			end
		end
	end

	function COPY_MAN:BTN_ANNULLA()
		for i=1,self.transferProcess do
			if self.TransferPROC[i].ANNULLA_BTN:hover() then 
				self.TransferPROC[i].NEW:close()
				self.TransferPROC[i].OLD:close()
				if self.TransferPROC[i].move==true then files.delete(self.TransferPROC[i].pI) end
				table.remove(self.TransferPROC,i)
				return
			end
		end
	end


	self:add(pathI,pathO,move)

	dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/COPY_MANAGER_PROGRAM.lua")


end

function COPY_MAN:add(pathI,pathO,move)		--move=true sposta move=false copia

	self.transferProcess+=1
	self.TransferPROC[self.transferProcess]={}
	self.TransferPROC[self.transferProcess].pI=pathI
	self.TransferPROC[self.transferProcess].pO=pathO
	self.TransferPROC[self.transferProcess].move=move
	self.TransferPROC[self.transferProcess].data=0
	self.TransferPROC[self.transferProcess].pausa=false

	local pause=0
	for i=1,self.transferProcess-1 do
		if self.TransferPROC[i].pausa==true then pause+=1 end
	end

	for i=1,self.transferProcess do
		self.TransferPROC[i].buffer=1024*90/(self.transferProcess-pause)
	end

	self.TransferPROC[self.transferProcess].size=fsize(pathI)
	self.TransferPROC[self.transferProcess].scritti=0
	self.TransferPROC[self.transferProcess].PLAY_BTN=BT_IMG_new(375,37+70*(self.transferProcess-1),self.iconBTN,{x=0,y=0,w=25,h=25},{x=75,y=0,w=25,h=25})
	self.TransferPROC[self.transferProcess].ANNULLA_BTN=BT_IMG_new(420,37+70*(self.transferProcess-1),self.iconBTN,{x=100,y=0,w=25,h=25},{x=125,y=0,w=25,h=25})

	self.TransferPROC[self.transferProcess].PLAY_BTN:connect("clicked",self.BTN_PLAY_PAUSE)
	self.TransferPROC[self.transferProcess].ANNULLA_BTN:connect("clicked",self.BTN_ANNULLA)

	self.TransferPROC[self.transferProcess].OLD=io.open(pathI,"r")
	self.TransferPROC[self.transferProcess].NEW=io.open(pathO.."/"..files.nopath(pathI),"w")

	--procBack:new("copyMan"..self.transferProcess,false,self.copyB)

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
	self.TransferPROC[indexFile].scritti+=self.TransferPROC[indexFile].buffer
	return 0
end