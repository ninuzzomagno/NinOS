function CMD_init()
	local cmd={
	riga={},
	NUM=0,
	PATH=kernel.PATH_INI.." > "
}

function cmd:add_cmd()
	self.NUM=self.NUM+1
	self.riga[self.NUM]={}
	if self.NUM==1 then self.riga[self.NUM].path=kernel.PATH_INI.." > " else self.riga[self.NUM].path=self.PATH end
	self.riga[self.NUM].cmd=""
	self.riga[self.NUM].ris=""
end

function cmd:ins_com()
	if buttons.start then
		self.riga[self.NUM].cmd=osk.init("","").." "
		if self.riga[self.NUM].cmd~=" " then
			local i=string.find(self.riga[self.NUM].cmd," ")
			if i~=nil then
				if string.sub(self.riga[self.NUM].cmd,1,i-1)=="cd" then
					if files.exists(string.sub(self.riga[self.NUM].path,1,-4)..string.sub(self.riga[self.NUM].cmd,i+1,-2))==true then 
						self.PATH=string.sub(self.riga[self.NUM].path,1,-4)..string.sub(self.riga[self.NUM].cmd,i+1,-2).."/ > "
						self.riga[self.NUM].ris=""
					else
						self.riga[self.NUM].ris="\nPercorso file non trovato"
					end
				elseif string.sub(self.riga[self.NUM].cmd,1,i-1)=="exit" then
					CMD=nil
					thread:destroy(7,thread:getProc())
				elseif string.sub(self.riga[self.NUM].cmd,1,i-1)==".." and path~=string.sub(kernel.PATH_INI,1,-2) then
					self.PATH=string.sub(self.riga[self.NUM].path,1,-5-string.len(files.nopath(string.sub(self.riga[self.NUM].path,1,-5))))
					if self.PATH=="ms0:" then 
						self.PATH="ms0:/ > "
					else
						self.PATH=self.PATH.." > "
					end
				elseif string.sub(self.riga[self.NUM].cmd,1,i-1)=="dir" then
					self.riga[self.NUM].ris=files.listfiles(string.sub(self.riga[self.NUM].path,1,-4))
				elseif string.sub(self.riga[self.NUM].cmd,1,i-1)=="restart" then
					if string.sub(self.riga[self.NUM].cmd,i+1,-2)=="bios" then
						bios()
					else
						os.restart()
					end
				elseif string.sub(self.riga[self.NUM].cmd,1,i-1)=="avvia" then
					if files.exists(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/"..string.sub(self.riga[self.NUM].cmd,i+1,-2))==true then
						dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/"..string.sub(self.riga[self.NUM].cmd,i+1,-2).."/main.lua")
					else
						self.riga[self.NUM].cmd=self.riga[self.NUM].cmd.."   \nProgramma non trovato"
					end
				else
					self.riga[self.NUM].cmd=self.riga[self.NUM].cmd.."   \nComando sconosciuto"
				end
			end
			cmd:add_cmd()
		end
	end
end

function cmd:blit()
	for i=1,self.NUM do
		screen.print(12,40+10*i,"["..kernel.username.."]  "..self.riga[i].path..self.riga[i].cmd,0.6,bianco,color.new(0,0,0,0),__SLEFT,444)
		
	end
end

	return cmd
end