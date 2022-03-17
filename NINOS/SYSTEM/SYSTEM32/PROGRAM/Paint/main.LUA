files.cdir(kernel.PATH_INI.."PSP/GAME/NinOS")

function PAINT_AVVIO_PROG()
local finestra=image.load("SYSTEM/SYSTEM32/PROGRAM/Paint/paint.png")
local nome=nil
local img=nil

if paintPath~=nil then
	nome=files.nopath(paintshop_path)
	img=image.load(paintPath)
else	
	img=image.new(464,208,bianco)
end

image.center(img) 

local text=nil 
local PAINT_POS_X=240
local PAINT_POS_Y=143

paintPath=nil

local menu=MENU(8,22,color.new(183,185,182),color.new(0,0,0,70),nero,nero,0.6,2)

menu:add("File")
menu:add("Immagine")
menu:add("Filtri")
menu:submenu(1)
menu:add_s("Nuovo",1)
menu:add_s("Apri",1)
menu:add_s("Salva",1)
menu:add_s("Salva con nome",1)
menu:submenu(2)
menu:add_s("Ritaglia",2)
menu:add_s("Scala",2)
menu:add_s("Ridimensiona",2)
menu:add_s("Rovescia H",2)
menu:add_s("Rovescia V",2)
menu:submenu(3)
menu:add_s("Grigio",3)
menu:add_s("Old",3)
menu:add_s("Seppia",3)
menu:add_s("Inverti",3)
menu:connect(1,1,function()
				img=image.new(474,217,bianco)
				image.center(img)
			end)
menu:connect(1,2,function() 
			path=FILE_DIALOG(__FDOPFILE,"imgA") 
			if path~=nil then 
				img=image.load(path) 
				image.center(img) 
				nome=files.nopath(path)
			else img=nil nome=nil end
			end)
menu:connect(1,3,function()
			image.save(img,(FILE_DIALOG(__FDSELDIR) or kernel.PATH_INI).."/"..nome..".png") 
			end)
menu:connect(1,4,function()
			nome=osk.init("","")
			image.save(img,(FILE_DIALOG(__FDSELDIR,"imgA") or kernel.PATH_INI).."/"..nome..".png")
			end)
menu:connect(2,2,function()
			img=IMG_SCALE(img,osk.init("Percentuale","") or 1)
			image.center(img) 
			end)
menu:connect(2,3,function()
			img=IMG_RESIZE(img,osk.init("Width",""),osk.init("Lenght",""))
			image.center(img) 
			end)
menu:connect(2,4,function()
			img=PAINT_FLIP_H(img)
			image.center(img) 
			end)
menu:connect(2,5,function()
			img=PAINT_FLIP_V(img)
			image.center(img) 
			end)
menu:connect(3,1,function()
			image.fxgrey(img)
			end)
menu:connect(3,2,function()
			image.fxold(img) 
			end)
menu:connect(3,3,function()
			image.fxsepia(img) 
			end)
menu:connect(3,4,function()
			image.fxinvert(img) 
			end)



	while true do
		screen.clear(color.new(38,38,38))
		image.blit(finestra,0,0)
		buttons.read()

		if img ~= nil then image.blit(img,PAINT_POS_X,PAINT_POS_Y) end

		
		if nome ~= nil then screen.print(100,5,nome,0.7) end
	
		PROG_ESCI()
		menu:blit()
		startbar:blit()
		mouse:blit()
		screen.flip()
	end
end

if thread:new(12,image.load("SYSTEM/SYSTEM32/PROGRAM/Paint/icona.png"),PAINT_AVVIO_PROG)==false then bsod("Impossibile avviare thread per il programma") end