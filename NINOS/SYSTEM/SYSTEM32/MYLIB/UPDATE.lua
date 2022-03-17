UPDATE={}

function UPDATE:controlla()
	if wlan.isconnected() then
		http.getfile("",kernel.PATH_INI.."UPDATE/verUP.ini")
		if kernel.verOS < ini.read(kernel.PATH_INI.."UPDATE/verUP.ini","OS") then
			DownloadTool:init("",kernel.PATH_INI.."UPDATE/NinOS"..ini.read(kernel.PATH_INI.."UPDATE/verUP.ini","OS")..".zip")
			DownloadTool:connectS(function()
				MSG:type("UPDATE","Download aggiornamento completato. Procedere con l'installazione?",__MBOKCANC,__MBINCONINFO)
				MSG:connect(__MBOK,function()
					UPDATE:install()
					riavvia()
				end)
			end)
			self.bi=false
		elseif kernel.verBI < ini.read(kernel.PATH_INI.."UPDATE/verUP.ini","BI") then
			DownloadTool:init("",kernel.PATH_INI.."UPDATE/NinOSBios"..ini.read(kernel.PATH_INI.."UPDATE/verUP.ini","OS")..".zip")
			DownloadTool:connectS(function()
				MSG:type("UPDATE","Download aggiornamento completato. Procedere con l'installazione?",__MBOKCANC,__MBINCONINFO)
				MSG:connect(__MBOK,function()
					UPDATE:install()
					riavvia()
				end)
			end)
			self.bi=true
		else
			MSG:type("UPDATE","Nessun aggiornamento software trovato",__MBOK,__MBICONINFO)
		end
	else
		MSG:type("Errore","La console non e' collegata a internet",__MBCANC,__MBICONERROR)
	end
end

function UPDATE:install()
	local sfondo=image.load(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/BIOS/aggiornamento.jpg")
	if not(self.bi) then 
		local ver = ini.read(kernel.PATH_INI.."UPDATE/verUP.ini","OS")
		local lunghezza=nil
		local scritta = nil
		local FILE=files.scan(kernel.PATH_INI.."UPDATE/NinOS"..ver..".zip")
		local max=table.getn(FILE)
		local i = 1
		--files.delete(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM")
		while i<=max do
			screen.clear(nero)
			image.blit(sfondo,0,0)
			screen.print(210,15,kernel.verOS.."  -->  "..ver)
			--files.extractfile("NinOS.zip",FILE[i].name,kernel.PATH_INI.."PSP/GAME/NinOS")
			if scritta==nil then scritta = FILE[i].name
			else scritta = scritta.."\n"..FILE[i].name end
			if i>15 then
				lunghezza = string.len(FILE[i-15].name)+2
				scritta = scritta.sub(scritta,lunghezza,-1)
			end
			screen.print(0,30,scritta)
			draw.fillrect(480*i/max,250,480-480*i/max,22,bianco)
			draw.fillrect(0,250,480*i/max,22,rosso)
			i=i+1
			screen.flip()
			os.delay(100)
		end
		os.delay(2000)
		os.restart()
	else	
		local ver = ini.read(kernel.PATH_INI.."UPDATE/verUP.ini","BI")
		local lunghezza=nil
		local scritta = nil
		local FILE=files.scan(kernel.PATH_INI.."UPDATE/NinOSBios"..ver..".zip")
		local max=table.getn(FILE)
		local i = 1
		--files.delete(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM")
		while i<=max do
			screen.clear(nero)
			image.blit(sfondo,0,0)
			screen.print(210,15,kernel.verBI.."  -->  "..ver)
			--files.extractfile("NinOS.zip",FILE[i].name,kernel.PATH_INI.."PSP/GAME/NinOS")
			if scritta==nil then scritta = FILE[i].name
			else scritta = scritta.."\n"..FILE[i].name end
			if i>15 then
				lunghezza = string.len(FILE[i-15].name)+2
				scritta = scritta.sub(scritta,lunghezza,-1)
			end
			screen.print(0,30,scritta)
			draw.fillrect(480*i/max,250,480-480*i/max,22,bianco)
			draw.fillrect(0,250,480*i/max,22,rosso)
			i=i+1
			screen.flip()
			os.delay(100)
		end
	end
end