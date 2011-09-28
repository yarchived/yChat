
-- credits: oChat, evl, etc.

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

--[[	class color	]]
local dummy = function() end
local _, pClass = UnitClass'player'
local ts
--local ts = '|cffffffff|HyChat|h%s|h|||r %s'
--local ts = '|cffffffff|HyChat|h%s|h|r %s'
--local ts = '|cff68ccef|HyChat|h%s|h|r %s'

do
    local function updateColors()
        local c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[pClass] or RAID_CLASS_COLORS[pClass]
        ts = '|cff'.. format('%02x%02x%02x',c.r*255,c.g*255,c.b*255) ..'|HyChat|h%s|h|r %s'
    end

    if CUSTOM_CLASS_COLORS then
        CUSTOM_CLASS_COLORS:RegisterCallback(updateColors)
    end
    updateColors()
end

CHAT_FLAG_AFK = '<AFK>'
CHAT_FLAG_DND = '<DND>'
CHAT_FLAG_GM = '<GM>'

-- CHAT_AFK_GET
-- CHAT_DND_GET

CHAT_MONSTER_EMOTE_GET = ''
CHAT_MONSTER_PARTY_GET = '|Hchannel:Party|hp|h %s:\32'
CHAT_MONSTER_SAY_GET = '%s£º\32'
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
CHAT_OFFICER_GET = '|Hchannel:o|ho|h %s:\32'
CHAT_BATTLEGROUND_GET = '|Hchannel:Battleground|hb|h %s:\32'
CHAT_BATTLEGROUND_LEADER_GET = '|Hchannel:Battleground|hB|h %s:\32'
CHAT_WHISPER_GET = 'from %s:\32'
CHAT_WHISPER_INFORM_GET = 'to %s:\32'

local iconify
do

    local TypeIcons = {
        ['spell'] = function(i) return (GetSpellTexture(i)) end,
        ['item'] = function(i) return (GetItemIcon(i)) end,
        ['achievement'] = function(i) return (select(10, GetAchievementInfo(i))) end,
    }

    local IconLink = ' |T%s:14:14:0:0:64:64:4:60:4:60|t %s'
    -- |TTexturePath:size1:size2:xoffset:yoffset:dimx:dimy:coordx1:coordx2:coordy1:coordy2|t
    -- http://www.wowwiki.com/UI_escape_sequences

    function iconify(link)
        local type, id = link:match'|H(%w+):(%w+)'
        local icon = TypeIcons[type] and TypeIcons[type](id)
        -- Don't like: brackets
        if(icon) then
            link = link:gsub('%[(.-)%]', '%1')
        elseif(type == 'quest') then
            --print(link:gsub('%|', ' '))
            local qlevel = link:match'|Hquest:%w+:(%w+)|h'
            link = ('[%s]%s'):format(qlevel, link)
        end

        return icon and IconLink:format(icon, link) or link
    end
end

local channel
-- 1: index, 2: channelname, 3: twatt
-- Examples are based on this: [1. Channel] Otravi: Hi
--local str = '[%2$.3s] %s' -- gives: [Cha] Otravi: Hi
--local str = '[%d. %2$.3s] %s' -- gives: [1. Cha] Otravi: Hi
do
    local str = '%d|h %3$s' -- gives: 1 Otravi: Hi
    function channel(...)
        return str:format(...)
    end
end

local _AddMessage = ChatFrame1.AddMessage
local function AddMessage(self, text, ...)
    if (text) then
        -- simple chat icon, grab from iconify by xconstruct
        text = text:gsub('(|c%x+|H.-|h|r)', iconify)

        text = text:gsub('|Hplayer:([^:]+):(%d+)|h%[(.-)%]|h', '|Hplayer:%1:%2|h%3|h')
        --text = text:gsub('%[(%d+)%. (.+)%].+(|Hplayer.+)', str)
        text = text:gsub('%[(%d+)%. (.-)%].+(|Hplayer.+)', channel)

        --text = ts:format(date'%H:%M:%S', text)
        text = ts:format(date'%X', text)
        return _AddMessage(self, text, ...)
    end
end

-- copy:paste for combatlog
local function AddMessage_cl(self, text, ...)
    text = ts:format('*', text)
    return _AddMessage(self, text, ...)
end

local scroll = function(self, dir)
    if(dir > 0) then
        if(IsShiftKeyDown()) then
            self:ScrollToTop()
        elseif(IsControlKeyDown())	then
            for i=1,3 do self:ScrollUp() end
        else
            self:ScrollUp()
        end
    elseif(dir < 0) then
        if(IsShiftKeyDown()) then
            self:ScrollToBottom()
        elseif(IsControlKeyDown())	then
            for i=1,3 do self:ScrollDown() end
        else
            self:ScrollDown()
        end
    end
end

do
    local Init_ChatFrame_Hack = function(self)
        local buttons = {'UpButton', 'DownButton', 'BottomButton', ''}
        for i=1, NUM_CHAT_WINDOWS do
            local cf = _G['ChatFrame'..i]
            if cf then
                cf:SetScript('OnUpdate', nil)

                cf:SetClampedToScreen(false)
                cf:SetFading(false)

                cf:EnableMouseWheel(true)
                if(cf:GetScript'OnMouseWheel') then
                    cf:HookScript('OnMouseWheel', scroll)
                else
                    cf:HookScript('OnMouseWheel', scroll)
                end

                --cf:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
                --cf:SetShadowColor(0,0,0)
                --cf:SetShadowOffset(.1, -.1)	

                for _, button in pairs(buttons) do
                    local butt = _G['ChatFrame'..i..'ButtonFrame'..button]
                    butt:Hide()
                    butt.Show = dummy
                end

                local eb = _G['ChatFrame'..i..'EditBox']
                eb:ClearAllPoints()
                eb:SetPoint('BOTTOMLEFT', _G['ChatFrame'..i], 'TOPLEFT', -5, 15)
                eb:SetPoint('RIGHT', _G['ChatFrame'..i], 'RIGHT')
                eb:SetAltArrowKeyMode(false)

                do
                    local a, b, c = select(6, eb:GetRegions())
                    a:Hide()
                    b:Hide()
                    c:Hide()
                end

                if(i == 2) then
                    cf.AddMessage = AddMessage_cl
                else
                    cf.AddMessage = AddMessage
                    --cf:SetMaxLines(1000)
                end
            end
        end
    end
    if(IsLoggedIn()) then
        Init_ChatFrame_Hack()
    else
        local f = CreateFrame'Frame'
        f:RegisterEvent'PLAYER_LOGIN'
        f:SetScript('OnEvent', function(self)
            Init_ChatFrame_Hack()
            -- destroy
            self:UnregisterAllEvents()
            self:ClearAllPoints()
            self:Hide()
            self:SetScript('OnEvent', nil)
        end)
    end
end

ChatFrameMenuButton:Hide()
ChatFrameMenuButton.Show = dummy
--[[ChatFrameMenuButton:Hide()
ChatFrameMenuButton.Show = dummy
ChatFrameMenuButton:SetParent(UIParent)
ChatFrameMenuButton:SetAlpha(0)
ChatFrameMenuButton:ClearAllPoints()
ChatFrameMenuButton:SetPoint('TOPLEFT', ChatFrame1, 0, 0)
ChatFrameMenuButton:SetScript('OnLeave', function(self) self:SetAlpha(0) end)
ChatFrameMenuButton:SetScript('OnEnter', function(self) self:SetAlpha(.5) end)
]]

FriendsMicroButton:Show()
FriendsMicroButton.Show = dummy
FriendsMicroButton:UnregisterAllEvents()



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
ChatTypeInfo['CHANNEL'].sticky = 1

-- Modified version of MouseIsOver from UIParent.lua
local function MouseIsOver(frame)
    local s = frame:GetParent():GetEffectiveScale()
    local x, y = GetCursorPosition()
    x = x / s
    y = y / s

    local left = frame:GetLeft()
    local right = frame:GetRight()
    local top = frame:GetTop()
    local bottom = frame:GetBottom()

    -- Hack to fix a symptom not the real issue
    if(not left) then
        return
    end

    if((x > left and x < right) and (y > bottom and y < top)) then
        return 1
    else
        return
    end
end

local borderManipulation = function(...)
    for l = 1, select('#', ...) do
        local obj = select(l, ...)
        if(obj:GetObjectType() == 'FontString' and MouseIsOver(obj)) then
            return obj:GetText()
        end
    end
end

local _SetItemRef = SetItemRef
SetItemRef = function(link, text, button, ...)
    if(link:sub(1, 5) ~= 'yChat') then return _SetItemRef(link, text, button, ...) end

    local text = borderManipulation(SELECTED_CHAT_FRAME:GetRegions())
    if(text) then
        text = text:gsub('|c%x%x%x%x%x%x%x%x(.-)|r', '%1')
        text = text:gsub('|H.-|h(.-)|h', '%1')
        text = text:gsub('|T.-|t', '')


        local chatFrame = SELECTED_DOCK_FRAME or DEFAULT_CHAT_FRAME;
        local editBox = chatFrame.editBox;
        editBox:Insert(text)
        editBox:Show()
        editBox:HighlightText()
        editBox:SetFocus()
    end
end


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

