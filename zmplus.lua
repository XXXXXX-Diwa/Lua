local curspriteRam = 0x030001AC --当前活动块数据起始
local aranRam = 0x030013D4 --角色数据起始
local bulletRam = 0x03000A2C --弹丸数据起始
local aranDecide = 0x030015D8 --角色的判定
local XScrolloffset = 0x030013B8 --水平卷轴偏移start
local gameMode = 0x03000C70	--检查in-game
local powerbomeRam = 0x03000130 --PB数据起始

local function spriteinfos()
	--定义第一行的开始坐标
	local x=118
	local y=10
	gui.text(x,y,"ID NUM POSE   OAM    HP","white","red")
	local i=0;
	local line=0;
	while (true) do
		if(memory.readbyte(curspriteRam+(i*0x38))~=0) then
			line=line+1
			local strid=string.format("%02X",memory.readbyte(curspriteRam+0x1D+(i*0x38)))
			local strpose=string.format("%02X",memory.readbyte(curspriteRam+0x24+(i*0x38)))
			local stroam=string.format("%07X",memory.readdword(curspriteRam+0x18+(i*0x38))-0x8000000)
			local strhp=string.format("%04X",memory.readword(curspriteRam+0x14+(i*0x38)))
			local num=0
			if(memory.readbyte(curspriteRam+0x32+(i*0x38))>=0x80) then
				local strnum=string.format("%02X",memory.readbyte(curspriteRam+0x1E+(i*0x38)))
				gui.text(x,y+line*6,strid.."-"..strnum.."   "..strpose.."  "..stroam.." "..strhp,"cyan","clear")
			else
				local strnum=string.format("%02X",memory.readbyte(curspriteRam+0x23+(i*0x38)))
				gui.text(x,y+line*6,strid.."-"..strnum.."   "..strpose.."  "..stroam.." "..strhp,"green","clear")
			end
			
		end
		i=i+1
		if (i>0x17) then
			break
		end
	end
end

local function aran()
	--根据偏移在屏幕上的坐标
	local x = (memory.readword(aranRam+0x12)-memory.readword(XScrolloffset))/4
	local y = (memory.readword(aranRam+0x14)-memory.readword(XScrolloffset+2))/4
	--角色判定框
	local top = memory.readwordsigned(aranDecide+4)/4
	local left = memory.readwordsigned(aranDecide)/4
	local right = memory.readword(aranDecide+2)/4
	--角色框体坐标
	local x1 = x + left
	local y1 = y + top
	local x2 = x + right
	--角色判定框
	gui.box(x1,y1,x2,y,"clear","green") 
end
	
local function bullets()
	for i = 1,0x10 do
		if memory.readbyte(bulletRam+0x1C*(i-1))~=0 then --仅当子弹有效时
			--子弹在屏幕上正确的坐标
			local x = (memory.readword(bulletRam+0xA+0x1C*(i-1))-memory.readword(XScrolloffset))/4
			local y = (memory.readword(bulletRam+0x8+0x1C*(i-1))-memory.readword(XScrolloffset+2))/4
			--弹药大小
			local top = (memory.readwordsigned(bulletRam+0x14+0x1C*(i-1)))/4
			local down = (memory.readword(bulletRam+0x16+0x1C*(i-1)))/4
			local left = (memory.readwordsigned(bulletRam+0x18+0x1C*(i-1)))/4
			local right = (memory.readword(bulletRam+0x1A+0x1C*(i-1)))/4
			--子弹框体
			local x1 = x + left
			local y1 = y + top
			local x2 = x + right
			local y2 = y + down
			--绘制子弹判定框
			if memory.readbyte(bulletRam+0xF+0x1C*(i-1))<0xE then --是子弹的话
				gui.box(x1,y1,x2,y2,"clear","magenta")
			elseif memory.readbyte(bulletRam+0xF+0x1C*(i-1))~=0xF then --不是超炸的话
				if memory.readbyte(bulletRam+0x11+0x1C*(i-1))==3 then --爆炸的话
					gui.box(x1,y1,x2,y2,"clear","purple")
				end
			end	
		end
	end
end	
	
local function spriteboxs()	
	for i =18,0x0,-1 do
		if memory.readbyte(curspriteRam+0x38*(i-1))>=3 then --lua难以bit操作,bit位的并,或,故笼统
			--活动块的坐标
			local x = (memory.readword(curspriteRam+0x4+0x38*(i-1))-memory.readword(XScrolloffset))/4
			local y = (memory.readword(curspriteRam+0x2+0x38*(i-1))-memory.readword(XScrolloffset+2))/4
			--判定大小
			local top = (memory.readwordsigned(curspriteRam+0xA+0x38*(i-1)))/4
			local down = (memory.readwordsigned(curspriteRam+0xC+0x38*(i-1)))/4
			local left = (memory.readwordsigned(curspriteRam+0xE+ 0x38*(i-1)))/4
			local right = (memory.readwordsigned(curspriteRam+0x10+0x38*(i-1)))/4
			--活动块框体
			local x1 = x + left
			local y1 = y + top
			local x2 = x + right
			local y2 = y + down
			local collision = memory.readbyte(curspriteRam+0x32+0x38*(i-1))
			local strid=string.format("%02X",memory.readbyte(curspriteRam+0x1D + 0x38*(i-1)))
			--绘制活动块框体
			if memory.readbyte(curspriteRam+0x32+0x38*(i-1))>=80 then --是主框体部署的话
				gui.box(x1,y1,x2,y2,"clear","orange")
				local spriteNum = string.format("%02X",memory.readbyte(curspriteRam+0x1E+0x38*(i-1)))
				gui.text(x1,y2-4,strid.."-"..spriteNum,"cyan")
			else
				gui.box(x1,y1,x2,y2,"clear","red")
				local spriteNum = string.format("%02X",memory.readbyte(curspriteRam+0x23+0x38*(i-1)))
				gui.text(x1,y2-4,strid.."-"..spriteNum,"green")
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
	if memory.readbyte(gameMode)==4 then
		spriteinfos()
		aran()
		bullets()	
		spriteboxs()
		powerbome()
	end
	vba.frameadvance()
end
--by:jumuzhu-diwa	