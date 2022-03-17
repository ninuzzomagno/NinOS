function POPUP_new()
	local POPUP={
		show=false,
		initMENU=false,
		elem=nil,
		PATH=nil
	}

	function POPUP:add_popup(bk_colore,bk_coloreh,txt_c,txt_ch,lista)
		self.menu=MV_new(0,0,0,0,bk_colore,bk_coloreh,0.6,txt_c,txt_ch,true,true,2)
		self.elem=lista
	end

	function POPUP:addTxtConnect(txt,f)
		self.menu:add(txt)
		self.menu:connect(self.menu.MX_m,f)
	end

	function POPUP:blit()
		if self.triangle then self.show=true self.menu.x=mouse:getx() self.menu.y=mouse:gety() end
		if self.show then self.menu:blit() end
	end

	return POPUP
end

function SYS_POPUP_new(bk_colore,bk_coloreh,txt_c,txt_ch,def_fun)
	local SYS_POPUP={
		show=false,
		initMENU=false,
		elem=nil,
		PATH=nil,
		menu_file=MV_new(0,0,0,0,nero,rosso,0.6,bianco,nero,true,true,2),
		menu_dir=MV_new(0,0,0,0,nero,rosso,0.6,bianco,nero,true,true,2),
		menu=MV_new(0,0,0,0,nero,rosso,0.6,bianco,nero,true,true,2)
	}

	SYS_POPUP.menu_file.bk_col=bk_colore
	SYS_POPUP.menu_file.bk_colh=bk_coloreh
	SYS_POPUP.menu_file.text_c=txt_c
	SYS_POPUP.menu_file.text_ch=txt_ch

	SYS_POPUP.menu_dir.bk_col=bk_colore
	SYS_POPUP.menu_dir.bk_colh=bk_coloreh
	SYS_POPUP.menu_dir.text_c=txt_c
	SYS_POPUP.menu_dir.text_ch=txt_ch

	SYS_POPUP.menu.bk_col=bk_colore
	SYS_POPUP.menu.bk_colh=bk_coloreh
	SYS_POPUP.menu.text_c=txt_c
	SYS_POPUP.menu.text_ch=txt_ch

	if def_fun then
		SYS_POPUP.menu_file:add("Apri")
		SYS_POPUP.menu_file:connect(1,function()
			Widget:focusOFF()
			if SYS_POPUP.elem.ext=="ini" or SYS_POPUP.elem.ext=="txt" or SYS_POPUP.elem.ext=="lua" or SYS_POPUP.elem.ext=="htm" or SYS_POPUP.elem.ext=="html" or  SYS_POPUP.elem.ext=="conf" then
				psword_path_file=SYS_POPUP.elem.path
				dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/PSWORD/main.lua")
			elseif SYS_POPUP.elem.ext=="jpg" or SYS_POPUP.elem.ext=="bmp" or SYS_POPUP.elem.ext=="gif" or SYS_POPUP.elem.ext=="png" then
				paintshop_path=SYS_POPUP.elem.path
				dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/PAINTSHOP/main.lua")
			elseif SYS_POPUP.elem.ext=="zip" or SYS_POPUP.elem.ext=="rar" then
				INSTALLWIZARD:init(FILE(SYS_POPUP.elem.path))
			end
		end)
		
	SYS_POPUP.menu_file:add("Sposta")
		SYS_POPUP.menu_file:connect(2,function()
			Widget:focusOFF()
			path_copy_source=SYS_POPUP.elem.path
			path_move=true
		end)

	SYS_POPUP.menu_file:add("Copia")
		SYS_POPUP.menu_file:connect(3,function()
			Widget:focusOFF()
			path_copy_source=SYS_POPUP.elem.path
			path_move=false
		end)

	SYS_POPUP.menu_file:add("Rinomina")
		SYS_POPUP.menu_file:connect(4,function()
			Widget:focusOFF()
			if files.rename(SYS_POPUP.elem.path,osk.init("",""))==0 then MSG:type("Errore","Impossibile rinominare il file") end
		end)

	SYS_POPUP.menu_file:add("Elimina")
		SYS_POPUP.menu_file:connect(5,function()
			Widget:focusOFF()
			files.delete(SYS_POPUP.elem.path)
		end)

	SYS_POPUP.menu_file:add("Proprieta'")

	SYS_POPUP.menu_dir:add("cartella")
		SYS_POPUP.menu_dir:connect(1,function()
			Widget:focusOFF()
			explorer_path=SYS_POPUP.elem.path
			dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/EXPLORER/main.lua")
		end)
	SYS_POPUP.menu_dir:add("Sposta")
	SYS_POPUP.menu_dir:add("Copia")

	SYS_POPUP.menu_dir:add("Rinomina")
		SYS_POPUP.menu_dir:connect(4,function()
			Widget:focusOFF()
			if files.rename(SYS_POPUP.elem.path,osk.init("",""))==0 then MSG:type("Errore","Impossibile rinominare la cartella") end
		end)

	SYS_POPUP.menu_dir:add("Elimina")
		SYS_POPUP.menu_dir:connect(5,function()
			Widget:focusOFF()
			files.delete(SYS_POPUP.elem.path)
		end)

	SYS_POPUP.menu_dir:add("Proprieta'")

	SYS_POPUP.menu:add("Crea cartella") 
		SYS_POPUP.menu:connect(1,function() 
			Widget:focusOFF()
			local name=osk.init("","")
			if name~=nil then
				files.mkdir(SYS_POPUP.path.."/"..name)
			end
		end)
	SYS_POPUP.menu:add("Crea file")
		SYS_POPUP.menu:connect(2,function()
			Widget:focusOFF()
			local name=osk.init("","")
			if name~=nil then
				local file=io.open(SYS_POPUP.path.."/"..name)
				file:close()
			end
		end)
	SYS_POPUP.menu:add("Incolla")
		SYS_POPUP.menu:connect(3,function()
			Widget:focusOFF()
			path_copy_des=SYS_POPUP.path
			COPY_MAN:new(path_copy_source,path_copy_des,path_move)
			path_copy_des=nil
			path_copy_source=nil
			path_move=nil
		end)
	else
		function SYS_POPUP:add(testo)
			self.menu:add(testo)
		end

		function SYS_POPUP:connect(id,f)
			SYS_POPUP.menu:connect(id,f)
		end
	end

function SYS_POPUP:blit()
	if buttons.triangle then 
		Widget:focusON()
		self.initMENU=false
		self.show=true
	elseif buttons.circle then self.elem=nil self.show=false Widget:focusOFF() end
	if self.show==true then
		if self.elem~=nil then
			if self.elem.directory==true then
				if self.initMENU==false then
					self.initMENU=true
					if mouse:getx()+self.menu_dir.w>480 then
						self.menu_dir.x=480-self.menu_dir.w
					else
						self.menu_dir.x=mouse:getx()
					end
					if mouse:gety()+self.menu_dir.h >247 then
						self.menu_dir.y=247-self.menu_dir.h
					else
						self.menu_dir.y=mouse:gety()
					end
				end
				self.menu_dir:blit()
			else
				if self.initMENU==false then
					self.initMENU=true
					if mouse:getx()+self.menu_file.w>480 then
						self.menu_file.x=480-self.menu_file.w
					else
						self.menu_file.x=mouse:getx()
					end
					if mouse:gety()+self.menu_file.h >247 then
						self.menu_file.y=247-self.menu_file.h
					else
						self.menu_file.y=mouse:gety()
					end
				end
				self.menu_file:blit()
			end
		else
			if self.initMENU==false then
					self.initMENU=true
					if mouse:getx()+self.menu.w>480 then
						self.menu.x=480-self.menu.w
					else
						self.menu.x=mouse:getx()
					end
					if mouse:gety()+self.menu.h >247 then
						self.menu.y=247-self.menu.h
					else
						self.menu.y=mouse:gety()
					end
				end
				self.menu:blit()
			self.menu:blit()
		end
		if self.menu.sel~=0 or self.menu_dir.sel~=0 or self.menu_file.sel~=0  then 
			self.show=false 
			self.menu.sel=0 
			self.menu_dir.sel=0
			self.menu_file.sel=0
			self.initMENU=false
			self.elem=nil
			Widget:focusOFF()
		end
	end
end
	return SYS_POPUP
end