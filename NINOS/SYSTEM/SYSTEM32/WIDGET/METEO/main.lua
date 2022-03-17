local METEO_ICO=image.load("SYSTEM/SYSTEM32/WIDGET/METEO/meteo.png")
image.center(METEO_ICO)
local METEO_TEMP_BAT=10--batt.temp()
local pos={
	x=tonumber(ini.read("SYSTEM/SYSTEM32/WIDGET/METEO/config.ini","POSX","")),
	y=tonumber(ini.read("SYSTEM/SYSTEM32/WIDGET/METEO/config.ini","POSY","")),
	xt=nil,
	yt=nil
}
local SPOSTA=false

table.insert(desktop.WIDGET,function()
	if METEO_TEMP_BAT>=-20 and METEO_TEMP_BAT<=4 then
		image.blit(METEO_ICO,pos.x,pos.y,232,0,74,59)
		screen.print(pos.x-(screen.textwidth(METEO_TEMP_BAT,0.8))/2,pos.y,METEO_TEMP_BAT,0.8,color.new(0,155,236))
	elseif METEO_TEMP_BAT>=5 and METEO_TEMP_BAT<=12 then
		image.blit(METEO_ICO,pos.x,pos.y,158,0,80,59)
		screen.print(pos.x-(screen.textwidth(METEO_TEMP_BAT,0.8))/2,pos.y,METEO_TEMP_BAT,0.8,color.new(0,155,236))
	elseif METEO_TEMP_BAT>=13 and METEO_TEMP_BAT<=19 then
		image.blit(METEO_ICO,pos.x,pos.y,306,0,94,64)
		screen.print(pos.x-(screen.textwidth(METEO_TEMP_BAT,0.8))/2,pos.y,METEO_TEMP_BAT,0.8,color.new(255,117,020))
	elseif METEO_TEMP_BAT>=20 and METEO_TEMP_BAT<=23 then
		image.blit(METEO_ICO,pos.x,pos.y,64,0,94,64)
		screen.print(pos.x-(screen.textwidth(METEO_TEMP_BAT,0.8))/2,pos.y,METEO_TEMP_BAT,0.8,color.new(255,117,020))
	elseif METEO_TEMP_BAT>=24 then
		image.blit(METEO_ICO,pos.x,pos.y,0,0,64,64)
		screen.print(pos.x-(screen.textwidth(METEO_TEMP_BAT,0.8))/2,pos.y,METEO_TEMP_BAT,0.8,color.new(255,117,020))
	end
	if mouse:getx()>=pos.x-25 and mouse:getx()<=pos.x+25 and mouse:gety()>=pos.y-32 and mouse:gety()<=pos.y+32 then
		if buttons.held.cross and SPOSTA==false then
			SPOSTA=true
			pos.xt=pos.x
			pos.yt=pos.y
		elseif buttons.released.cross then
			if pos.x+47>480 then 
				pos.x=pos.xt
				pos.xt=nil
			end
			if pos.y+32>247 then
				pos.y=pos.yt
				pos.yt=nil
			end
			ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/WIDGET/METEO/config.ini","POSX",pos.x)
			ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/WIDGET/METEO/config.ini","POSY",pos.y)
			SPOSTA=false
		end
	end
	if SPOSTA==true then
		pos.x=mouse:getx() pos.y=mouse:gety()
	end
end)