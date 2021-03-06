
CHAT_FLAG_AFK = '<AFK>'
CHAT_FLAG_DND = '<DND>'
CHAT_FLAG_GM = '<GM>'

-- CHAT_AFK_GET
-- CHAT_DND_GET

CHAT_MONSTER_PARTY_GET = '|Hchannel:Party|hp|h %s:\32'
CHAT_MONSTER_SAY_GET = '%s：\32'
CHAT_MONSTER_WHISPER_GET = 'from %s:\32'
CHAT_MONSTER_YELL_GET = 'to %s:\32'

CHAT_SAY_GET = '%s:\32'
CHAT_YELL_GET = '%s:\32'
-- CHAT_EMOTE_GET
CHAT_GUILD_GET = '|Hchannel:Guild|hg|h %s:\32'
CHAT_RAID_GET = '|Hchannel:raid|hr|h %s:\32'
CHAT_PARTY_GET = '|Hchannel:Party|hp|h %s:\32'
CHAT_PARTY_LEADER_GET = '|Hchannel:party|hP|h %s:\32'
CHAT_PARTY_GUIDE_GET = '|Hchannel:party|hP|h %s:\32'
CHAT_RAID_WARNING_GET = 'rw %s:\32'
CHAT_RAID_LEADER_GET = '|Hchannel:raid|hR|h %s:\32'
CHAT_OFFICER_GET = '|Hchannel:OFFICER|ho|h %s:\32'
CHAT_BATTLEGROUND_GET = '|Hchannel:Battleground|hb|h %s:\32'
CHAT_BATTLEGROUND_LEADER_GET = '|Hchannel:Battleground|hB|h %s:\32'
CHAT_WHISPER_GET = 'from %s:\32'
CHAT_WHISPER_INFORM_GET = 'to %s:\32'

--[[	bindings	]]
BINDING_HEADER_YCHAT = 'yChat'
BINDING_NAME_YCHAT_WT = 'Whisper Target'
BINDING_NAME_YCHAT_GS = 'Group Say'
BINDING_NAME_YCHAT_GUILD = CHAT_MSG_GUILD
BINDING_NAME_YCHAT_OFFICAL = CHAT_MSG_OFFICER
BINDING_NAME_YCHAT_PARTY = CHAT_MSG_PARTY
BINDING_NAME_YCHAT_RAID = CHAT_MSG_RAID
BINDING_NAME_YCHAT_RW = CHAT_MSG_RAID_WARNING
BINDING_NAME_YCHAT_BG = CHAT_MSG_BATTLEGROUND
BINDING_NAME_YCHAT_EMOTE = CHAT_MSG_EMOTE
BINDING_NAME_YCHAT_YELL = CHAT_MSG_YELL
BINDING_NAME_YCHAT_SAY = CHAT_MSG_SAY
for i = 1, 10 do
	_G['BINDING_NAME_YCHAT_C'..i] = CHANNEL..' '..i
end

