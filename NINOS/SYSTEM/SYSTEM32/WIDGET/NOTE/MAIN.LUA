local WIDGET_NOTE={
	img=image.load("SYSTEM/SYSTEM32/WIDGET/NOTE/note.png"),
	text=ini.read("SYSTEM/SYSTEM32/WIDGET/NOTE/config.ini","txt",""),
	pos={
		x=tonumber(ini.read("SYSTEM/SYSTEM32/WIDGET/NOTE/config.ini","POSX","")),
		y=tonumber(ini.read("SYSTEM/SYSTEM32/WIDGET/NOTE/config.ini","POSY","")),
		xt=nil,
		yt=nil
	},
	move=false
}

image.center(WIDGET_NOTE.img)

table.insert(desktop.WIDGET,function()
    if mouse:getx()>=WIDGET_NOTE.pos.x-25 and mouse:getx()<=WIDGET_NOTE.pos.x+25 and mouse:gety()>=WIDGET_NOTE.pos.y-25 and mouse:gety()<=WIDGET_NOTE.pos.y+25 then
        if buttons.held.cross and WIDGET_NOTE.move==false then
            WIDGET_NOTE.move=true
            WIDGET_NOTE.pos.xt=WIDGET_NOTE.pos.x
            WIDGET_NOTE.pos.yt=WIDGET_NOTE.pos.y
        elseif buttons.released.cross then
            if WIDGET_NOTE.pos.x+32>480 then 
                WIDGET_NOTE.pos.x=WIDGET_NOTE.pos.xt
                WIDGET_NOTE.pos.xt=nil
            end
            if WIDGET_NOTE.pos.y+32>247 then
                WIDGET_NOTE.pos.y=WIDGET_NOTE.pos.yt
                WIDGET_NOTE.pos.yt=nil
            end
            ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/WIDGET/NOTE/config.ini","POSX",WIDGET_NOTE.pos.x)
            ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/WIDGET/NOTE/config.ini","POSY",WIDGET_NOTE.pos.y)
            WIDGET_NOTE.move=false
		elseif buttons.start then
			local c = osk.init("","")
			if c~=nil then 
				WIDGET_NOTE.text=c
				ini.write("SYSTEM/SYSTEM32/WIDGET/NOTE/config.ini","txt",c)
			end
		end
    end
    image.blit(WIDGET_NOTE.img,WIDGET_NOTE.pos.x,WIDGET_NOTE.pos.y)
	screen.print(WIDGET_NOTE.pos.x,WIDGET_NOTE.pos.y,WIDGET_NOTE.text,0.7,nero)
	if SPOSTA==true then
        WIDGET_NOTE.pos.x=mouse:getx() WIDGET_NOTE.pos.y=mouse:gety()
    end
end)
