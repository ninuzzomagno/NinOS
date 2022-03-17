function COPY_MAN_main()

	while true do
		screen.clear(bianco)
		buttons.read()

		for i=1,COPY_MAN.transferProcess do
			screen.print(51,30+70*(i-1),files.nopath(COPY_MAN.TransferPROC[i].pI),0.7,nero)
			screen.print(51,60+70*(i-1),"Dim: "..(COPY_MAN.TransferPROC[i].size/1048576).." Mb",0.5,nero)
			screen.print(51,70+70*(i-1),"Vel: "..(COPY_MAN.TransferPROC[i].buffer/1024).." kb/s",0.5,nero)
			COPY_MAN.TransferPROC[i].PLAY_BTN:blit()
			COPY_MAN.TransferPROC[i].ANNULLA_BTN:blit()
			if COPY_MAN.TransferPROC[i].pausa==false then
				if COPY_MAN:copy(i)==1 then
					prbar(47,45+70*(i-1),258,15,COPY_MAN.TransferPROC[i].scritti,COPY_MAN.TransferPROC[i].size,color.new(0,255,0),color.new(240,240,240),false)
					if COPY_MAN.transferProcess>1 then 
						for y=1,COPY_MAN.transferProcess do
							COPY_MAN.TransferPROC[y].buffer=1024*24/(COPY_MAN.transferProcess-1)
						end
					end
					table.remove(COPY_MAN.TransferPROC,i)
					COPY_MAN.transferProcess-=1
					break
				end
			else
				prbar(47,45+70*(i-1),258,15,COPY_MAN.TransferPROC[i].scritti,COPY_MAN.TransferPROC[i].size,color.new(255,191,24),color.new(240,240,240),false)
			end
		end

		COPY_MAN.CHIUDI:blit()
		COPY_MAN.RIDUCI:blit()

		if MSG_sys:blit()==__MBOK then
			for i=1,COPY_MAN.transferProcess do
				COPY_MAN.TransferPROC[COPY_MAN.transferProcess-(i-1)].NEW:close()
				COPY_MAN.TransferPROC[COPY_MAN.transferProcess-(i-1)].OLD:close()
				if COPY_MAN.TransferPROC[COPY_MAN.transferProcess-(i-1)].move==true then
					files.delete(COPY_MAN.TransferPROC[COPY_MAN.transferProcess-(i-1)].pO)
				end
				table.remove(COPY_MAN.TransferPROC,COPY_MAN.transferProcess-(i-1))
			end
			COPY_MAN.TransferPROC=nil
			COPY_MAN.transferProcess=0
			COPY_MAN.CHIUDI=nil
			COPY_MAN.RIDUCI=nil
			thread:destroy(10,1)
		end

		startbar:blit()
		mouse:blit()
		screen.flip()

		if COPY_MAN.transferProcess==0 then thread:destroy(10,1) end

	end
end

thread:new(10,COPY_MAN.icon,COPY_MAN_main)