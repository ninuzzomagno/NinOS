function PAINT_UNISCI_IMG(img1,img2)
	local img_new=image.new(image.getw(img1)+image.getw(img2),1,nero)
end

function PAINT_UPSCALE(IMG,per)
	local W=image.getw(IMG)
	local H=image.geth(IMG)
	local img=image.new(W*per,H*per,nero)
	local COLORE=nil
	for i=0,W do 
		for y=0,H do
			COLORE=image.pixel(IMG,i,y)
			for z=1,per do
				image.pixel(img,z,y,COLORE)
			end
		end
	end
	return img
end

function PAINT_COPY_IMG(img1,img2,posx,posy)
	local IMG1_W = image.getw(img1)
	local IMG1_H = image.geth(img1)
	local IMG2_W=image.getw(img2)
	local IMG2_H=image.geth(img2)
	local IMG3_W=nil
	local IMG3_H=nil
	if IMG1_W > IMG2_W then IMG3_W=IMG1_W 
	else IMG3_W=IMG1_W end
	if IMG1_H > IMG2_H then IMG3_H=IMG1_H
	else IMG3_H=IMG1_H end
	local img3=image.new(IMG3_W,IMG3_H,nero)
	for i=1,IMG1_W do
		for y=1,IMG1_H do
			image.pixel(img3,i,y,image.pixel(img1,i,y))
		end
	end
	for i=1,IMG2_W do
		for y=1,IMG2_H do
			image.pixel(img3,posx+i,posy+y,image.pixel(img2,i,y))
		end
	end
	return img3
end

function PAINT_CHANGE_SELCOL(img,COL1,COL2)
	local IMG_W=image.getw(img)
	local IMG_H=image.geth(img)
	for i=1,IMG_W do
		for y=1,IMG_H do
			if image.pixel(img,i,y)== COL1 then image.pixel(img,i,y,COL2) end
		end
	end
	return img
end

function PAINT_FLIP_V(img)
	local IMG_W=image.getw(img)
	local IMG_H=image.geth(img)
	local img_new=image.new(IMG_W,IMG_H,nero)
	local COLORE=nil
	for i=0,IMG_W do
		for y=0,IMG_H do
			COLORE=image.pixel(img,i,IMG_H-y-1)
			image.pixel(img_new,i,y,COLORE)
		end
	end
	return img_new
end

function PAINT_FLIP_H(img)
	local IMG_W=image.getw(img)
	local IMG_H=image.geth(img)
	local img_new=image.new(IMG_W,IMG_H,nero)
	local COLORE=nil
	for i=0,IMG_W do
		for y=0,IMG_H do
			COLORE=image.pixel(img,IMG_W-i-1,y)
			image.pixel(img_new,i,y,COLORE)
		end
	end
	return img_new
end

function IMG_RITAGLIA(img,X,Y,W,H)
	local img_new=image.new(W,H,nero)
	local COLORE=nil
	for j=Y,Y+H do 
		for i=X,X+W do
			COLORE=image.pixel(img,i,j)
			image.pixel(img_new,i-X,j-Y,COLORE)
		end
	end
	return img_new
end

function PAINT_MATITA(img,x,y,COLORE)
	image.pixel(img,x,y,COLORE)
	return img
end

function PAINT_GOMMA(img,x,y,DIM)
	local W=image.getw(img)
	local H=image.geth(img)
	for i=x,x+DIM do
		for j=y,y+DIM do
			image.pixel(img,i,j,color.new(255,255,255,255))
		end
	end
	image.pixel(img,x,y,bianco)
	return img
end

function PAINT_PENNELLO(img,x,y,DIM,COLORE)

end

function IMG_RESIZE(img,IMG_W,IMG_H)
	local img_new=image.new(IMG_W,IMG_H,nero)
	local w=100*IMG_W/image.getw(img)
	local h=100*IMG_H/image.geth(img)
	w=100/w
	h=100/h
	for i=0,IMG_W do 
		for y=0,IMG_H do
			COLORE=image.pixel(img,i*w,y*h)
			image.pixel(img_new,i,y,COLORE)
		end
	end
	return img_new
end

function IMG_SCALE(img,per)
	local W=image.getw(img)/per
	local H=image.geth(img)/per
	local img_new=image.new(W,H,nero)
	local COLORE=nil
	for i=0,W do 
		for y=0,H do
			COLORE=image.pixel(img,i*per,y*per)
			image.pixel(img_new,i,y,COLORE)
		end
	end
	return img_new
end

function IMG_RIT_SCA(img,per,X,Y,W,H)
	W=W/per
	H=H/per
	local img_new=image.new(W,H,nero)
	local COLORE=nil
	for i=0,W do
		for y=0,H do
			COLORE=image.pixel(img,i*per+X,y*per+Y)
			image.pixel(img_new,i,y,COLORE)
		end
	end
	return img_new
end

function color_selector()

	local obj={
	}

	function obj:rSl_init(x,y,w,col,colC,v_ini)
		self.rSl=SLIDER_new(x,y,w,col,colC,0,255,v_ini)
	end

	function obj:gSl_init(x,y,w,col,colC,v_ini)
		self.gSl=SLIDER_new(x,y,w,col,colC,0,255,v_ini)
	end

	function obj:bSl_init(x,y,w,col,colC,v_ini)
		self.bSl=SLIDER_new(x,y,w,col,colC,0,255,v_ini)
	end

	function obj:risC_init(X,Y,W,H)
		self.rect={
			x=X,
			y=Y,
			w=W,
			h=H
		}
	end

	function obj:blit()
		draw.fillrect(self.rect.x,self.rect.y,self.rect.w,self.rect.h,color.new(self.rSl:getVal(),self.gSl:getVal(),self.bSl:getVal()))
		self.rSl:blit()
		screen.print(self.rSl.x+self.rSl.w+15,self.rSl.y-5,self.rSl:getVal(),0.6,rosso)
		self.gSl:blit()
		screen.print(self.gSl.x+self.gSl.w+15,self.gSl.y-5,self.gSl:getVal(),0.6,verde)
		self.bSl:blit()
		screen.print(self.bSl.x+self.bSl.w+15,self.bSl.y-5,self.bSl:getVal(),0.6,color.new(0,0,255))
		return color.new(self.rSl:getVal(),self.gSl:getVal(),self.bSl:getVal())
	end

	return obj

end