m=image.load("SYSTEM/SYSTEM32/ICONE/mouse.png")
vel=ini.read("SYSTEM/SYSTEM32/CONF/Sistema.ini","velocita","5")
x=0 y=0
while true do
	buttons.read()
	screen.clear(color.new(0,0,0))
	local analogX=buttons.analogx
	local analogY=buttons.analogy
	if analogX>20 then 
		x=x+(vel*analogX/128)
	elseif analogX<-20 then
		x=x-(vel*(-analogX)/128)
	end
	if analogY<-20 then
		y=y-(vel*(-analogY)/128)
	elseif analogY>20 then
		y=y+(vel*analogY/128)
	end
	if x+image.getw(m) > 485 then
		x=485-image.getw(m)
	elseif x < 0 then
		x=0
	end
	if y+image.geth(m)> 282 then
		y=282-image.geth(m)
	elseif y < 0  then
		y=0
	end
	image.blit(m,x,y)
	screen.print(0,0,x,1,color.new(255,0,0))
	screen.print(200,0,y,1,color.new(255,0,0))
	screen.print(0,200,buttons.analogx.."        "..buttons.analogy,1,color.new(255,0,0))
	screen.flip()
end