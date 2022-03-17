 local Yi_PLAYER=247

thread={}

function thread:init()
	self.proc_att={}
	self.proc_att[1]=0
	self.lista={}
	self.lista[1]={}
	if MAX_DESKTOP~=nil or MAX_DESKTOP==2 then
		self.lista[2]={}
		self.proc_att[2]=0
	end
	self.imgKernel=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/iconControlProg.png")
	kernel.CHIUDI=BT_IMG_new(450,2,self.imgKernel,{x=0,y=0,w=20,h=20},{x=20,y=0,w=20,h=20})
	kernel.RIDUCI=BT_IMG_new(425,2,self.imgKernel,{x=40,y=0,w=20,h=20},{x=60,y=0,w=20,h=20})
	kernel.CHIUDI:connect("clicked",function() thread:destroy(thread:getId(),thread:getProc()) end)
	kernel.RIDUCI:connect("clicked",function() thread:pause(thread:getId(),thread:getProc()) end)
end

function thread:new(id,img,func)
	image.resize(img,16,16)
	self.proc_att[DESKTOP]=self.proc_att[DESKTOP]+1
	self.lista[DESKTOP][self.proc_att[DESKTOP]]={}
	self.lista[DESKTOP][self.proc_att[DESKTOP]].img=img
	self.lista[DESKTOP][self.proc_att[DESKTOP]].del=false
	self.lista[DESKTOP][self.proc_att[DESKTOP]].new=true
	self.lista[DESKTOP][self.proc_att[DESKTOP]].id=id
	self.lista[DESKTOP][self.proc_att[DESKTOP]].proc=1
	for i=1,self.proc_att[DESKTOP]-1 do
		if self.lista[DESKTOP][i].id==id then
			self.lista[DESKTOP][self.proc_att[DESKTOP]].proc=self.lista[DESKTOP][self.proc_att[DESKTOP]].proc+1
		end
	end
	self.lista[DESKTOP][self.proc_att[DESKTOP]].fun=coroutine.create(func)
	if self.lista[DESKTOP][self.proc_att[DESKTOP]].fun==nil then return false end
	return true,self.lista[DESKTOP][self.proc_att[DESKTOP]].proc
end

function thread:getId()
	for i=1,self.proc_att[DESKTOP] do
		if self.lista[DESKTOP][i].fun==coroutine.running() then
			return self.lista[DESKTOP][i].id
		end
	end
end

function thread:getProc(desk)
	local desktop=DESKTOP
	if desk~=nil and desk<=MAX_DESKTOP then desktop=desk end 
	for i=1,self.proc_att[desktop] do
		if self.lista[desktop][i].fun==coroutine.running() then
			return self.lista[desktop][i].proc
		end
	end
end

function thread:pause(ID,PROC)
	for i=1,self.proc_att[DESKTOP] do
		if self.lista[DESKTOP][i].id==ID and self.lista[DESKTOP][i].proc==PROC then
			self.lista[DESKTOP][i].screen=IMG_RIT_SCA(screen.toimage(),4,0,0,480,272)
			coroutine.yield(self.lista[DESKTOP][i].fun)
			return
		end
	end
end

function thread:resume(ID,PROC,desk)
	local desktop=DESKTOP
	if desk~=nil and desk<=MAX_DESKTOP then desktop=desk end 
	for i=1,self.proc_att[desktop] do
		if self.lista[desktop][i].id==ID and self.lista[desktop][i].proc==PROC then
			coroutine.resume(self.lista[desktop][i].fun)
			return
		end
	end
end

function thread:destroy(ID,PROC)
	for i=1,self.proc_att[DESKTOP] do
		if self.lista[DESKTOP][i].id==ID and self.lista[DESKTOP][i].proc==PROC then
			self.lista[DESKTOP][i].del=true 
			coroutine.yield(self.lista[DESKTOP][i].fun)
			return
		end
	end
end

function thread:res_proc(ID)
	local PROC=1
	for i=1,self.proc_att[DESKTOP] do
		if self.lista[DESKTOP][i].id==ID then
			self.lista[DESKTOP][i].proc=PROC
			PROC=PROC+1
		end
	end
end

function thread:blit()
	if self.proc_att[DESKTOP]~=0 then
		for i=1,self.proc_att[DESKTOP] do
			if self.lista[DESKTOP][i].del==true then
				self.ID_del=self.lista[DESKTOP][i].id
				self.RESUME=nil
				table.remove(self.lista[DESKTOP],i)
				self.proc_att[DESKTOP]=self.proc_att[DESKTOP]-1
				self:res_proc(self.ID_del)
				self.ID_del=nil
				return
			end
			if self.lista[DESKTOP][i]~=nil then
				if self.lista[DESKTOP][i].new==true then
					self.lista[DESKTOP][i].new=false
					self:resume(self.lista[DESKTOP][i].id,self.lista[DESKTOP][i].proc)
					return
				end
				if (mouse:getx()>(75+(i-1)*36)+(startbar.maxListApp*36) and mouse:getx()< ((75+(i-1)*36)+(startbar.maxListApp*36))+36 and mouse:gety()>Yi_PLAYER and mouse:gety()<272) then
					draw.fillrect((75+(i-1)*36)+(startbar.maxListApp*36),247,36,25,color.new(80,80,80))
					if self.lista[DESKTOP][i].screen~=nil and coroutine.running()~=self.lista[DESKTOP][i].fun then
						draw.fillrect((30+(i-1)*36)+(startbar.maxListApp*36),173,126,74,CurrentTheme.systemColor3)
						image.blit(self.lista[DESKTOP][i].screen,(33+(i-1)*36)+(startbar.maxListApp*36),176)
					end
					if buttons.cross then
						if coroutine.status(self.lista[DESKTOP][i].fun)=="suspended" or coroutine.status(self.lista[DESKTOP][i].fun)=="normal" then
							self.RESUME=self.lista[DESKTOP][i].fun
							self:pause(self:getId(),self:getProc())
							return
						elseif coroutine.status(self.lista[DESKTOP][i].fun)=="running" then
							self.RESUME=nil
							self:pause(self.lista[DESKTOP][i].id,self.lista[DESKTOP][i].proc)
							return
						end
					end
				end
				if self.lista[DESKTOP][i].fun==self.RESUME then
					self.RESUME=nil
					self:resume(self.lista[DESKTOP][i].id,self.lista[DESKTOP][i].proc)
					return
				elseif coroutine.running() == self.lista[DESKTOP][i].fun then 
					draw.fillrect((75+(i-1)*36)+(36*startbar.maxListApp),247,36,25,color.new(113,122,138))
				end
				image.blit(self.lista[DESKTOP][i].img,(85+(i-1)*36)+(startbar.maxListApp*36),251)
				draw.fillrect((75+(i-1)*36)+(startbar.maxListApp*36),270,36,2,CurrentTheme.systemColor2)
				if coroutine.status(self.lista[DESKTOP][i].fun)=="dead" then 	
					self.lista[DESKTOP][i].del=true
					MSG_sys:type("NinOS","Il programma e' stato arrestato a causa di un errore",__MBCANC,__MBICONERROR)
				end
			end
		end
	end
end

function thread:exists(ID,PROC,desk)
	local desktop=DESKTOP
	if desk~=nil and desk<=MAX_DESKTOP then desktop=desk end 
	for i=1,self.proc_att[desktop] do
		if PROC==nil and self.lista[desktop][i].id==ID then
			return true,i
		elseif PROC~=nil and self.lista[desktop][i].proc==PROC and self.lista[desktop][i].id==ID then
			return true,i
		end
	end
	return false
end

function thread:closeAll()
	local desk=DESKTOP
	for j=1,desk do
		for i=1,self.proc_att[j] do
			self.lista[j][i].del=true 
			coroutine.yield(self.lista[j][i].fun)
		end
	end
end