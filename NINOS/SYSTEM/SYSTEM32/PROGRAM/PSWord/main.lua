 files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS")

 function PSWORD_OPEN(file)
	psword_path_file=nil
	local textbox=TXTBOX_MULTI(6,45,468,202,nero,bianco,color.new(22,68,128),0.6)
	if file~=nil then textbox:connect_file(FILE(file)) end
	local menu=MH_new(5,25,color.new(42,88,148),color.new(22,68,128),bianco,bianco,0.7)
	menu:add("Apri")
	--menu:add("Salva")
	menu:connect(1,function()
		textbox:connect_file(FILE(FILE_DIALOG(__FDOPFILE,"txtA")))
	end)
	--menu:connect(2,function()
	--end)

	local s_word=image.load("SYSTEM/SYSTEM32/PROGRAM/PSWORD/PsWord2.jpg")
	while true do
		buttons.read()
		image.blit(s_word,0,0)
		screen.print(100,10,file or "",0.7,bianco)
		startbar:blit()
		if mouse:getx()>=0 and mouse:getx()<=40 and mouse:gety()>=0 and mouse:gety()<=30 then 
			draw.fillrect(0,0,25,25,color.new(0,0,139,100))
			if buttons.cross then return end
		end
		PROG_ESCI()
		menu:blit()
		textbox:blit()
		mouse:blit()
		screen.flip()
	end
 end

function PSWORD()
	if files.exists(kernel.PATH_INI.."WORD")==false then files.mkdir(kernel.PATH_INI.."WORD") end
	local MENU=MV_new(0,75,152,0,color.new(0,0,0,0),color.new(0,0,139,100),0.7,bianco,bianco,false,true,10)
	MENU:add("Nuovo")
	MENU:add("Apri")
	MENU:add("Esci")

	MENU:connect(1,function()
		PSWORD_OPEN()
		MENU.sel=0
	end)
	MENU:connect(2,function()
		PSWORD_OPEN(FILE_DIALOG(__FDOPFILE,"txtA"))
		MENU.sel=0
	end)
	MENU:connect(3,function()
		thread:delete(6,thread:getProc())
	end)

	local LISTA=lista_new(kernel.PATH_INI.."WORD",100,-20,420,250,60,false,nero)
	local h_word=image.load("SYSTEM/SYSTEM32/PROGRAM/PSWORD/PsWord.jpg")

	if psword_path_file~=nil then
		PSWORD_OPEN(psword_path_file)
	else
		while true do
			buttons.read()
			image.blit(h_word,0,0)
			startbar:blit()
			MENU:blit()
			LISTA:blit()
			if LISTA.SEL~=0 then 
				PSWORD_OPEN(LISTA.lista[LISTA.SEL].path)
				LISTA.SEL=0
			end
			mouse:blit()
			screen.flip()
		end
	end
end
--PSWORD()
thread:new(6,image.load("SYSTEM/SYSTEM32/ICONE/psword.png"),PSWORD)
