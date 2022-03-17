kernel={}

function kernel:init()
	self.MODELLO_PSP=hw.getmodel()
	if MODELLO_PSP=="GO" then
		self.PATH_INI="ef0:/"
	elseif MODELLO_PSP~="VITA" then
		self.PATH_INI="ms0:/"
		umd.init()
	end
	self.verBI=ini.read(self.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","ver_BI","")
	self.verOS=ini.read(self.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","ver_OS","")
	self.nick=os.nick()
	self.username=ini.read(self.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Account.ini","USER1","username","")
	self.usb={
		mode=ini.read(self.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","usb_mode","ms"),
		active=false,
	}
	if ini.read(self.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","usb_auto","false")=="false"then self.usb.autoconnect=false
	else self.usb.autoconnect=true end
end


function kernel:avvio()
	MSG_sys=MSGBOX:new()
	local Delay=250
	local OP = 255
	local BOOT_IMG=image.load(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/BOOT/boot_logo.jpg")
	local BOOT_loading=image.load(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/BOOT/boot_loading.png")
	avvio=sound.load(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/AUDIO/avvio.mp3")
	image.center(BOOT_loading)
	back_bl=image.load(ini.read(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","back_lock",kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/default.jpg"))
	image.center(back_bl)
	while OP>0 do
		screen.clear(nero)
		image.blit(BOOT_IMG,0,0)
		draw.fillrect(0,0,480,272,color.new(0,0,0,OP))
		OP=OP-5
		screen.flip()
	end
	local angle=0
	local index=0
	while true do
		screen.clear(nero)
		image.blit(BOOT_IMG,0,0)
		image.blit(BOOT_loading,240,210)
		angle=angle+10
		image.rotate(BOOT_loading,angle)
		if index==1 then mouse:init()
		elseif index==2 then icone_file:init()
		elseif index==3 then startbar:init()
		elseif index==4 then desktop:init()
		elseif index==5 then startmenu:init()
		elseif index==6 then procBack:init()
		elseif index==7 then PSPbar:init()
		elseif index==8 then screensaver:init()
		elseif index>8 then Delay=800 break end
		if index<=8 then index+=1 end
		os.delay(Delay)
		screen.flip()
	end
	os.delay(Delay)
	sound.play(avvio)
	BOOT_IMG=image.load(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/BOOT/AVVIO1.jpg")
	Delay=700
	for i=1,2 do
		screen.clear(nero)
		image.blit(BOOT_IMG,0,0)
		if i==1 then BOOT_IMG=image.load(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/BOOT/AVVIO2.jpg") end
		screen.flip()
		os.delay(Delay)
	end
end

function kernel:spegni()
local Delay=15
--spegni=sound.load(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/AUDIO/spegni.wav")
local img_spegni={kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/SPEGNI/spegni1.jpg",kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/SPEGNI/spegni2.jpg",kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/SPEGNI/spegni3.jpg"}
--sound.play(spegni)
for i=1,3 do
    screen.clear(nero)
    img=image.load(img_spegni[i])
    image.blit(img,0,0)
    os.delay(Delay)
    screen.flip()
end
System.shutdown()
end

function kernel:xmb()
	local Delay=500
--spegni=sound.load(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/AUDIO/spegni.wav")
	local img_spegni={kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/SPEGNI/spegni1.jpg",kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/SPEGNI/spegni2.jpg",kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/SPEGNI/xmb.jpg"}
	--sound.play(spegni)
	for i=1,3 do
		screen.clear(nero)
		img=image.load(img_spegni[i])
		image.blit(img,0,0)
		os.delay(Delay)
		screen.flip()
	end
	os.exit()
end

function kernel:riavvia()
	local Delay=250
--spegni=sound.load(kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/AUDIO/spegni.wav")
	local img_spegni={kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/SPEGNI/spegni1.jpg",kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/SPEGNI/spegni2.jpg",kernel.PATH_INI.."PSP/GAME/NinOS/SYSTEM/SPEGNI/spegni3.jpg"}
	for i=1,3 do
		screen.clear(nero)
		img=image.load(img_spegni[i])
		image.blit(img,0,0)
		os.delay(Delay)
		screen.flip()
	end
	os.restart()
end

resetImp = function()
	files.delete("SYSTEM/SYSTEM32/CONF/Account.ini")
	files.delete("SYSTEM/SYSTEM32/CONF/startbar.ini")
	ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","velocita","5")
	ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","cpu","222")
	ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","themeName","default")
	ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","max_desk","1")
	ini.write("SYSTEM/SYSTEM32/CONF/Sistema.ini","background_lock","ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/default.jpg")
	ini.write("SYSTEM/SYSTEM32/CONF/desktop.ini","back_desk","ms0:/PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/default.jpg")
	os.delay(1000)
	os.restart()
end

resetOS = function()
end

updateOS = function()
	if wlan.isconnected	() then
		if http.getfile("www.ninos.com",kernel.PATH_INI.."UPDATE/Ver.ini") then
			if ini.read("ver")>kernel.verOS then
				DownloadTool:init("",kernel.PATH_INI.."UPDATE/NinOSUPDATE.zip")
				DownloadTool:connectS(function()
					MSG:type("UPDATE","Il download dell'aggiornamento e' stato completato con successo. Procedere con l'installazione?",__MBOKCANC,__MBICONINFO)
					MSG:connect(__MBOK,function()
						thread:closeAll()
						aggiornamento()
					end)
				end)
			end
		else
			MSG:type("Errore","C'e' stato un errore durante il download",__MBCANC,__MBICONERROR)
		end
	else
		MSG:type("Errore","La console non è collegata a internet e non è possibile verificare la disponibilita' degli aggiornamenti",__MBCANC,__MBICONERROR)
	end
end


