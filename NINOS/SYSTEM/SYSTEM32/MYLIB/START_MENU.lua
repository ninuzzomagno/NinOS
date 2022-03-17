startmenu={}

function startmenu:init()
	self.restart_shutdownBTN=MV_new(0,178,0,0,CurrentTheme.MenuBackColor,CurrentTheme.MenuBackColorHov,0.6,CurrentTheme.MenuBackColorItem,CurrentTheme.MenuBackColorItemHov,true,true,3)
	self.restart_shutdownBTN:add("Spegni",false,image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/spegnih.png"))
	self.restart_shutdownBTN:add("Riavvia",false,image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/load.png"))
	self.restart_shutdownBTN:add("XMB",false,image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/load.png"))
	self.restart_shutdownBTN:connect(1,function() kernel.spegni() end)
	self.restart_shutdownBTN:connect(2,function() kernel.riavvia() end)
	self.restart_shutdownBTN:connect(3,function() kernel.xmb() end)
	self.listPROG=files.listdirs(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM")

end

function startmenu:blit()
	while true do
       	screen.clear(CurrentTheme.MenuBackColor)
       	buttons.read()
		image.blit(imgpr,5,5)
		--usbBTN:blit()
		screen.print(60,26,string.sub(os.getdate(),17,-4),0.8)
    	screen.print(60,5,string.sub(os.getdate(),4,14),0.8)
		self.restart_shutdownBTN:blit()
		if startbar.BT_start:isClicked() then
			return
		end
		startbar.BT_start:blit()
        mouse:blit()
        screen.flip()
    end
end

function HOME()
	local usbicon=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/usbicon.png")
	local usbBTN=BT_IMG_new(30,80,usbicon,usbicon)
	usbBTN:connect("pressed",function()
		if kernel.usb.active==false then 
			if kernel.usb.mode=="umd" then usb.mstick()
			elseif kernel.usb.mode=="ms" then usb.umd()
			elseif kernel.usb.mode=="fl0" then usb.flash0()
			end
			kernel.usb.active=true
		else
			if usb.isactive() and usb.isconnected()==false then usb.stop() kernel.usb.active=false
			elseif usb.isconnected() then notification_menu:add_not("Sistema",nil,nil,"E' stata avviata la connessione usb",0)
			end
		end
 	end)
	return startmenu:blit()
end