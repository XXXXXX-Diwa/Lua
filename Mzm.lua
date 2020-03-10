local curspriteRam = 0x030001AC --��ǰ���������ʼ
local aranRam = 0x030013D4 --��ɫ������ʼ
local bulletRam = 0x03000A2C --����������ʼ
local aranDecide = 0x030015D8 --��ɫ���ж�
local XScrolloffset = 0x030013B8 --ˮƽ����ƫ��(ʵ���ϲ���,��������Ϊ,Ӧ����bg1��scroll)
local gameMode = 0x03000C70	--���in-game

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
			gui.box(x1,y1,x2,y2,"clear","white")
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
				gui.box(x1,y1,x2,y2,"clear","yellow")
			else
				gui.box(x1,y1,x2,y2,"clear","red")
			end
			--����Ѫ��
			local HP = memory.readword(curspriteRam+0x14+0x38*(i-1))
			if HP ~= 0 then
			gui.text(x,y,"HP" .. HP,"orange")
			end
		end
	end	
end
	
while true do
	if memory.readbyte(gameMode)==4 then
		aran()
		bullets()	
		sprites()
	end
	vba.frameadvance()
end
		