
files.cdir(kernel.PATH_INI.."PSP/GAME/NinOS")

function CMD_AVVIO_PROG()
	local sfondo=image.load("SYSTEM/SYSTEM32/PROGRAM/CMD/cmd.png")
	cmd=CMD_init()
	cmd:add_cmd()
	while true do
		screen.clear(nero)
		buttons.read()
		image.blit(sfondo,0,0)
		screen.print(12,30,"NinOS [VER : "..kernel.verOS.."]",0.7,bianco)
		cmd:blit()
		cmd:ins_com()
		PROG_ESCI()
		startbar:blit()
		mouse:blit()
		screen.flip()
	end
end
 
if thread:new(7,image.load("SYSTEM/SYSTEM32/PROGRAM/CMD/icona.png"),CMD_AVVIO_PROG)==false then bsod("Impossibile avviare thread per il programma") end