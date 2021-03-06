local curspriteRam = 0x03000140 --当前活动块数据起始
local aranRam = 0x03001244 --角色数据起始
local bulletRam = 0x03000960 --弹丸数据起始
local aranDecide = 0x03001268 --角色的判定
local XScrolloffset = 0x03001228 --水平卷轴偏移start
local gameMode = 0x03000BDE	--检查in-game
local powerbomeRam = 0x03000110 --PB数据起始

local function aran()
	--根据偏移在屏幕上的坐标
	local x = (memory.readword(aranRam+0x16)-memory.readword(XScrolloffset))/4
	local y = (memory.readword(aranRam+0x18)-memory.readword(XScrolloffset+2))/4
	--角色判定框
	local top = memory.readwordsigned(aranDecide+2)/4
	local left = memory.readwordsigned(aranDecide)/4
	local right = memory.readword(aranDecide+4)/4
	--角色框体坐标
	local x1 = x + left
	local y1 = y + top
	local x2 = x + right
	--角色判定框
	gui.box(x1,y1,x2,y,"clear","green") 
end
	
local function bullets()
	for i = 1,0x10 do
		if memory.readbyte(bulletRam+0x20*(i-1))~=0 then --仅当子弹有效时
			--子弹在屏幕上正确的坐标
			local x = (memory.readword(bulletRam+0xA+0x20*(i-1))-memory.readword(XScrolloffset))/4
			local y = (memory.readword(bulletRam+0x8+0x20*(i-1))-memory.readword(XScrolloffset+2))/4
			--弹药大小
			local top = (memory.readwordsigned(bulletRam+0x16+0x20*(i-1)))/4
			local down = (memory.readwordsigned(bulletRam+0x18+0x20*(i-1)))/4
			local left = (memory.readwordsigned(bulletRam+0x1A+0x20*(i-1)))/4
			local right = (memory.readwordsigned(bulletRam+0x1C+0x20*(i-1)))/4
			--子弹框体
			local x1 = x + left
			local y1 = y + top
			local x2 = x + right
			local y2 = y + down
			--绘制子弹判定框
			if memory.readbyte(bulletRam+0xF+0x20*(i-1))==0x12 then --蓄力导弹雪花
				gui.box(x1,y1,x2,y2,"clear","magenta")
			elseif memory.readbyte(bulletRam+0xF+0x20*(i-1))<0x10 then --仅是子弹时
				gui.box(x1,y1,x2,y2,"clear","magenta")
			elseif memory.readbyte(bulletRam+0x12+0x20*(i-1))==3 then --炸弹爆炸时
				gui.box(x1,y1,x2,y2,"clear","purple")
			end	
		end
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
			local down = (memory.readwordsiged(curspriteRam+0xC+0x38*(i-1)))/4
			local left = (memory.readwordsigned(curspriteRam+0xE+0x38*(i-1)))/4
			local right = (memory.readwordsigned(curspriteRam+0x10+0x38*(i-1)))/4
			--活动块框体
			local x1 = x + left
			local y1 = y + top
			local x2 = x + right
			local y2 = y + down
			--绘制活动块框体
			if memory.readbyte(curspriteRam+0x34+0x38*(i-1))>=80 then --是主框体部署的话
				gui.box(x1,y1,x2,y2,"clear","orange")
			else
				gui.box(x1,y1,x2,y2,"clear","red")
			end
			--绘制血量
			local HP = memory.readword(curspriteRam+0x14+0x38*(i-1))
			if HP ~= 0 then
			gui.text(x,y,"HP" .. HP,"yellow")
			end
		end
	end	
end

local function powerbome()
	if memory.readword(powerbomeRam)~=0 then
		if memory.readbyte(powerbomeRam)~=5 then
			--超炸的坐标
			local x = (memory.readword(powerbomeRam+0x4)-memory.readword(XScrolloffset))/4
			local y = (memory.readword(powerbomeRam+0x6)-memory.readword(XScrolloffset+2))/4
			--伤害范围大小
			local top = (memory.readwordsigned(powerbomeRam+0xC))/4
			local down = (memory.readword(powerbomeRam+0xE))/4
			local left = (memory.readwordsigned(powerbomeRam+0x8))/4
			local right = (memory.readword(powerbomeRam+0xA))/4
			--伤害范围框体
			local x1 = x + left
			local y1 = y + top
			local x2 = x + right
			local y2 = y + down
			--绘制范围
			gui.box(x1,y1,x2,y2,"clear","teal")
		end
	end
end
	
while true do
	if memory.readbyte(gameMode)==1 then
		aran()
		bullets()
		sprites()
		powerbome()
	end
	vba.frameadvance()
end
		