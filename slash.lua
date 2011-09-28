
-- [[ Tell target and group tell ]]
SLASH_YCHAT_TELLTARGET1 = "/tt"
SLASH_YCHAT_TELLTARGET2 = "/wt"
local shits = {[''] = true, [' '] = true, [GetRealmName()] = true,}
SlashCmdList.YCHAT_TELLTARGET = function(msg)
    if msg and UnitExists('target') and UnitIsPlayer('target') and UnitIsFriend('target') then
        local name, realm = UnitName('target')
        if realm and (not shits[realm]) then name = name .. '-' .. realm end
        SendChatMessage(msg, "WHISPER", nil, name)
    else
        UIErrorsFrame:AddMessage('Unable to whisper target', 1, 0, 0, 1, 5)
    end
end

SLASH_YCHAT_GROUPTELL1 = "/gr"
SlashCmdList.YCHAT_GROUPTELL = function(msg)
    if not msg then return end
    local channel = 'SAY'
    local inInstance, instanceType = msg and IsInInstance()
    if inInstance and (instanceType == 'pvp') then
        channel = 'BATTLEGROUND'
    elseif GetRealNumRaidMembers() > 0 then
        channel = 'RAID'
    elseif GetRealNumPartyMembers() > 0 then
        channel = 'PARTY'
    end
    SendChatMessage(msg, channel)
end

