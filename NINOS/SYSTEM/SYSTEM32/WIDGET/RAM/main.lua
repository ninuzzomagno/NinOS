local RAM_ICO=image.load("SYSTEM/SYSTEM32/WIDGET/RAM/ram.png")
image.center(RAM_ICO)
local pos={
	x=tonumber(ini.read("SYSTEM/SYSTEM32/WIDGET/RAM/config.ini","POSX","")),
	y=tonumber(ini.read("SYSTEM/SYSTEM32/WIDGET/RAM/config.ini","POSY","")),
	xt=nil,
	yt=nil
}
local RAM_FREE=nil
local posTemp
local SPOSTA=false

table.insert(desktop.WIDGET,function()
	RAM_FREE=math.floor((os.totalram()-os.ram())*100/os.totalram())
	image.blit(RAM_ICO,pos.x,pos.y)
	if RAM_FREE<40 then 
		screen.print(pos.x-(screen.textwidth(RAM_FREE.." %",0.7))/2,pos.y,RAM_FREE.." %",0.7,verde)
	elseif RAM_FREE>70 then
		screen.print(pos.x-(screen.textwidth(RAM_FREE.." %",0.7))/2,pos.y,RAM_FREE.." %",0.7,rosso)
	else
		screen.print(pos.x-(screen.textwidth(RAM_FREE.." %",0.7))/2,pos.y,RAM_FREE.." %",0.7,color.new(255,255,0))
	end
	if mouse:getx()>=pos.x-25 and mouse:getx()<=pos.x+25 and mouse:gety()>=pos.y-25 and mouse:gety()<=pos.y+25 then
		if buttons.held.cross and SPOSTA==false then
			SPOSTA=true
			pos.xt=pos.x
			pos.yt=pos.y
		elseif buttons.released.cross then
			if pos.x+32>480 then 
				pos.x=pos.xt
				pos.xt=nil
			end
			if pos.y+32>247 then
				pos.y=pos.yt
				pos.yt=nil
			end
			ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/WIDGET/RAM/config.ini","POSX",pos.x)
			ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/WIDGET/RAM/config.ini","POSY",pos.y)
			SPOSTA=false
		elseif buttons.circle then
			collectgarbage()
		end
	end
	if SPOSTA==true then
		pos.x=mouse:getx() pos.y=mouse:gety()
	end
end)
