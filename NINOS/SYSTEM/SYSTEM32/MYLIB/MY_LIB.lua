function draw_rect(x,y,w,h,c)
	draw.line(x-1,y,x+w+2,y,c)
	draw.line(x-1,y,x,y+h,c)
	draw.line(x+w+2,y,x+w+2,y+h,c)
	draw.line(x-1,y+h,x+w+2,y+h,c)
end

function draw_round_fillrect(posx,posy,width,height,round,color)
	draw.gradcircle(posx+round,posy+round,round,color,color,40)
	draw.gradcircle(posx+width-round,posy+round,round,color,color,40)
	draw.gradcircle(posx+round,posy+height-round,round,color,color,40)
	draw.gradcircle(posx+width-round,posy+height-round,round,color,color,40)
	draw.fillrect(posx+round,posy,width-2*round,height,color)
	draw.fillrect(posx,posy+round,round,height-2*round,color)
	draw.fillrect(posx+width-round,posy+round,round,height-2*round,color)
end

function draw_pixel(x,y,col)
	draw.line(x-1,y,x,y,col)
end

function img_resize(img,IMG_W,IMG_H)
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

function img_scale(img,per)
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

function img_rit_scal(img,per,X,Y,W,H)
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

function img_ritaglia(img,X,Y,W,H)
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