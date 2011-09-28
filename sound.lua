
local ChannelSounds = {
    [5] = 'Sound\\Interface\\VoiceChatOn.wav',
    [8] = 'Sound\\Interface\\VoiceChatOn.wav',
}
local ChatSound, pName = CreateFrame'Frame', UnitName'player'
local ChatSoundEvents = {
    --['CHAT_MSG_GUILD'] = 'Sound\\Interface\\VoiceChatOn.wav',
    --['CHAT_MSG_OFFICER'] = 'Sound\\Interface\\VoiceChatOn.wav',
    ['CHAT_MSG_WHISPER'] = 'Sound\\Interface\\iTellMessage.wav',
    ['CHAT_MSG_PARTY'] = 'Sound\\Interface\\PlaceHolder.wav',
    ['CHAT_MSG_PARTY_LEADER'] = 'Sound\\Interface\\PlaceHolder.wav',
    ['CHAT_MSG_RAID'] = 'Sound\\Interface\\PlaceHolder.wav',
    ['CHAT_MSG_RAID_LEADER'] = 'Sound\\Interface\\PlaceHolder.wav',
    ['CHAT_MSG_BATTLEGROUND'] = 'Sound\\Interface\\PlaceHolder.wav',
    ['CHAT_MSG_BATTLEGROUND_LEADER'] = 'Sound\\Interface\\PlaceHolder.wav',
    ['CHAT_MSG_CHANNEL'] = function(msg, sender, _, _, _, _, _, ChannelNum, ...)
        return (ChannelNum > 4) and (sender ~= pName) and 'Sound\\Interface\\VoiceChatOn.wav'
    end,
}

for k, v in pairs(ChatSoundEvents) do
    if k and v then
        ChatSound:RegisterEvent(k)
    end
end

ChatSound:SetScript('OnEvent', function(self, event, msg, sender, ...)
    if (not event) or (not msg) or (sender == pName) then return end

    -- check if the msg is filted
    local filter = ChatFrame_GetMessageEventFilters(event)
    if filter then
        for _, func in pairs(filter) do
            local filted, newmsg = func(self, event, msg, sender, ...)
            if filted and (not newmsg) then return end
        end
    end

    local sound = ChatSoundEvents[event]
    if sound and type(sound) == 'function' then
        sound = sound(msg, sender, ...)
    end
    if sound and type(sound) == 'string' then
        PlaySoundFile(sound)
    end
end)

