files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32")

timg="ACC/IMGPR/default.png" tpass="" vpass="" 
local esci=true bpass=false yimg=136 ESCI=true ok=true X=440 Y=232

local spegni=image.load("ICONE/iconSpegniBtn.png")

timg=ini.read("CONF/Account.ini","USER1","immagine","ACC/IMGPR/default.png")
tpass=ini.read("CONF/Account.ini","USER1","password","")
tuser=ini.read("CONF/Account.ini","USER1","username","")
imgpr=image.load(timg)

local menu=MV_new(387,160,0,0,color.new(147,147,147),color.new(121,121,121),0.5,bianco,nero,true,true,2)
menu:add("Spegni",false)
menu:add("Riavvia",false)
menu:add("XMB",false)

local show=false

local btn_m=BT_IMG_new(400,232,spegni,{x=0,y=0,w=20,h=20},{x=20,y=0,w=20,h=20})
btn_m:connect("clicked",function()
	if show==false then 
		show=true
	else
		show=false
	end
end)

while esci==true do
	buttons.read()
	image.blit(back_bl,240,136)
	if mouse:getx()>=210 and mouse:getx()<=270 and mouse:gety()>=195 and mouse:gety()<=205 and ok==false then
		draw.fillrect(208,193,64,14,color.new(0,0,0))
		if buttons.cross then
			vpass=osk.init("password","root")
			ESCI=false
		end
	end
	if ok==false then
		draw.fillrect(200,50,80,160,color.new(147,147,147))
		screen.print(210,140,"Username",0.5)
		screen.print(210,150,tuser,0.5)
		if tpass ~= "" then
		    draw.fillrect(210,195,60,10,color.new(255,255,255))
		    screen.print(210,180,"Password",0.5)
		    screen.print(212,195,vpass,0.5,color.new(0,0,0))
		else
			ESCI=false
		end
	end
	image.blit(imgpr,215,60)
	if mouse:getx()>=215 and mouse:getx()<=265 and mouse:gety()>=60 and mouse:gety()<=110 then
	    if buttons.cross then
		    ok=false
		end
	elseif mouse:getx()<215 or mouse:getx()>265 or mouse:getx()>=215 and mouse:getx()<=265 and mouse:gety()<60 or mouse:gety()>110 then
		if buttons.cross then
			ok=true
		end
	end
	if vpass==tpass and ESCI==false then
		while yimg > -272 do
			sfondo:blit()
			image.blit(back_bl,240,yimg)
			screen.flip()
			yimg=yimg-3
		end
		esci=false
	end
	if show then
		menu:blit()
	end
	btn_m:blit()
	if btn_m:hover()==false and buttons.cross then 
		show=false
	end
	screen.print(0,220,string.sub(os.getdate(),17,-4),2,color.new(0,0,0))
	screen.print(13,250,string.sub(os.getdate(),1,14),0.8,color.new(0,0,0))
	batteria:blit(X,Y)
	mouse:blit()
	screen.flip()
end
dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/desktop.lua")