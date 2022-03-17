files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS")

function BLENDER_CONTROL(cam)
	if buttons.held.l and buttons.held.cross then
		CAM_POS.z=CAM_POS.z+2
	elseif buttons.held.r and buttons.held.cross then
		CAM_POS.z=CAM_POS.z-2
	elseif buttons.held.l then
		CAM_POS.x=CAM_POS.x-2
	elseif buttons.held.r then
		CAM_POS.x=CAM_POS.x+2
	end
	cam3d.position(cam,CAM_POS)
	cam3d.set(cam)
end

function BLENDER_AVVIO_PROG()

	amg.init()
	amg.quality(__8888)
	local sfondo=image.load("SYSTEM/SYSTEM32/PROGRAM/Blender/blender.png")
	local PATH=nil
	local obj=nil
	local cam=cam3d.new()
	local CAM_POS={}
	CAM_POS.x=0
	CAM_POS.y=0
	CAM_POS.z=-10
	local OBJ_POS={}
	OBJ_POS.x=0
	OBJ_POS.y=0
	OBJ_POS.z=0
	if blender_path_file~=nil then 
		obj=model3d.load(PATH)
		model3d.position(obj,model3d.countobj(obj),OBJ_POS)
		blender_path_file=nil
	end
	
	local m=MENU(6,25,color.new(98,98,98),color.new(76,76,76),bianco,bianco,0.6,2)
	m:add("File")
	m:submenu(1)
	m:add_s("Apri",1)
	m:connect(1,1,function()
		PATH=FILE_DIALOG(__FDOPFILE,"objO")
		if PATH~=nil then 
			obj=model3d.load(PATH)
			model3d.position(obj,model3d.countobj(obj),OBJ_POS)
		end
	end)

	while true do
		screen.clear(nero)
		buttons.read()
		amg.begin()
		if obj~=nil then model3d.render(obj,0) end
		BLENDER_CONTROL(cam)
		amg.update()
		amg.mode2d(1)
		image.blit(sfondo,0,0)
		screen.print(15,233,"Camera : [ X : "..CAM_POS.x..", Y : "..CAM_POS.y..", Z : "..CAM_POS.z.."]",0.7,bianco)
		screen.print(240,233,"Oggetto : [ X : "..OBJ_POS.x..", Y : "..OBJ_POS.y..", Z : "..OBJ_POS.z.."]",0.7,bianco)
		m:blit()
		PROG_ESCI()
		startbar:blit()
		mouse:blit()
		screen.flip()
		amg.mode2d(0)
	end
end

--BLENDER_AVVIO_PROG()
thread:new(10,image.load("SYSTEM/SYSTEM32/PROGRAM/Blender/icona.png"),BLENDER_AVVIO_PROG)