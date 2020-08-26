local curspriteRam = 0x030001AC --��ǰ���������ʼ
local aranRam = 0x030013D4 --��ɫ������ʼ
local bulletRam = 0x03000A2C --����������ʼ
local aranDecide = 0x030015D8 --��ɫ���ж�
local XScrolloffset = 0x030013B8 --ˮƽ����ƫ��start
local gameMode = 0x03000C70	--���in-game
local powerbomeRam = 0x03000130 --PB������ʼ

local function aran()
	--����ƫ������Ļ�ϵ�����
	local x = (memory.readword(aranRam+0x12)-memory.readword(XScrolloffset))/4
	local y = (memory.readword(aranRam+0x14)-memory.readword(XScrolloffset+2))/4
	--��ɫ�ж���
	local top = memory.readwordsigned(aranDecide+4)/4
	local left = memory.readwordsigned(aranDecide)/4
	local right = memory.readword(aranDecide+2)/4
	--��ɫ��������
	local x1 = x + left
	local y1 = y + top
	local x2 = x + right
	--��ɫ�ж���
	gui.box(x1,y1,x2,y,"clear","green") 
end
	
local function bullets()
	for i = 1,0x10 do
		if memory.readbyte(bulletRam+0x1C*(i-1))~=0 then --�����ӵ���Чʱ
			--�ӵ�����Ļ����ȷ������
			local x = (memory.readword(bulletRam+0xA+0x1C*(i-1))-memory.readword(XScrolloffset))/4
			local y = (memory.readword(bulletRam+0x8+0x1C*(i-1))-memory.readword(XScrolloffset+2))/4
			--��ҩ��С
			local top = (memory.readwordsigned(bulletRam+0x14+0x1C*(i-1)))/4
			local down = (memory.readword(bulletRam+0x16+0x1C*(i-1)))/4
			local left = (memory.readwordsigned(bulletRam+0x18+0x1C*(i-1)))/4
			local right = (memory.readword(bulletRam+0x1A+0x1C*(i-1)))/4
			--�ӵ�����
			local x1 = x + left
			local y1 = y + top
			local x2 = x + right
			local y2 = y + down
			--�����ӵ��ж���
			if memory.readbyte(bulletRam+0xF+0x1C*(i-1))<0xE then --���ӵ��Ļ�
				gui.box(x1,y1,x2,y2,"clear","magenta")
			elseif memory.readbyte(bulletRam+0xF+0x1C*(i-1))~=0xF then --���ǳ�ը�Ļ�
				if memory.readbyte(bulletRam+0x11+0x1C*(i-1))==3 then --��ը�Ļ�
					gui.box(x1,y1,x2,y2,"clear","purple")
				end
			end	
		end
	end
end	
	
local function sprites()	
	for i =1,0x18 do
		if memory.readbyte(curspriteRam+0x38*(i-1))>=3 then --lua����bit����,bitλ�Ĳ�,��,����ͳ
			--��������
			local x = (memory.readword(curspriteRam+0x4+0x38*(i-1))-memory.readword(XScrolloffset))/4
			local y = (memory.readword(curspriteRam+0x2+0x38*(i-1))-memory.readword(XScrolloffset+2))/4
			--�ж���С
			local top = (memory.readwordsigned(curspriteRam+0xA+0x38*(i-1)))/4
			local down = (memory.readword(curspriteRam+0xC+0x38*(i-1)))/4
			local left = (memory.readwordsigned(curspriteRam+0xE+0x38*(i-1)))/4
			local right = (memory.readword(curspriteRam+0x10+0x38*(i-1)))/4
			--������
			local x1 = x + left
			local y1 = y + top
			local x2 = x + right
			local y2 = y + down
			--���ƻ�����
			if memory.readbyte(curspriteRam+0x32+0x38*(i-1))>=80 then --�������岿��Ļ�
				gui.box(x1,y1,x2,y2,"clear","orange")
			else
				gui.box(x1,y1,x2,y2,"clear","red")
			end
			--����Ѫ��
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
			--��ը������
			local x = (memory.readword(powerbomeRam+0x4)-memory.readword(XScrolloffset))/4
			local y = (memory.readword(powerbomeRam+0x6)-memory.readword(XScrolloffset+2))/4
			--�˺���Χ��С
			local top = (memory.readwordsigned(powerbomeRam+0xC))/4
			local down = (memory.readword(powerbomeRam+0xE))/4
			local left = (memory.readwordsigned(powerbomeRam+0x8))/4
			local right = (memory.readword(powerbomeRam+0xA))/4
			--�˺���Χ����
			local x1 = x + left
			local y1 = y + top
			local x2 = x + right
			local y2 = y + down
			--���Ʒ�Χ
			gui.box(x1,y1,x2,y2,"clear","teal")
		end
	end
end	
	
while true do
	if memory.readbyte(gameMode)==4 then
		aran()
		bullets()	
		sprites()
		powerbome()
	end
	vba.frameadvance()
end
--by:jumuzhu-diwa	