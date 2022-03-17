 files.cdir(kernel.PATH_INI.."PSP/GAME/NinOS")

function PSCLEANER_AVVIO_PROG()
	local ANALIZZA = false
	local PULIZIA = false
	local COUNT=0
	local max=0
	local count=0
	local size=0
	local imgLoading = image.load("SYSTEM/SYSTEM32/ICONE/load.png")
	image.center(imgLoading)
	image.scale(imgLoading,50)
	local menu={"Download","Update","Ripristino","Configurazioni"}
	local window = image.load("SYSTEM/SYSTEM32/PROGRAM/PSCleaner/window.png")
	local btnAN = BT_new(280,220,80,20,"Analizza",0.7,color.new(127,127,127),nero,"cross",bianco,color.new(127,127,127))
	local btnPU = BT_new(380,220,80,20,"Pulizia",0.7,color.new(127,127,127),nero,"cross",bianco,color.new(127,127,127))
	btnPU:connect("clicked",function()
		MSG:type("ATTENZIONE","Procedere con la pulizia ?",__MBOKCANC,__MBICONINFO)
		MSG:connect(__MBOK,function()
			ANALIZZA = false
			PULIZIA = true
			count=0
			COUNT=0
			size=0
		end)
	end)
	btnAN:connect("clicked",function()
		ANALIZZA=true
		count=0
		size=0
		COUNT=0
		PULIZIA = false
	end)
	local CLEAN ={}
	for i=1,4 do
		CLEAN[i] = CHECKBT_new(15,80+(i-1)*40,color.new(127,127,127),rosso,menu[i],nero)
		if ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/PSCleaner/config.ini","c"..i,"true") == "true" then
			CLEAN[i].sel = true
			max=max+1
		else
			CLEAN[i].sel = false
		end
		CLEAN[i]:connect(function()
			max=0
			for i=1,4 do
				if CLEAN[i].sel then
					max=max+1
				end
			end
		end,max)
	end
	while true do
		buttons.read()
		image.blit(window,0,0)
		for i=1,4 do
			CLEAN[i]:blit()
		end
		btnAN:blit()
		btnPU:blit()
		if ANALIZZA then
			if count<4 then 
				screen.print(180,40,"Analizzando....",0.7,nero)
				image.rotate(imgLoading,5*count)	
				image.blit(imgLoading,160,45)
			else screen.print(180,40,"Completato",0.7,nero) end
			screen.print(160,120,"Spazio recuperabile : "..(size/1000).." kb",0.7,nero)
			prbar(160,100,200,10,COUNT,max,verde,bianco,false)
			if count == 0 then
				if CLEAN[1].sel then
					screen.print(160,80,"Path : "..kernel.PATH_INI.."DOWNLOAD",0.7,nero)
					size = files.size(kernel.PATH_INI.."DOWNLOAD")
					COUNT=COUNT+1
				end
				count=count+1
			elseif count == 1 then
				if CLEAN[2].sel then
					screen.print(160,80,"Path : "..kernel.PATH_INI.."UPDATE",0.7,nero)
					size = size + files.size(kernel.PATH_INI.."UPDATE")
					COUNT=COUNT+1
				end
				count=count+1
			elseif count == 2 then
				if CLEAN[3].sel then
					screen.print(160,80,"Path : "..kernel.PATH_INI.."Ripristino",0.7,nero)
					size = size + files.size(kernel.PATH_INI.."Ripristino")
					COUNT = COUNT+1
				end
				count=count+1
			elseif count ==3 then
				if CLEAN[4].sel then
					screen.print(160,80,"Path : "..kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF",0.7,nero)
					size = size + files.size(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF")
					COUNT = COUNT+1
				end
				count=count+1
			end
		elseif PULIZIA then
			if count<4 then 
				screen.print(180,40,"Pulendo....",0.7,nero)
				image.rotate(imgLoading,5*count)	
				image.blit(imgLoading,160,45)
			else screen.print(180,40,"Completato",0.7,nero) end
			screen.print(160,120,"Spazio recuperato : "..(size/1000).." kb",0.7,nero)
			prbar(160,100,200,10,COUNT,max,verde,bianco,false)
			if count == 0 then
				if CLEAN[1].sel then
					screen.print(160,80,"Path : "..kernel.PATH_INI.."DOWNLOAD",0.7,nero)
					size = files.size(kernel.PATH_INI.."DOWNLOAD")
					files.delete(kernel.PATH_INI.."DOWNLOAD")
					COUNT=COUNT+1
				end
				count=count+1
			elseif count == 1 then
				if CLEAN[2].sel then 
					screen.print(160,80,"Path : "..kernel.PATH_INI.."UPDATE",0.7,nero)
					size = size + files.size(kernel.PATH_INI.."UPDATE")
					files.delete(kernel.PATH_INI.."UPDATE")
					COUNT=COUNT+1
				end
				count=count+1
			elseif count == 2 then
				if CLEAN[3].sel then
					screen.print(160,80,"Path : "..kernel.PATH_INI.."Ripristino",0.7,nero)
					size = size + files.size(kernel.PATH_INI.."Ripristino")
					files.delete(kernel.PATH_INI.."Ripristino")
					COUNT=COUNT+1
				end
				count=count+1
			elseif count == 3 then
				if CLEAN[4].sel then
					screen.print(160,80,"Path : "..kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF",0.7,nero)
					size = size + files.size(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF")
					--files.delete(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF")
					COUNT=COUNT+1
				end
				count=count+1
			end
		end
		PROG_ESCI()
		startbar:blit()
		mouse:blit()
		screen.flip()
	end
end
 
thread:new(92,image.load("SYSTEM/SYSTEM32/PROGRAM/PSCleaner/icona.png"),PSCLEANER_AVVIO_PROG)