local curspriteRam = 0x03000140 --��ǰ���������ʼ
local aranRam = 0x03001244 --��ɫ������ʼ
local bulletRam = 0x03000960 --����������ʼ
local aranDecide = 0x030001268 --��ɫ���ж�
local XScrolloffset = 0x03001228 --ˮƽ����ƫ��start
local gameMode = 0x03000BDE	--���in-game
local powerbomeRam = 0x03000110 --PB������ʼ
local resourceData = 0x3001310 --��Դ���� ��ҩ Ѫ����
--local damageHp = 0
local oldHp = 0

local function damageshow()
	if memory.readbyte(aranRam + 0x5)==0 then --������û���޵е�ʱ��
		oldHp = memory.readword(resourceData)
	end	
	local invintime = memory.readbyte(aranRam+5)
	if invintime~=0 then
		local damageHp=oldHp - memory.readword(resourceData)
		--����ƫ������Ļ�ϵ�����
		local x = (memory.readword(aranRam+0x16)-memory.readword(XScrolloffset))/4
		local y = (memory.readword(aranRam+0x18)-memory.readword(XScrolloffset+2))/4
		--���ж���
		local top = memory.readwordsigned(aranDecide+2)/4
		
		x = x - 3
		
		y = y+top-60+(memory.readbyte(aranRam+5)/2)
		
		gui.text(x,y,"-" .. damageHp,"green","black")
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
			local down = (memory.readwordsigned(curspriteRam+0xC+0x38*(i-1)))/4
			local left = (memory.readwordsigned(curspriteRam+0xE+0x38*(i-1)))/4
			local right = (memory.readwordsigned(curspriteRam+0x10+0x38*(i-1)))/4
			--������
			local x1 = x + left
			local y1 = y + top
			local x2 = x + right
			local y2 = y + down
			--���ƻ�����
			if memory.readbyte(curspriteRam+0x34+0x38*(i-1))<80 then --�������岿��Ļ�
			--����Ѫ��
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