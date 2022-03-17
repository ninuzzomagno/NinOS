SplitScreen={
	progActiveSide=nil,   --destra=false sinistra=true
	progLeft=false,
	progRight=false
}

function SplitScreen:split(index)
	if self.ProgActiveSide==nil or self.ProgActiveSide==true then
		self.progLeft=true
		thread.lista[DESKTOP][index].split=0
	else	
		self.progRight=true
		thread.lista[DESKTOP][index].split=0
	end
end

function SplitScreen:ProgActive()
	if mouse:gety()<247 then
		if mouse:getx()<240 then 
			return true
		elseif mouse:getx()>240 then
			return false
		end
	end
end

function SplitScreen:bl()
end