files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS")

function AVVIO_BROWSER_PROG()
	game.launch("SYSTEM/SYSTEM32/PROGRAM/Browser/browser.pbp")
end

thread:new(25,image.load("SYSTEM/SYSTEM32/PROGRAM/Browser/icona.png"),AVVIO_BROWSER_PROG)