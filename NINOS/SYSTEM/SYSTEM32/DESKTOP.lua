local pos=0
local POS=480
--PSPbar:blit()
function DESKTOP_blit()
	if DESKTOP<MAX_DESKTOP and buttons.held.r then
		pos-=10
		POS-=10
		desktop:blit(pos)
		desktop:blit(POS)
		draw.gradrect(470,0,10,272,color.new(0,0,0,0),CurrentTheme.systemColor2,color.new(0,0,0,0),CurrentTheme.systemColor2)
		if buttons.released.r then
			pos=0 POS=480 
		end
		if(POS==0) then
			DESKTOP=2
		end
	elseif DESKTOP~=1 and DESKTOP==MAX_DESKTOP and buttons.held.l then
		pos+=10
		POS+=10
		desktop:blit(pos)
		desktop:blit(POS)
		draw.gradrect(0,0,10,272,CurrentTheme.systemColor2,color.new(0,0,0,0),CurrentTheme.systemColor2,color.new(0,0,0,0))
		if buttons.released.l then
			pos=-480 POS=0 
		end
		if(pos==0) then
			DESKTOP=1
		end
	else
		desktop:blit()
	end
end

while true do
	buttons.read()
	DESKTOP_blit()
	if buttons.select then COPY_MAN:new("ms0:/ISO/BLEACH.CSO","ms0:/",false) end
	screen.flip()
end