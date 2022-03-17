procBack={}

--n = nome processo
--r = running
--f = funzione

function procBack:new(n,r,f)
    local max=table.getn(procBack)
    procBack[max+1]={}
	procBack[max+1].run=r
    procBack[max+1].name=n
    procBack[max+1].fun=coroutine.create(f)
end

function procBack:run()
    local max=table.getn(procBack)
    for i=1,max do
        if procBack[i].run==true then
            coroutine.resume(procBack[i].fun)
        end
    end
end

function procBack:PauseResume(n)  
    local max=table.getn(procBack)
    for i=1,max do
        if procBack[i].name==n then
            if procBack[i].run==true then
                procBack[i].run=false
            else procBack[i].run=true end
            return
        end
    end
end

function procBack:delete(n)
    local max=table.getn(procBack)
    for i=1,max do
        if procBack[i].name==n then
            table.remove(procBack,i)
            return
        end
    end
end

function procBack:init()
    if hw.getmodel()~="Go" then
        UMD={
            icon=image.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/ICONE/iconUMD.png"),
            posx=0,
            sound1=sound.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/AUDIO/soundPlug.mp3"),
            sound2=sound.load(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/AUDIO/soundPlugO.mp3"),
            TIME=0,
            present=not(umd.present()),
            T=timer.new(0)
        }

        sound.vol(UMD.sound1,100)
        sound.vol(UMD.sound2,100)
        self:new("umd",true,function()
            while true do
                UMD_read()
                coroutine.yield()
            end
        end)
    end
end
