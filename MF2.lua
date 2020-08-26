local curspriteRam = 0x03000140 --当前活动块数据起始
local aranRam = 0x03001244 --角色数据起始
local bulletRam = 0x03000960 --弹丸数据起始
local aranDecide = 0x030001268 --角色的判定
local XScrolloffset = 0x03001228 --水平卷轴偏移start
local gameMode = 0x03000BDE	--检查in-game
local powerbomeRam = 0x03000110 --PB数据起始
local resourceData = 0x3001310 --资源数据 弹药 血量等
--local damageHp = 0
local oldHp = 0

local function damageshow()
	if memory.readbyte(aranRam + 0x5)==0 then --当阿兰没有无敌的时候
		oldHp = memory.readword(resourceData)
	end	
	local invintime = memory.readbyte(aranRam+5)
	if invintime~=0 then
		local damageHp=oldHp - memory.readword(resourceData)
		--根据偏移在屏幕上的坐标
		local x = (memory.readword(aranRam+0x16)-memory.readword(XScrolloffset))/4
		local y = (memory.readword(aranRam+0x18)-memory.readword(XScrolloffset+2))/4
		--上判定框
		local top = memory.readwordsigned(aranDecide+2)/4
		
		x = x - 3
		
		y = y+top-60+(memory.readbyte(aranRam+5)/2)
		
		gui.text(x,y,"-" .. damageHp,"green","black")
	end
end

local function sprites()	
	for i =1,0x18 do
		if memory.readbyte(curspriteRam+0x38*(i-1))>=3 then --lua难以bit操作,bit位的并,或,故笼统
			--活动块的坐标
			local x = (memory.readword(curspriteRam+0x4+0x38*(i-1))-memory.readword(XScrolloffset))/4
			local y = (memory.readword(curspriteRam+0x2+0x38*(i-1))-memory.readword(XScrolloffset+2))/4
			--判定大小
			local top = (memory.readwordsigned(curspriteRam+0xA+0x38*(i-1)))/4
			local down = (memory.readwordsigned(curspriteRam+0xC+0x38*(i-1)))/4
			local left = (memory.readwordsigned(curspriteRam+0xE+0x38*(i-1)))/4
			local right = (memory.readwordsigned(curspriteRam+0x10+0x38*(i-1)))/4
			--活动块框体
			local x1 = x + left
			local y1 = y + top
			local x2 = x + right
			local y2 = y + down
			--绘制活动块框体
			if memory.readbyte(curspriteRam+0x34+0x38*(i-1))<80 then --是主框体部署的话
			--绘制血量
			local HP = memory.readword(curspriteRam+0x14+0x38*(i-1))
				if HP ~= 0 then
				gui.text(x,y,"HP" .. HP,"yellow")
				end
			end
		end
	end	
end	



while true do
	if memory.readbyte(gameMode)==1 then
		damageshow()
		sprites()
	end
	vba.frameadvance()
end