files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS")

function READ_INFO_UMD(gameMax,INFO,imgDefault)
	INFO[1] = string.sub(umd.size(),3,-1)
	INFO[2] = "UMD "..umd.type()
	if umd.info().APP_VER ~=nil then INFO[3] = umd.info().APP_VER 
	else INFO[3] = "sconosciuto" end
	if umd.info().DISC_ID ~=nil then INFO[4] = umd.info().DISC_ID 
	else INFO[4] = "sconosciuto" end
	if umd.info().PSP_SYSTEM_VER ~=nil then INFO[5] = umd.info().PSP_SYSTEM_VER 
	else INFO[5] = "sconosciuto" end
	if umd.info().TITLE ~=nil then INFO[6] = umd.info().TITLE
	else INFO[6] = "sconosciuto" end
	return INFO
end

function PSTEAMP_UMD_DISK(gameMax,INFO,GIOCHI,IMGgame,NMgame,imgDefault)
	if kernel.PATH_INI=="ms0:/" and umd.init()==true then
		gameMax+=1
		GIOCHI[gameMax]={}
		GIOCHI[gameMax].tipo="UMD"
		GIOCHI[gameMax].name=(umd.info()).TITLE 
		if string.len(GIOCHI[gameMax].name)<18 then NMgame[gameMax]=(GIOCHI[gameMax].name)
		else NMgame[gameMax]=string.sub(GIOCHI[gameMax].name,1,15).."..." end
		IMGgame[gameMax]=imgDefault
		image.scale(IMGgame[gameMax],70)
		return gameMax,INFO,GIOCHI,IMGgame,NMgame
	end
	return gameMax,INFO,GIOCHI,IMGgame,NMgame
end

function READ_INFO(homebrew,z,INFO,GIOCHI,HOMEBREW)
	if homebrew==false then
		if GIOCHI[z].tipo~=nil then INFO=READ_INFO_UMD(z,INFO,imgDefault)
		else
		INFO[1] = math.floor((GIOCHI[z].size)/1024/1024)
		INFO[2] = GIOCHI[z].ext
		if game.info(GIOCHI[z].path).APP_VER ~=nil then INFO[3] = game.info(GIOCHI[z].path).APP_VER 
		else INFO[3] = "sconosciuto" end
		if game.info(GIOCHI[z].path).DISC_ID ~=nil then INFO[4] = game.info(GIOCHI[z].path).DISC_ID 
		else INFO[4] = "sconosciuto" end
		if game.info(GIOCHI[z].path).PSP_SYSTEM_VER ~=nil then INFO[5] = game.info(GIOCHI[z].path).PSP_SYSTEM_VER 
		else INFO[5] = "sconosciuto" end
		if game.info(GIOCHI[z].path).TITLE ~=nil then INFO[6] = game.info(GIOCHI[z].path).TITLE 
		else INFO[6] = "sconosciuto" end
		end
	else
		INFO[1] = math.floor(files.size(HOMEBREW[z].path)/1024/1024)
		INFO[2] = "pbp"
		if game.info((HOMEBREW[z].path).."/EBOOT.PBP").APP_VER ~=nil then INFO[3] = game.info((HOMEBREW[z].path).."/EBOOT.PBP").APP_VER 
		else INFO[3] = "sconosciuto" end
		if game.info((HOMEBREW[z].path).."/EBOOT.PBP").DISC_ID ~=nil then INFO[4] = game.info((HOMEBREW[z].path).."/EBOOT.PBP").DISC_ID 
		else INFO[4] = "sconosciuto" end
		if game.info((HOMEBREW[z].path).."/EBOOT.PBP").PSP_SYSTEM_VER ~=nil then INFO[5] = game.info((HOMEBREW[z].path).."/EBOOT.PBP").PSP_SYSTEM_VER 
		else INFO[5] = "sconosciuto" end
		if game.info((HOMEBREW[z].path).."/EBOOT.PBP").TITLE ~=nil then INFO[6] = game.info((HOMEBREW[z].path).."/EBOOT.PBP").TITLE 
		else INFO[6] = "sconosciuto" end
	end
	return INFO,GIOCHI,HOMEBREW
end

function PSTEAMP_menu(homebrew,A,MAX1,MAX2,z,homebrewMax,gameMax,INFO,GIOCHI,HOMEBREW,imgDefault,X,Y,IMGgame,NMgame,IMGhomebrew,NMhomebrew)
	if homebrew==false then
		draw.fillrect(6,25,234,30,color.new(38,38,38))
		screen.print(80,33,"GIOCHI",0.8,rosso)
		if mouse:getx()>=240 and mouse:getx()<=474 and mouse:gety()>=25 and mouse:gety()<=55 then
			draw.fillrect(240,25,233,30,color.new(38,38,38))
			screen.print(315,33,"HOMEBREW",0.8,rosso)
			if buttons.cross then
				if homebrewMax~=0 then
					Y=63 z=1 MAX2=12 A=1 X=83
					homebrew,MAX2,homebrewMax,INFO,HOMEBREW=HomebrewList(homebrew,z,MAX2,homebrewMax,INFO,HOMEBREW,imgDefault,IMGhomebrew,NMhomebrew)
				else homebrew=true end
			end
		else screen.print(315,33,"HOMEBREW",0.8,bianco) end
	else
		draw.fillrect(240,25,233,30,color.new(38,38,38))
	 	screen.print(315,33,"HOMEBREW",0.8,rosso)
		if mouse:getx()>=6 and mouse:getx()<=233 and mouse:gety()>=25 and mouse:gety()<=55 then
			draw.fillrect(6,25,234,30,color.new(38,38,38))
			screen.print(80,33,"GIOCHI",0.8,rosso)
			if buttons.cross then
				if gameMax~=0 then
					Y=63 z=1 MAX1=12 A=1 X=83
					homebrew,MAX1,gameMax,INFO,GIOCHI=GameList(homebrew,z,MAX1,gameMax,INFO,GIOCHI,IMGgame,NMgame,imgDefault)
				else homebrew=false end
			end
		else screen.print(80,33,"GIOCHI",0.8,bianco) end
	end
	return homebrew,A,MAX1,MAX2,z,homebrewMax,gameMax,INFO,GIOCHI,HOMEBREW,X,Y
end

function GameList(homebrew,z,MAX1,gameMax,INFO,GIOCHI,IMGgame,NMgame,imgDefault)
	GIOCHI=files.listfiles(kernel.PATH_INI.."ISO")
	if GIOCHI ~=nil then
		gameMax=table.getn(GIOCHI)
		for i=1,gameMax do
			if GIOCHI[i].ext~="iso" and GIOCHI[i].ext~="cso" then
				table.remove(GIOCHI,i)
			end
		end
		gameMax=table.getn(GIOCHI)
		if gameMax~=0 then
			for i=1,gameMax do
				if string.len(GIOCHI[i].name)<18 then NMgame[i]=(GIOCHI[i].name)
				else NMgame[i]=string.sub(GIOCHI[i].name,1,15).."..." end
				IMGgame[i]=game.geticon0(GIOCHI[i].path)
				image.scale(IMGgame[i],70)
			end
			homebrew=false 
			INFO,GIOCHI,HOMEBREW=READ_INFO(homebrew,z,INFO,GIOCHI,HOMEBREW)
		end
	else homebrew=false end
	--gameMax,INFO,GIOCHI,IMGgame,NMgame = PSTEAMP_UMD_DISK(gameMax,INFO,GIOCHI,IMGgame,NMgame,imgDefault)
	if MAX1 > gameMax then MAX1=gameMax end
	return homebrew,MAX1,gameMax,INFO,GIOCHI
end

function HomebrewList(homebrew,z,MAX2,homebrewMax,INFO,HOMEBREW,imgDefault,IMGhomebrew,NMhomebrew)
	HOMEBREW=files.listdirs(kernel.PATH_INI.."PSP/GAME") 
	if HOMEBREW~=nil then
	homebrewMax=table.getn(HOMEBREW)
	if homebrewMax~=0 then
		if MAX2 > homebrewMax then MAX2=homebrewMax end
		for i=1,homebrewMax do
			if string.len(HOMEBREW[i].name)>18 then NMhomebrew[i]=string.sub(HOMEBREW[i].name,1,15).."..."
			else NMhomebrew[i]=string.sub(HOMEBREW[i].name,1,18) end
			IMGhomebrew[i]=game.geticon0((HOMEBREW[i].path).."/EBOOT.PBP")
			if IMGhomebrew[i]==nil then IMGhomebrew[i]=imgDefault end
			image.scale(IMGhomebrew[i],70) 
		end
		homebrew=true
		INFO,GIOCHI,HOMEBREW=READ_INFO(homebrew,z,INFO,GIOCHI,HOMEBREW)
		end
	else homebrew=true end
	return homebrew,MAX2,homebrewMax,INFO,HOMEBREW
end

function PSTEAMP_AVVIO_PROG(gioco_path)

if files.exists(kernel.PATH_INI.."ISO")==false then files.mkdir(kernel.PATH_INI.."ISO") end

local IMGgame={}
local NMgame={}
local IMGhomebrew={}
local NMhomebrew={}
local sfondo=image.load("SYSTEM/SYSTEM32/PROGRAM/PsteamP/PSteamP_home.jpg")
local X=83 
local Y=63
local imgDefault=image.load("SYSTEM/SYSTEM32/ICONE/default.png")  
local HOMEBREW=nil
local GIOCHI=nil
local INFO={}
local MAX1=12 
local MAX2=12 
local z=1
local homebrew=false 
local A=1
local gameMax=-1
local homebrewMax=-1
local bt=BT_new(360,215,100,25,"Avvia",0.8,bianco,rosso,"cross",color.new(23,23,23),nero)
local bt_del=BT_new(175,215,100,25,"Elimina",0.8,bianco,rosso,"cross",color.new(23,23,23),nero)
bt:connect("clicked",function() 
				if homebrew==true and HOMEBREW~=nil then game.launch((HOMEBREW[z].path).."/EBOOT.PBP")
				elseif homebrew==false and GIOCHI~=nil then
					if string.sub(INFO[2],1,3)=="UMD" then
						umd.launch()
					else game.launch(GIOCHI[z].path) 
					end
				end
			end)

bt_del:connect("clicked",function() 
				if homebrew==true and HOMEBREW~=nil then
					files.delete((HOMEBREW[z].path))
					table.remove(HOMEBREW,z)
					if z>1 then z=z-1 else z=1 end
				elseif homebrew==false and GIOCHI~=nil then
					files.delete((GIOCHI[z].path))
					table.remove(GIOCHI,z)
					if z>1 then z=z-1 else z=1 end
				end
			end)

if sfondo==nil or imgDefault==nil then bsod("Mancano alcuni file di sistema") end

homebrew,MAX1,gameMax,INFO,GIOCHI=GameList(homebrew,z,MAX1,gameMax,INFO,GIOCHI,IMGgame,NMgame,imgDefault)

while true do
	buttons.read()
	image.blit(sfondo,0,0)
	homebrew,A,MAX1,MAX2,z,homebrewMax,gameMax,INFO,GIOCHI,HOMEBREW,X,Y = PSTEAMP_menu(homebrew,A,MAX1,MAX2,z,homebrewMax,gameMax,INFO,GIOCHI,HOMEBREW,imgDefault,X,Y,IMGgame,NMgame,IMGhomebrew,NMhomebrew)
	if homebrew==false and gameMax~=0 then
		for i=A,MAX1 do
			if i==z then 
				if string.len(GIOCHI[i].name) > 18 then
					X = screen.print(X,Y,string.sub(GIOCHI[i].name,1,-5),0.6,rosso,color.new(23,23,23),__SSEESAW,129)
				else screen.print(20,Y,NMgame[i],0.6,rosso) end
			else screen.print(20,Y,NMgame[i],0.6,bianco) end
			Y=Y+15
			if i==MAX1 then
				i=A
				Y=63
			end
		end
		image.blit(IMGgame[z],180,70)
		if buttons.l and z>1 then
			z=z-1
			INFO,GIOCHI,HOMEBREW=READ_INFO(homebrew,z,INFO,GIOCHI)
			if z<A then
				A=A-1
				MAX1=MAX1-1
			end
		elseif buttons.r and z<gameMax then
			z=z+1
			INFO,GIOCHI,HOMEBREW=READ_INFO(homebrew,z,INFO,GIOCHI,HOMEBREW)
			if z>MAX1 then
				MAX1 = MAX1+1
				A = A+1
			end
		end
		scrollbar(11,58,244,2,z,math.abs(MAX1-A+1),gameMax,color.new(0,0,0,0,0),bianco)
	elseif homebrew==true and homebrewMax~=0 then
		for i=A,MAX2 do
			if i==z then 
				if string.len(HOMEBREW[i].name) > 18 then
					X = screen.print(X,Y,HOMEBREW[i].name,0.6,rosso,color.new(23,23,23),__SSEESAW,129)
				else screen.print(20,Y,NMhomebrew[i],0.6,rosso) end
			else screen.print(20,Y,NMhomebrew[i],0.6,bianco) end
			Y=Y+15
			if i==MAX2 then
				i=A
				Y=63
			end
		end
		image.blit(IMGhomebrew[z],180,70)
		if buttons.l and z>1 then
			z=z-1
			INFO,GIOCHI,HOMEBREW=READ_INFO(homebrew,z,INFO,GIOCHI,HOMEBREW)
			if z<A then
				A=A-1
				MAX2=MAX2-1
			end
		elseif buttons.r and z<homebrewMax then
			z=z+1
			INFO,GIOCHI,HOMEBREW=READ_INFO(homebrew,z,INFO,GIOCHI,HOMEBREW)
			if z>MAX2 then
				MAX2 = MAX2+1
				A = A+1
			end
		end
		scrollbar(11,58,244,2,z,math.abs(MAX2-A+1),homebrewMax,color.new(0,0,0,0,0),bianco)
	end
if (homebrew==true and homebrewMax~=0) or (homebrew==false and gameMax~=0) then
	screen.print(180,130,"Tipo di file :",0.6,bianco)
	screen.print(180,145,"Versione app :",0.6,bianco)
	screen.print(180,160,"ID app :",0.6,bianco)
	screen.print(180,175,"Richiede ofw minimo :",0.6,bianco)
	screen.print(180,190,"Spazio occupato :",0.6,bianco)
	screen.print(290,80,"Titolo :",0.6,bianco)
	screen.print(260,130,INFO[2],0.6,bianco)
	screen.print(280,145,INFO[3],0.6,bianco)
	screen.print(240,160,INFO[4],0.6,bianco)
	screen.print(320,175,INFO[5],0.6,bianco)
	screen.print(300,190,INFO[1].." MB",0.6,bianco)
	screen.print(340,80,INFO[6],0.6,bianco,color.new(0,0,0,0),__ALEFT,120)
	bt:blit()
	bt_del:blit()
end
	PROG_ESCI()
	startbar:blit()
	mouse:blit()
	screen.flip()
end
end
--PSTEAMP_AVVIO_PROG()
thread:new(1,image.load("SYSTEM/SYSTEM32/PROGRAM/PsteamP/icona.png"),PSTEAMP_AVVIO_PROG)