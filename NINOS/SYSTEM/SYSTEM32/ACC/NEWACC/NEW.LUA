files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32")

tuser=""
tpass=""

local imgP=""
local logo=image.load("ICONE/logo.png")
local imgACC={}
for i=1,10 do
	imgACC[i]=image.load("ACC/IMGPR/img"..i..".png")
end

local i=1
local nextBTN=BT_new(430,238,44,28,">",1,bianco,bianco,"cross",color.new(0,175,245),color.new(0,135,205),10)
nextBTN:connect("clicked",function()
	if i==2 then
		if imgP=="" then
			imgP=kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ACC/IMGPR/img10.png"
		end
		imgpr=image.load(imgP)
	end
	i=i+1
	if i==4 then nextBTN.text="Fine"
	elseif i==5 then
		ini.write("CONF/Account.ini","USER1","username",tuser)
		ini.write("CONF/Account.ini","USER1","password",tpass)
		ini.write("CONF/Account.ini","USER1","immagine",imgP)
	end
end)

local backBTN=BT_new(6,238,44,28,"<",1,bianco,bianco,"cross",color.new(0,175,245),color.new(0,135,205),10)
backBTN:connect("clicked",function()
	i=i-1
end)

local rfile=""
while i<5 do
    buttons.read()
	screen.clear(bianco)
	draw.fillrect(0,0,480,30,color.new(0,175,245))
	nextBTN:blit()
	if i>1 then backBTN:blit() end
	if i==1 then
		screen.print(150,10,"Crea il tuo account",1,bianco)
		draw_round_fillrect(91,52,300,190,20,color.new(0,175,245))
		image.blit(logo,99,66)
		screen.print(210,77,"La creazione dell'account viene effettuata solo quando si avvia NinOS per la prima volta oppure dopo che è stato ripristinato il sistema",0.7,bianco,color.new(0,0,0,0),__ALEFT,168)
		screen.print(241,199,"Segui le istruzioni a schermo per creare il tuo account personale",0.6,bianco,color.new(0,0,0,0),__ACENTER,300)
	elseif i==2 then
		screen.print(15,10,"Seleziona un'immagine di profilo per il tuo account",0.9,bianco)
		for y=1,2 do 
			for i=1,5 do
				if mouse:getx()>=50+80*(i-1) and mouse:getx()<=50+80*(i-1)+50 and mouse:gety()>=65+90*(y-1) and mouse:gety()<=65+90*(y-1)+50 then
					draw.fillrect(49+80*(i-1),64+90*(y-1),52,52,color.new(0,0,0))
					if buttons.cross then
						os.delay(1000)
						imgP=kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ACC/IMGPR/img"..(5*(y-1)+i)..".png"
					end
				end
				image.blit(imgACC[5*(y-1)+i],50+80*(i-1),65+90*(y-1))
			end
		end
    elseif i==3 then
		screen.print(150,10,"Crea il tuo account",1,bianco)
		draw_round_fillrect(91,52,300,190,20,color.new(0,175,245))
		screen.print(167,70,"Inserire nome utente",0.7,bianco)
		screen.print(177,149,"Inserire password",0.7,bianco)
		screen.print(240,200,"Nel caso in cui non si vuole applicare una password al proprio account lasciare vuoto il corrispettivo campo di testo",0.6,bianco,color.new(0,0,0,0),__ACENTER,300)
        if mouse:getx()>=165 and mouse:getx()<=315 and mouse:gety()>100 and mouse:gety()<=122 then
            draw.fillrect(164,100,152,22,color.new(0,0,0))
            if buttons.cross then
                tuser = osk.init("nome utente","admin")
            end
        elseif mouse:getx()>=165 and mouse:getx()<=315 and mouse:gety()>=180 and mouse:gety()<=202 then
            draw.fillrect(164,179,152,22,color.new(0,0,0))
            if buttons.cross then
                tpass = osk.init("password","root")
            end
        end
        draw.fillrect(165,101,151,20,color.new(255,255,255))
        draw.fillrect(165,180,150,20,color.new(255,255,255))
        screen.print(170,85,tuser,0.5,color.new(0,0,0))
        screen.print(170,165,tpass,0.5,color.new(0,0,0))
    elseif i==4 then 
        image.blit(imgpr,80,100)
        screen.print(350,100,tuser,0.5,color.new(0,0,0))
        screen.print(350,160,tpass,0.5,color.new(0,0,0))
    end
    mouse:blit()
    screen.flip()
end
