function WINDOW_new(color,icon,txt,colt) 
	local WIN={}

	if type(icon)=="string" then
		WIN.icon=image.load(icon)
	else
		WIN.icon=icon
	end

	local w=image.getrealw(WIN.icon)
	if w>22 then
		image.scale(WIN.icon,100*22/w)
	end

	WIN.col=color
	WIN.title=txt
	WIN.coltxt=colt

	function WIN:blit(fullscreen)
		draw.fillrect(0,0,480,26,self.col)
		image.blit(self.icon,6,2)
		screen.print(30,10,self.title,0.8,self.coltxt)
		PROG_ESCI()
		if fullscreen==false then
			draw.fillrect(0,26,6,221,self.col)
			draw.fillrect(474,26,6,221,self.col)
		end
	end

	return WIN

end