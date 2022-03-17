files.cdir(kernel.PATH_INI.."PSP/GAME/NINOS")

local PLAY=image.load("SYSTEM/SYSTEM32/ICONE/play.png")
local PAUSA=image.load("SYSTEM/SYSTEM32/ICONE/pausa.png")
local CHANGE=image.load("SYSTEM/SYSTEM32/ICONE/avanti.png")
local LOOP_N=image.load("SYSTEM/SYSTEM32/ICONE/loop.png")
local LOOP_Y=image.load("SYSTEM/SYSTEM32/ICONE/looph.png")

function controlSong(MP3,TIMER)
    if buttons.square then
        if sound.endstream(MP3.song)==false then
            sound.pause(MP3.song,-1)
            if sound.playing(MP3.song) then
                TIMER:start()
            else
                TIMER:stop()
            end
        end
    elseif buttons.select then
        sound.loop(MP3.song)
    end
    --if sound.endstream(MP3.song) and sound.looping(MP3.song)==true then
    --    TIMER:reset(0)
    --elseif sound.endstream(MP3.song) and sound.looping(MP3.song)==false then 
    --    TIMER:stop()
    --    TIMER:reset(0)
    --end
end

function creaTab(path)
    local t=files.listfiles(path)--kernel.SYSTEM_PATH_MUSIC)
	MUSIC_PLAYER={
		index=1,
		list={},
		song=nil
	}
    local listDir=Vlist_new(path,6,45,468,3,true,true,nero,rosso)
    for i=1,#t do
		MUSIC_PLAYER.list[i]={}
		MUSIC_PLAYER.list[i].name=t[i].name
		MUSIC_PLAYER.list[i].size=t[i].size
		MUSIC_PLAYER.list[i].path=t[i].path
        if t[i].ext=="mp3" then 
            local ID3=sound.getid3(t[i].path)
            MUSIC_PLAYER.list[i].cover=ID3.cover
            MUSIC_PLAYER.list[i].artista=ID3.artist
        else
            MUSIC_PLAYER.list[i].cover=nil
            MUSIC_PLAYER.list[i].artista=nil
        end
    end
    return listDir
end
 
function PLAYER_AVVIO_PROG()
	local sfondo=image.load("SYSTEM/SYSTEM32/PROGRAM/Player/player.jpg")
    local menu=MENU(6,26,rosso,color.new(240,0,0),bianco,bianco,0.6,2)
    menu:add("File")
    menu:add("Playlist")
    menu:submenu(1)
    menu:submenu(2)
    menu:add_s("Apri file",1)
    menu:add_s("Apri cartella",1)
    menu:add_s("Modifica ID3 Tag",1,true)
    menu:add_s("Gestisci playlist",2,true)
	menu:add_s("Riproduci playlist",2,true)

	local TIMER=timer.new(0)
	TIMER:stop()
	local listaDir=creaTab("ms0:/MUSIC")
	local ris=nil

	local Table=NEW_table(6,90,468,130,color.new(231,231,231),color.new(249,109,120),0.7,0.6,bianco,rosso,nero,MUSIC_PLAYER.list,7)
	Table:addCol("Titolo","name")
	Table:addCol("Artista","artista")

	while true do
	buttons.read()
        image.blit(sfondo,0,0)
        if MUSIC_PLAYER.song~=nil then 
            local TIME=math.floor(TIMER:time()/1000)
            screen.print(20,228,TimeSecTOMin(math.floor(TIME)),0.6,nero)
            screen.print(280,228,MUSIC_PLAYER.time,0.6,nero)
            prbar(68,231,200,8,TIME,MUSIC_PLAYER.timeSec,rosso,bianco,false)
            if sound.playing(MUSIC_PLAYER.song) then
                image.blit(PAUSA,400,221)
            else
                image.blit(PLAY,400,221)
            end
            if sound.looping(MUSIC_PLAYER.song) then
                image.blit(LOOP_Y,350,224)
            else
                image.blit(LOOP_N,350,224)
            end
            controlSong(MUSIC_PLAYER,TIMER)
        end
        ris=Table:blit()
        if ris~=nil then 
            if ris~=-1 then 
                if MUSIC_PLAYER.song~=nil then
                    sound.stop(MUSIC_PLAYER.song)
                    MUSIC_PLAYER.song=nil
                    TIMER:stop()
                    TIMER:reset(0)
                end
                MUSIC_PLAYER.timeSec=getMp3TimeSec(MUSIC_PLAYER.list[ris].path)
                MUSIC_PLAYER.time=TimeSecTOMin(MUSIC_PLAYER.timeSec)
                MUSIC_PLAYER.song=sound.load(MUSIC_PLAYER.list[ris].path)
                sound.play(MUSIC_PLAYER.song)
				MUSIC_PLAYER.index=ris
                TIMER:start()
            else 
                if MUSIC_PLAYER.song~=nil then
                    sound.stop(MUSIC_PLAYER.song)
                    MUSIC_PLAYER.song=nil
                    TIMER:stop()
                    TIMER:reset(0)
                end
            end
        end
        PROG_ESCI()
        listaDir:blit()
        if listaDir:widgetHover() and buttons.circle then 
            if listaDir.path~=kernel.PATH_INI then
                local NOPATH=files.nopath(listaDir.path)
                local PATH=string.sub(listaDir.path,1,-(1+string.len(NOPATH)))
                if PATH~=kernel.PATH_INI then
                    PATH=string.sub(PATH,1,-2)
                end
                listDir=Vlist_new(PATH,6,45,468,3,true,true,nero,rosso)
            end
        end
        if listaDir.SEL~=0 then 
            listaDir=creaTab(files.listdirs(listaDir.path)[listaDir.SEL]["path"]) 
            Table=NEW_table(6,90,468,130,color.new(231,231,231),color.new(249,109,120),0.7,0.6,bianco,rosso,nero,tab,7)
            Table:addCol("Titolo","name")
            Table:addCol("Artista","artista")
        end
        menu:blit()
        startbar:blit()
        mouse:blit()
        screen.flip()
        if buttons.select then return end
    end
end
PLAYER_AVVIO_PROG()
if thread:new(2,image.load("SYSTEM/SYSTEM32/PROGRAM/Player/icona.png"),PLAYER_AVVIO_PROG)==false then 
    MSG:type("Errore","Impossibile creare thread per avviare il programma",__MBOKCANC,__MBICONERROR) 
    MSG:connect(__MBOK,function()
        dofile(kernel.PATH_INI.."PSP/GAME/NINOS/SYSTEM/SYSTEM32/PROGRAM/Player/main.lua")
    end)
end
