CurrentTheme={}

function LoadTheme(nameTheme)
	local pathTheme=ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/Sistema.ini","themeName","default")
	pathTheme=kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/"..nameTheme.."/"..nameTheme..".NinOStheme"
	sfondo:init(pathTheme)
	CurrentTheme.systemColor1=color.new(tonumber(ini.read(pathTheme,"systemColor1_R",255)),tonumber(ini.read(pathTheme,"systemColor1_G",255)),tonumber(ini.read(pathTheme,"systemColor1_B",255)))
	CurrentTheme.systemColor2=color.new(tonumber(ini.read(pathTheme,"systemColor2_R",255)),tonumber(ini.read(pathTheme,"systemColor2_G",255)),tonumber(ini.read(pathTheme,"systemColor2_B",255)))
	ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","dinamicBackground",-1)
end

function LoadDefTheme()
	sfondo:init(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme")
	CurrentTheme.systemColor1=color.new(tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","systemColor1_R",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","systemColor1_G",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","systemColor1_B",255)))
	CurrentTheme.systemColor2=color.new(tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","systemColor2_R",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","systemColor2_G",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","systemColor2_B",255)))
	CurrentTheme.systemColor3=color.new(tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","systemColor3_R",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","systemColor3_G",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","systemColor3_B",255)))
	CurrentTheme.MenuBackColor=color.new(tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","MenuBackColor_R",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","MenuBackColor_G",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","MenuBackColor_B",255)))
	CurrentTheme.MenuBackColorHov=color.new(tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","MenuBackColorHov_R",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","MenuBackColorHov_G",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","MenuBackColorHov_B",255)))
	CurrentTheme.MenuBackColorItem=color.new(tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","MenuBackColorItem_R",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","MenuBackColorItem_G",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","MenuBackColorItem_B",255)))
	CurrentTheme.MenuBackColorItemHov=color.new(tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","MenuBackColorItemHov_R",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","MenuBackColorItemHov_G",255)),tonumber(ini.read(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/default/default.NinOStheme","MenuBackColorItemHov_B",255)))

	ini.write(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/CONF/desktop.ini","dinamicBackground",-1)
end

function CreateTheme()
end

function DeleteTheme(nameTheme)
	LoadDefTheme()
	files.delete(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/SFONDI/TEMI/"..nameTheme)
end

function EditTheme()
end

function InstallTheme()
end