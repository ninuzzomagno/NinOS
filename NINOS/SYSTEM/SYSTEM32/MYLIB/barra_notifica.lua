notification_menu={
	show=false,
	height=247,
	width=150,
	NOTIFICHE=0,
	INI=1,
	MAX=0,
	list_not={}
}

function notification_menu:add_timer(titolo,timer)
	self.NOTIFICHE+=1
	if self.NOTIFICHE<=3 then self.MAX=self.NOTIFICHE else self.MAX=3 end
	self.list_not[self.NOTIFICHE]={}
	self.list_not[self.NOTIFICHE].title=titolo
	self.list_not[self.NOTIFICHE].TIMER=timer
end

function notification_menu:add_not(titolo,IMG,ximg,text,xtxt,FUN)
	self.NOTIFICHE+=1
	if self.NOTIFICHE<=3 then self.MAX=self.NOTIFICHE else self.MAX=3 end
	self.list_not[self.NOTIFICHE]={}
	self.list_not[self.NOTIFICHE].title=titolo
	self.list_not[self.NOTIFICHE].img=IMG
	self.list_not[self.NOTIFICHE].x_img=ximg
	self.list_not[self.NOTIFICHE].txt=text
	self.list_not[self.NOTIFICHE].x_txt=xtxt
	self.list_not[self.NOTIFICHE].fun=FUN
end

function NOTIFICATION_MENU()
	if notification_menu.show==true then 
		notification_menu.show=false
	else 
		notification_menu.show=true
	end
end

function notification_menu:NOThover(a)
	if mouse:getx()>=340 and mouse:getx()<=470 and mouse:gety()>=25+70*(a-1) and mouse:gety()<=25+70*(a-1)+67 then
		return true
	end
	return false
end

function notification_menu:blit()
	if self.show==true then
		draw.fillrect(330,0,self.width,self.height,color.new(105,105,105))
		if mouse:getx()>=330 and mouse:getx()<=480 and mouse:gety()>=0 and mouse:gety()<=247 and buttons.circle then self.show=false return end
		if self.NOTIFICHE==0 then screen.print(340,5,"Nessuna notifica",0.6,bianco)
		else
			local a=1
			screen.print(340,5,"Hai "..self.NOTIFICHE.." notifiche",0.6,bianco)
			for i=self.INI,self.MAX do
				draw.fillrect(340,25+70*(a-1),130,17,nero)
				draw.fillrect(340,42+70*(a-1),130,50,rosso)
				screen.print(400-screen.textwidth(self.list_not[i].title,0.6)/2,26+70*(a-1),self.list_not[i].title,0.6,bianco)
				if self.list_not[i].img~=nil then image.blit(self.list_not[i].img,345+self.list_not[i].x_img,45+70*(a-1)) end
				if self.list_not[i].txt~=nil then screen.print(345+self.list_not[i].x_txt,42+70*(a-1),self.list_not[i].txt,0.5,bianco,color.new(0,0,0,0),__ALEFT,110-self.list_not[i].x_txt) end
				if self.list_not[i].TIMER~=nil then screen.print(345,42+70*(a-1),self.list_not[i].TIMER:time(),0.6,bianco) end
				if self:NOThover(a) and buttons.cross then 
					if self.list_not[i].fun~=nil then self.list_not[i]:fun() end
					if self.NOTIFICHE>1 and i~=self.NOTIFICHE then
						self.list_not[i+1].title=self.list_not[i].title
						self.list_not[i+1].img=self.list_not[i].img
						self.list_not[i+1].x_img=self.list_not[i].x_img
						self.list_not[i+1].txt=self.list_not[i].txt
						self.list_not[i+1].x_txt=self.list_not[i].x_txt
						self.list_not[i+1].fun=self.list_not[i].fun
						self.list_not[i+1].TIMER=self.list_not[i].TIMER
					end
					table.remove(self.list_not[i])
					self.NOTIFICHE-=1
					self.INI=1
					if self.NOTIFICHE<=3 then self.MAX=self.NOTIFICHE else self.MAX=3 end
					return
				end
				if a==self.MAX then a=1 else a+=1 end
			end
			if mouse:getx()>340 and mouse:getx()<=480 and mouse:gety()>0 and mouse:gety()<247 then
				if buttons.r and self.MAX+1<=self.NOTIFICHE then self.INI+=1 self.MAX+=1
				elseif buttons.l and self.INI-1 > 0 then self.INI-=1 self.MAX-=1 end 
			end
		end
	end
end