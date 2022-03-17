 files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS")

function PSPrar()
	local sfondo=image.load("SYSTEM/SYSTEM32/PROGRAM/PSPrar/sfondo.png")
	local m=MENU(5,25,color.new(180,180,180),color.new(161,161,161),nero,nero,0.6,2)
	local file=rarPathFile or nil
	local tab=nil
	if file~=nil then tab=files.scan(file)
	else tab=nil end
	local table=NEW_table(6,45,469,202,bianco,color.new(203,203,203),0.7,0.6,nero,nero,color.new(161,161,161),tab,12)
	table:addCol("Nome","name")
	table:addCol("Dimensione","size")
	m:add("File")
	m:add("Archivio")
	m:submenu(1)
	m:submenu(2)
	m:add_s("Apri file",1)
	m:add_s("Chiudi file",1)
	m:connect(1,1,function()
		file=FILE_DIALOG(__FDOPFILE,"imgA")
		if file~=nil then 
			tab=files.scan(file)
			table=NEW_table(6,45,469,202,bianco,color.new(203,203,203),0.7,0.6,nero,nero,color.new(161,161,161),tab,12)
			table:addCol("Nome","name")
			table:addCol("Dimensione","size")
		end
	end)
	--m:connect(1,2,function()


	--end)
	m:add_s("Estrai",2)
	m:connect(2,1,function()
		
	end)
	m:add_s("Estrai in..",2)
	m:connect(2,2,function()
		local path=FILE_DIALOG(__FDSELDIR,"imgA")
		if path~=nil then  

		end
	end)
	while true do
		buttons.read()
		image.blit(sfondo,0,0)
		table:blit()
		m:blit()
		PROG_ESCI()
		startbar:blit()
		mouse:blit()
		screen.flip()
	end
end
--PSPrar()
if thread:new(20,image.load("SYSTEM/SYSTEM32/PROGRAM/PSPrar/icona.png"),PSPrar)==false then bsod("Impossibile avviare thread") end
