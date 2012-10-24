-- tekDebug
local debugf = tekDebug and tekDebug:GetFrame('yChat-gfw')
local debug = function() end
if debugf then
    debug = function(...) debugf:AddMessage(string.join(', ', tostringall(...))) end
end

local FilterItems = {
    -- dungeon badge
    [29434] = true, -- Badge of Justice
    [40752] = true, -- Emblem of Heroism
    [40753] = true, -- Emblem of Valor

    -- battelground
    [20558] = true, -- Warsong Gulch Mark of Honor
    [20559] = true, -- Arathi Basin Mark of Honor
    [20560] = true, -- Alterac Valley Mark of Honor
    [29024] = true, -- Eye of the Storm Mark of Honor
    [42425] = true, -- Strand of the Ancients Mark of Honor

    -- Kael'thas Sunstrider: seven legendary weapons
    [30311] = true,
    [30312] = true,
    [30313] = true,
    [30314] = true,
    [30316] = true,
    [30317] = true,
    [30318] = true,
    [30319] = true,
}

local loc = GetLocale()
local white_list = loc == 'zhCN' and {
    '^你获得了',
    '^你得到了物品',
    '^你制造',
    --[[
    LOOT_ITEM_PUSHED_SELF = "你获得了物品：%s。";
    LOOT_ITEM_PUSHED_SELF_MULTIPLE = "你获得了：%sx%d。";
    LOOT_ITEM_SELF = "你获得了物品：%s。";
    LOOT_ITEM_SELF_MULTIPLE = "你得到了物品：%sx%d。";

    LOOT_ITEM_CREATED_SELF = "你制造了：%s。";
    LOOT_ITEM_CREATED_SELF_MULTIPLE = "你制造了：%sx%d。";
    ]]
} or loc == 'zhTW' and {
    '^你獲得',
    '^你拾取了',
    '^你製造',
    --[[
    LOOT_ITEM_PUSHED_SELF = "你獲得了物品:%s。";
    LOOT_ITEM_PUSHED_SELF_MULTIPLE = "你獲得物品:%sx%d。";
    LOOT_ITEM_SELF = "你拾取了物品:%s。";
    LOOT_ITEM_SELF_MULTIPLE = "你獲得戰利品:%sx%d。";

    LOOT_ITEM_CREATED_SELF = "你製造了:%s。";
    LOOT_ITEM_CREATED_SELF_MULTIPLE = "你製造:%sx%d。";

    ]]
} or { -- EN
'^You receive',
'^You create',
--[[
LOOT_ITEM_PUSHED_SELF = "You receive item: %s.";
LOOT_ITEM_PUSHED_SELF_MULTIPLE = "You receive item: %sx%d.";
LOOT_ITEM_SELF = "You receive loot: %s.";
LOOT_ITEM_SELF_MULTIPLE = "You receive loot: %sx%d."

LOOT_ITEM_CREATED_SELF = "You create: %s.";
LOOT_ITEM_CREATED_SELF_MULTIPLE = "You create: %sx%d.";
]]
}

ChatFrame_AddMessageEventFilter('CHAT_MSG_LOOT', function(self, event, msg, ...)
    for i = 1, #white_list do
        if strfind(msg, white_list[i]) then return end
    end

    local id = (type(msg) == 'string') and msg:match('\124Hitem:(%d+):')
    if id then
        debug('CHAT_MSG_LOOT', id, msg)
        if FilterItems[tonumber(id)] then return true end
    end
end)




local player, lastmsg, lastsender, lastcounter, lastFilter = UnitName'player'
ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', function(self, event, msg, sender, _, _, _, _, _, ChannelNum, ChannelName, _, counter)
    if counter == lastcounter then
        return lastFilter
    end
    local filter = false
    if (msg == lastmsg) and (sender == lastsender) and (ChannelNum <= 4) and (sender ~= player) then
        filter = true
        debug('CHAT_MSG_CHANNEL', filter, counter, sender, ChannelNum, ChannelName, msg)
    end

    lastmsg, lastsender, lastcounter = msg, sender, counter
    lastFilter = filter
    return filter
end)


ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', function(self, event, msg)
    if msg:match('^<DBM>') then return true end
end)


local shutup = function(cf, event, msg, sender, lang, channelStr,
    target, flags, unknown, channelNumber, channelName, unknown2, counter)

    if(msg:match'^%*%*[^*]') then
        return true
    end
end

for _, e in next, {
    'CHAT_MSG_RAID',
    'CHAT_MSG_RAID_LEADER',
    'CHAT_MSG_RAID_WARNING',
    'CHAT_MSG_PARTY',
    'CHAT_MSG_PARTY_LEADER',
} do ChatFrame_AddMessageEventFilter(e, shutup) end

