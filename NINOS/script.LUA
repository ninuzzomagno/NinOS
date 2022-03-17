require("SYSTEM.SYSTEM32.MYLIB.KERNEL")
buttons.homepopup(0)
kernel:init()

nero=color.new(0,0,0)
bianco=color.new(255,255,255)
rosso=color.new(255,0,0)
verde=color.new(0,255,0)

files.cdir(kernel.PATH_INI.."/PSP/GAME/NINOS")

local ok=true
local OK=true
local start=true
local i=1
local a=180
local X=43.63
local MESS="Premere X avviare il sistema"
local bios1=image.load("SYSTEM/BIOS/biosN.jpg")
local bios2=image.load("SYSTEM/BIOS/biosN2.jpg")
local bios3=image.load("SYSTEM/BIOS/biosN3.jpg")

function boolTOint(val)
	if val==true then return 0
	else return 1 end
end


function bsod(errore)
    os.delay(1000)
    if er~=nil then sound.play(er) end
    if files.exists(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ERRORI/bsod.jpg") then
        bsod=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ERRORI/bsod.jpg")
        image.blit(bsod,0,0)
    end
    screen.print(50,198,errore,0.5,rosso)
    screen.flip()
    while true do
        buttons.read()
        if buttons.start then
            os.exit()
        elseif buttons.select then
            if files.exists(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ERRORI") then
                if files.exists(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ERRORI/screen_error.jpg") then
                    files.delete(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ERRORI/screen_error.png")
                end
                image.save("screen_error",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ERRORI")
            else
                if files.exists(kernel.PATH_INI.."PSP/GAME/NINOS/screen_error.jpg") then
                    files.delete(kernel.PATH_INI.."PSP/GAME/NINOS/screen_error.png")
                end
                image.save("screen_error",kernel.PATH_INI.."PSP/GAME/NINOS")
            end
        end
    end
end

if files.exists("SYSTEM/SYSTEM32/CONF/Sistema.ini") then os.cpu(ini.read("SYSTEM/SYSTEM32/CONF/Sistema.ini","cpu","222"))
else bsod("Manca il file di configurazione 'Sistema.ini'") end

local dir={kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/BIOS",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/AUDIO",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/AVVIO",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/AVVIO/avvio",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ERRORI",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ACC",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ACC/NEWACC",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ACC/IMGPR"}

function r()
       screen.flip()
       screen.clear(color.new(0,0,0))
       image.blit(bios2,0,0)
       screen.print(425,25,os.cfw(),0.7,nero)
       screen.flip()
       while true do
           buttons.read()
           if buttons.l  then
              return false
           end
           if buttons.start  then 
              screen.flip()
              image.blit(bios3,0,0)
              screen.print(425,25,os.cfw(),0.7,nero)
              screen.flip()
              if files.exists(kernel.PATH_INI.."PSP/GAME/NINOS/ripristino.zip") then
                  k=13
                  while k>1 do
                      while files.exists(dir[k])==false do
                          k=k-1
                      end
                      files.cdir(dir[k])
                      cur_dir=files.cdir()
                      lista=files.list(cur_dir)
                      max=table.getn(lista)
                      y=110
                      screen.clip(0,100,480,screen.textheight())
                      draw.fillrect(0,100,480,screen.textheight(),nero)
                      screen.print(30,100,cur_dir,0.5)
                      screen.flip()
                      for z=3,max do
                          prec_file=lista[z-1].name
                          cur_file=lista[z].name
                          os.remove(cur_file)
                          screen.clip(0,y+2,480,screen.textheight())
                          draw.fillrect(0,y+2,480,screen.textheight(),rosso)
                          if (files.exists(cur_file)==false) then
                              screen.print(30,y,cur_file.."    ELIMINATO",0.5)
                          else
                              screen.print(30,y,cur_file.."    ERRORE",0.5,rosso)
                              k=-1
                              break
                          end
                          if z>3 then
                              prec_file=lista[z-1].name
                              screen.clip(0,y-8,480,13)
                              draw.fillrect(0,y-8,480,13,nero)
                              screen.print(30,y-10,prec_file.."    ELIMINATO",0.5)
                          end
                          screen.flip()
                          os.delay(2000)
                          y=y+10
                          if y>236 then
                             y=110
                          end
                          os.delay(500)
                       end
                       files.delete(cur_dir)
                       draw.fillrect(0,100,480,10,nero)
                       if(files.exists(cur_dir)==false)then
                           screen.print(30,100,cur_dir.."    ELIMINATO",0.5,verde)
                       else
                           screen.print(30,100,cur_dir.."    ERRORE",0.5,rosso)
                           k=-1
                       end
                       k=k-1
                       screen.flip()
                       os.delay(500)
                   end
                   if k<0 then
                      e="Imp. eliminare :"..cur_dir
                      bsod(e)
                   end
                   if files.exists(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM") then
                       files.delete(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM")
                   end 
                   files.extract(kernel.PATH_INI.."PSP/GAME/NINOS/ripristino.zip",kernel.PATH_INI.."PSP/GAME/NINOS","")
                   screen.clip()
                   os.restart()
              else
                   screen.print(20,136,"File di ripristino non trovato. Si prega di scaricare",0.5)
                   screen.print(20,156,"e reinstallare il software.Premere X per tornare",0.5)
                   screen.print(20,176,"all'XMB",0.5)
                   screen.flip()
                   while true do 
                       buttons.read()
                       if buttons.cross then 
                           os.exit()
                       end
                   end
                end
            end
        end
end

function l()
	local ok=true
	local start=false
	local scritta=nil
	local lunghezza=nil
	local max=13
	local i=1
	while true do
		screen.clear(nero)
		buttons.read()
		image.blit(bios1,0,0) 
		screen.print(425,25,os.cfw(),0.7,nero)
		screen.print(300,75,os.cpu().." Mhz",0.5)
		screen.print(300,95,os.ram().." bytes",0.5)
		screen.print(300,115,batt.lifepercent().." %",0.5)
		screen.print(300,135,os.infoms0().free.." bytes",0.5)
		if buttons.cross then start=true 
		elseif buttons.r then return true end
		if start==false then screen.print(250,253,MESS,0.6,rosso)
		else	
			if i<max then
			if files.exists(dir[i]) then
				if scritta==nil then scritta = dir[i].."     OK" 
				else scritta = scritta.."\n"..dir[i].."     OK" end
				if i>5 then lunghezza=string.len(dir[i-5]) scritta = string.sub(scritta,lunghezza,-1) end 
        			
    			else
        			screen.print(0,230,dir[i].."     NO",0.5,rosso)
        			ok=false
    			end
			screen.print(0,170,scritta,0.5,verde)
			draw.fillrect(0,246,480*i/max,26,rosso)
			i=i+1
			else ok=false end
		end
		os.delay(500)
		screen.flip()
		if ok==false then os.delay(1000) os.restart() end
	end
end

function bios()
	local R=false
	while true do
		if R==false then
			R=l()
		else
			R=r()
		end
	end
end

if files.exists(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/BOOT/boot.jpg") then
	local LISTA=files.listfiles(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/MYLIB")
	for i=1,table.getn(LISTA) do
		require("SYSTEM.SYSTEM32.MYLIB."..string.sub(LISTA[i].name,0,-5))
	end
	local verOS=ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","ver_OS","")
    local b=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/BOOT/boot.jpg")
    image.blit(b,0,0)
	screen.print(350,73,verOS,0.8,nero)
    screen.flip()
    local t=timer.new(0)
    timer.start(t)
    while timer.time(t)<4000 do
        buttons.read()
        if buttons.r then
            bios()
        end
    end
else
    bsod("Mancano alcuni file di sistema")
end
kernel:avvio()
if (files.exists(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Account.ini")==false) then
    files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ACC/NEWACC")
    dofile("NEW.lua")
else
    files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ACC")
    dofile("acc.lua")
end
dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/desktop.lua")