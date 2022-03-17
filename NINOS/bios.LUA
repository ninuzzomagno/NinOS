files.cdir("ms0:/PSP/GAME/NINOS")

nero=color.new(0,0,0)
bianco=color.new(255,255,255)
rosso=color.new(255,0,0)
verde=color.new(0,255,0)

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

if files.exists("SYSTEM/SYSTEM32/ACC/CONF.txt") then
	local c=io.open("SYSTEM/SYSTEM32/ACC/CONF.txt","r")
	local tc=c:read()
	c:close()
	os.cpu(tc)
else
	os.cpu(222)
end

local dir={"ms0:/PSP/GAME/NINOS/SYSTEM","ms0:/PSP/GAME/NINOS/SYSTEM/BIOS","ms0:/PSP/GAME/NINOS/SYSTEM/AUDIO","ms0:/PSP/GAME/NINOS/SYSTEM/AVVIO","ms0:/PSP/GAME/NINOS/SYSTEM/AVVIO/avvio","ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32","ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM","ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI","ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/ERRORI","ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE","ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/ACC","ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/ACC/NEWACC","ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/ACC/IMGPR"}

function aggiornamento()
	local lunghezza=nil
	local scritta = nil
	local FILE=files.scan("NinOS.zip")
	local max=table.getn(FILE)
	files.extractfile("NinOS.zip","SYSTEM/SYSTEM32/ACC/verOS.txt","NEW_VER")
	local f = io.open("NEW_VER/SYSTEM/SYSTEM32/ACC/verOS.txt",'r')
	local ver = f:read()
	f:close()
	files.delete("NEW_VER")
	local i = 1
	--files.delete("ms0:/PSP/GAME/NinOS/SYSTEM")
	while i<=max do
		screen.clear(nero)
		screen.print(0,5,"Nuova versione trovata......"..ver)
		--files.extractfile("NinOS.zip",FILE[i].name,"ms0:/PSP/GAME/NinOS")
		if scritta==nil then scritta = FILE[i].name.."    "..FILE[i].size
		else scritta = scritta.."\n"..FILE[i].name.."    "..FILE[i].size end
		if i>15 then
			lunghezza = string.len(FILE[i].name.."    "..FILE[i].size)
			scritta = scritta.sub(scritta,lunghezza,-1)
		end
		screen.print(0,20,scritta)
		draw.fillrect(480*i/max,250,480-480*i/max,22,bianco)
		draw.fillrect(0,250,480*i/max,22,rosso)
		i=i+1
		screen.flip()
	end
	--files.rename("NinOS.zip","ripristino.zip")
	os.delay(2000)
	os.restart()
end

function bsod(errore)
    os.delay(1000)
    if er~=nil then 	sound.play(er) end
    if files.exists("ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/ERRORI/bsod.jpg") then
        bsod=image.load("ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/ERRORI/bsod.jpg")
        image.blit(bsod,0,0)
    end
    screen.print(50,198,errore,0.5,rosso)
    screen.flip()
    while true do
        buttons.read()
        if buttons.start then
            os.exit()
        elseif buttons.select then
            if files.exists("ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/ERRORI") then
                if files.exists("ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/ERRORI/screen_error.jpg") then
                    files.delete("ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/ERRORI/screen_error.png")
                end
                image.save("screen_error","ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/ERRORI")
            else
                if files.exists("ms0:/PSP/GAME/NINOS/screen_error.jpg") then
                    files.delete("ms0:/PSP/GAME/NINOS/screen_error.png")
                end
                image.save("screen_error","ms0:/PSP/GAME/NINOS")
            end
        end
    end
end

function r()
       screen.flip()
       screen.clear(color.new(0,0,0))
       image.blit(bios2,0,0)
       screen.print(380,28,os.cfw(),0.7,nero)
       screen.flip()
       while true do
           buttons.read()
           if buttons.l  then
              bios()
           end
           if buttons.start  then 
              screen.flip()
              image.blit(bios3,0,0)
              screen.print(380,28,os.cfw(),0.7,nero)
              screen.flip()
              if files.exists("ms0:/PSP/GAME/NINOS/ripristino.zip") then
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
                   if files.exists("ms0:/PSP/GAME/NINOS/SYSTEM") then
                       files.delete("ms0:/PSP/GAME/NINOS/SYSTEM")
                   end 
                   files.extract("ms0:/PSP/GAME/NINOS/ripristino.zip","ms0:/PSP/GAME/NINOS","")
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

functions bios()
local r=false
local scritta=nil
local start=false
while true do
	screen.clear(nero)
	buttons.read()
	if r==false then
		image.blit(bios1,0,0) 
		screen.print(380,25,os.cfw(),0.7,nero)
		screen.print(300,75,os.cpu().." Mhz",0.5)
		screen.print(300,95,os.ram().." bytes",0.5)
		screen.print(300,115,batt.lifepercent().." %",0.5)
		screen.print(300,140,os.infoms0().free.." bytes",0.5)
		if buttons.cross then
			start=true
		end
		if start==false then	 screen.print(250,255,MESS,0.6,rosso) end
		else
			
		end
	end
	screen.flip()
end
end

function bios()

screen.flip()
while start==true do
    buttons.read()
    if buttons.cross then 
	start=false
    end
    if buttons.r then
       r()
    end
    if buttons.l then
        screen.flip()
        image.blit(bios1,0,0) 
	 screen.print(380,25,os.cfw(),0.7,nero)
	 screen.print(300,75,os.cpu().." Mhz",0.5)
	 screen.print(300,95,os.ram().." bytes",0.5)
	 screen.print(300,115,batt.lifepercent().." %",0.5)
	 screen.print(300,140,os.infoms0().free.." bytes",0.5)
	 screen.print(250,255,MESS,0.6,rosso)
	 screen.flip()
    end
end
per=9.09
image.blit(bios1,0,0)
screen.print(380,25,os.cfw(),0.7,nero)
screen.print(300,75,os.cpu().." Mhz",0.5)
screen.print(300,95,os.ram().." bytes",0.5)
screen.print(300,115,batt.lifepercent().." %",0.5)
screen.print(300,140,os.infoms0().free.." bytes",0.5)
while (ok==true and OK==true) do
    draw.fillrect(0,a+3,480,10,nero)
    if files.exists(dir[i]) then
        screen.print(0,a,dir[i].."     OK",0.5,verde)
    else
        screen.print(0,a,dir[i].."     NO",0.5,rosso)
        ok=false
    end
    draw.fillrect(0,a-8,480,10,nero)
    if i>1 then
        screen.print(0,a-10,dir[i-1].."     OK",0.5,verde)
    end
    screen.clip(0,246,480,26)
    draw.fillrect(0,246,480,26,bianco)
    draw.fillrect(0,246,X,26,rosso)
    screen.print(234,255,per.." %",0.5,nero)
    screen.flip()
    screen.clip()
    i=i+1
    a=a+10
    X=X+43.63
    per=per+9.09
    os.delay(1000)
    if i>13 then 
        OK=false
    end
    if a==240 then 
       a=180
    end
end
screen.clip()
if ok==false then
    bsod(dir[i-1])
end
os.restart()
end

if files.exists("ms0:/PSP/GAME/NINOS/SYSTEM") == false then 
   installazione()
else
if files.exists("ms0:/PSP/GAME/NINOS/SYSTEM/AVVIO/boot.jpg")then
    require("SYSTEM.SYSTEM32.ASR")
    b=image.load("ms0:/PSP/GAME/NINOS/SYSTEM/AVVIO/boot.jpg")
    image.blit(b,0,0)
    screen.flip()
    t=timer.new(0)
    timer.start(t)
    while timer.time(t)<5000 do
        buttons.read()
        if buttons.r then
            screen.flip()
            bios()
        end
    end    
else
    screen.clear(color.new(0,0,0))
    bios()
end
avvio()
if (files.exists("ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/ACC/user.txt")==false) then
    files.cdir("ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/ACC/NEWACC")
    dofile("NEW.lua")
else
    files.cdir("ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/ACC")
    dofile("acc.lua")
end
end

