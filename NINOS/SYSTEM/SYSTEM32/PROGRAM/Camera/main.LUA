files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS")

function CAMERA_PROG()
	if usb.isactive() then USBstop() end
	if files.exists(kernel.PATH_INI.."CAMERA")==false then files.mkdir(kernel.PATH_INI.."CAMERA") end
	cam.init()
	if cam.available()==true then
		MSG:type("Errore","\nGO!Cam non collegata",__MBOKCANC,__MBICONERROR)
		if kernel.usb.autoconnect then USB.run() end
		thread:delete(9,thread:getProc())
	end
	cam.begin()
	while true do
		buttons.read()
		cam.render(0,0)
		if mouse:getx()>420 and mouse:gety()<25 then
			PROG_ESCI()
		end
		if mouse:getx()<=480 and mouse:gety()>247 then
			startbar:blit()
		end
		mouse:blit()
		screen.flip()
		if buttons.r then cam.shot(kernel.PATH_INI.."CAMERA/IMG"..os.getdate()..".png") end
	end
end

if thread:new(9,image.load("SYSTEM/SYSTEM32/PROGRAM/CAMERA/icona.png"),CAMERA_PROG)==false then bsod("Impossibile creare thread per avviare il programma") end
