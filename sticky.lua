
ChatTypeInfo['SAY'].sticky = 1
ChatTypeInfo['YELL'].sticky = 0
ChatTypeInfo['EMOTE'].sticky = 0
ChatTypeInfo['PARTY'].sticky = 1
ChatTypeInfo['GUILD'].sticky = 1
ChatTypeInfo['OFFICER'].sticky = 1
ChatTypeInfo['RAID'].sticky = 1
ChatTypeInfo['RAID_WARNING'].sticky = 0
ChatTypeInfo['BATTLEGROUND'].sticky = 1
ChatTypeInfo['WHISPER'].sticky = 0
--ChatTypeInfo['CHANNEL'].sticky = 1

for i = 1, 10 do
    ChatTypeInfo['CHANNEL'..i].sticky = i<5 and 0 or 1
end

