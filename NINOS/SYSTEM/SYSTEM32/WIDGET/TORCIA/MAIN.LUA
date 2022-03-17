local WIDGET_TORCIA={
	img=image.load("SYSTEM/SYSTEM32/WIDGET/TORCIA/torcia.png"),
	pos={
		x=tonumber(ini.read("SYSTEM/SYSTEM32/WIDGET/TORCIA/config.ini","POSX","")),
		y=tonumber(ini.read("SYSTEM/SYSTEM32/WIDGET/TORCIA/config.ini","POSY","")),
		xt=nil,
		yt=nil
	},
	move=false
}

image.center(WIDGET_TORCIA.img)

procBack:new("torcia",false,function()
    while true do
       screen.clear(bianco)
       coroutine.yield()
    end
end)

table.insert(desktop.WIDGET,function()
    if mouse:getx()>=WIDGET_TORCIA.pos.x-25 and mouse:getx()<=WIDGET_TORCIA.pos.x+25 and mouse:gety()>=WIDGET_TORCIA.pos.y-25 and mouse:gety()<=WIDGET_TORCIA.pos.y+25 then
        if buttons.held.cross and WIDGET_TORCIA.move==false then
            WIDGET_TORCIA.move=true
            WIDGET_TORCIA.pos.xt=WIDGET_TORCIA.pos.x
            WIDGET_TORCIA.pos.yt=WIDGET_TORCIA.pos.y
        elseif buttons.released.cross then
            if WIDGET_TORCIA.pos.x+32>480 then 
                WIDGET_TORCIA.pos.x=WIDGET_TORCIA.pos.xt
                WIDGET_TORCIA.pos.xt=nil
            end
            if WIDGET_TORCIA.pos.y+32>247 then
                WIDGET_TORCIA.pos.y=WIDGET_TORCIA.pos.yt
                WIDGET_TORCIA.pos.yt=nil
            end
            ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/WIDGET/TORCIA/config.ini","POSX",WIDGET_TORCIA.pos.x)
            ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/WIDGET/TORCIA/config.ini","POSY",WIDGET_TORCIA.pos.y)
            WIDGET_TORCIA.move=false
       end
    end
    if buttons.start then procBack:PauseResume("torcia") end
    image.blit(WIDGET_TORCIA.img,WIDGET_TORCIA.pos.x,WIDGET_TORCIA.pos.y)
    if SPOSTA==true then
        WIDGET_TORCIA.pos.x=mouse:getx() WIDGET_TORCIA.pos.y=mouse:gety()
    end
end)
