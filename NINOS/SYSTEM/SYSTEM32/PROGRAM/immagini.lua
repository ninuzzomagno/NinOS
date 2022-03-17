files.cdir("ms0:/PSP/GAME/NINOS")
require=("SYSTEM.SYSTEM32.ASR")

local sfondo=image.load("SYSTEM/SYSTEM32/PROGRAM/immagini.jpg")
local png=image.load("SYSTEM/SYSTEM32/ICONE/png.png")
local jpg=image.load("SYSTEM/SYSTEM32/ICONE/jpg.png")
local ico_fileg=image.load("SYSTEM/SYSTEM32/ICONE/ico_fileg.png")
local ico_cartella=image.load("SYSTEM/SYSTEM32/ICONE/ico_cartella.png")
local immagine=nil

image.center(png)
image.center(jpg)
image.center(ico_fileg)
image.center(ico_cartella)

function IMGV_ESCI()
	if x>450 and x<470 and y>2 or y<22 then
		image.blit(chiudih,450,2)
    		if buttons.cross then
			destroy_thread(5,getproc_thread())
        		files.cdir("ms0:/PSP/GAME/NINOS")
        		dofile("SYSTEM/SYSTEM32/desktop.lua")
    		end
	else image.blit(chiudi,450,2) end
	if x>425 and x<445 and y>2 and y<22 then
		image.blit(riducih,425,2)
		if buttons.released.cross then
			pause_thread(5,getproc_thread())
			PROC_ID_R=nil
			PROC_THREAD_PROC=nil
		end
	else image.blit(riduci,425,2) end
end

function AVVIO_PROG()
	local PATH="ms0:/PICTURE"
	local l_img=files.list(PATH)
	local l_max=table.getn(l_img)
	local max=12 
	local Y=40 
	local X=41 
	local c=0
	local r=0 
	local z=-1
	local Z=-1 
	local A=1
	
	if max>l_max then max=l_max end
	
	while true do
		buttons.read()
		image.blit(sfondo,0,0)
		if string.len(PATH)>30 then screen.print(140,7,string.sub(PATH,1,30).."...",0.7,nero)
		else screen.print(140,7,PATH,0.7,nero) end
		if z~=-1 and Z~=-1 then draw.fillrect(X+110*z-25,Y+Z*70-30,50,60,color.new(176,224,230)) end
		-- then draw.fillrect((11+c*30+(c-1)*92)-1,((z-1)*100-(z-2)*40)-1,32,41,color.new(0,0,0,100)) end
		for i=A,max do
    			if l_img[i].ext == "png" then image.blit(png,X+110*c,Y+70*r) 
    			elseif l_img[i].ext == "jpg" then image.blit(jpg,X+110*c,Y+70*r)
    			--elseif l_img[i].ext == "bmp" then image.blit(bmp,11+a*30+(a-1)*92,Y)
    			--elseif l_img[i].ext == "gif" then image.blit(gif,11+a*30+(a-1)*92,Y)
    			elseif l_img[i].directory then image.blit(ico_cartella,X+110*c,Y+70*r)
    			else image.blit(ico_fileg,X+110*c,Y+70*r) end
    			--screen.print(11+a*image.getw(jpg)+(a-1)*92,Y+40,string.sub(l_img[i].name,1,6),0.5,color.new(0,0,0))
    			screen.print(X+110*c-screen.textwidth(string.sub(l_file[i].name,1,10),0.6)/2,Y+20+70*r,string.sub(l_file[i].name,1,10),0.6,nero)
			if c==2 then c=0 r=r+1 else c=c+1 end
		end
		c=0 r=0
		if buttons.l and A>3  then
			if max==A+8 or max==A+2 or max==A+5 then max = max-3
			elseif max==A+7 or max==A+4 or max==A+1 then max=max-2
			elseif max==A+6 or max==A+3 or max==A then max=max-1 end
			A=A-3
			z=-1 Z=-1
		elseif buttons.r and max<l_max then
			A=A+3
			z=-1 Z=-1
			if max+3>l_max then max=l_max
			else max=max+3 end
		elseif buttons.held.cross and z>0 and c>0 then
    			C=(z*4)+4-c+max-12
    			if l_img[C].directory == false and l_img[C].ext ~= "png" and l_img[C].ext ~= "jpg" and l_img[C].ext ~= "gif" and l_img[C].ext ~= "bmp" then ERRORE=true  sound.play(s_error) er="Formato file non supportato :("
    			elseif l_img[C].directory == false and l_img[C].ext == "png" or l_img[C].ext == "jpg" or l_img[C].ext == "gif" or l_img[C].ext == "bmp" then
        			immagine=image.load(l_img[C].name)
        			if immagine == nil then er="Immagine troppo grande\nper essere visualizzata :(" ERRORE=true sound.play(s_error)
        			else image.blit(immagine,240-(image.getw(immagine)/2),136-(image.geth(immagine)/2)) ERRORE=false end 
    			end
		end
		IMGV_ESCI()
		HOME()
		startbar(x,y)
		x,y=mouse(x,y,freccia)
		screen.flip()
	end
end

if new_thread(5,IMGV_ICO)==false then bsod("Impossibile creare thread per avviare il programma") end
