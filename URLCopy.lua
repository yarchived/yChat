local urlStyle = '|cffdcdf16|Hurl:%1|h[%1]|h|r'

local urlPatterns = {

	'(%a[%w%.+-]+://%S+)', -- X://Y
	--'(http://[_A-Za-z0-9-%./]+)', -- http://abc.com
	'(www%.[_A-Za-z0-9-%./]+)', -- www.abc.com/whatever/index.php
	'(%d+%.%d+%.%d+%.%d+:?%d*)', -- 192.168.1.3, 192.3.4.5:43567
	'(%S+@[-%w_%%%.]+%.(%a%a+))', -- email@email.email
	'([-%w_%%%.]+[-%w_%%]%.(%a%a+):[0-6]?%d?%d?%d?%d/%S+)', -- http://abc.com:8080/download
	'([-%w_%%%.]+[-%w_%%]%.(%a%a+):[0-6]?%d?%d?%d?%d)%f[%D]', -- http://abc.com:8080
	'([-%w_%%%.]+[-%w_%%]%.(%a%a+)/%S+)', -- abc.abc.com/ouf
	'([-%w_%%%.]+[-%w_%%]%.(%a%a+))', -- abc.abc.com
	
-- taken from Prat
--[[
	-- X://Y url
	"^(%a[%w+.-]+://%S+)",
	"%f[%S](%a[%w+.-]+://%S+)",
	-- www.X.Y url
	"^(www%.[%w_-%%]+%.%S+)",
	"%f[%S](www%.[%w_-%%]+%.%S+)",
	-- "W X"@Y.Z email (this is seriously a valid email)
	'^(%"[^%"]+%"@[%w_.-%%]+%.(%a%a+))',
	'%f[%S](%"[^%"]+%"@[%w_.-%%]+%.(%a%a+))',
	-- X@Y.Z email
	"(%S+@[%w_.-%%]+%.(%a%a+))",
	-- XXX.YYY.ZZZ.WWW:VVVV/UUUUU IPv4 address with port and path
	"^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d/%S+)",
	"%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d/%S+)",
	-- XXX.YYY.ZZZ.WWW:VVVV IPv4 address with port (IP of ts server for example)
	"^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d)%f[%D]",
	"%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d)%f[%D]",
	-- XXX.YYY.ZZZ.WWW/VVVVV IPv4 address with path
	"^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%/%S+)",
	"%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%/%S+)",
	-- XXX.YYY.ZZZ.WWW IPv4 address
	"^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%)%f[%D]",
	"%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%)%f[%D]",
	-- X.Y.Z:WWWW/VVVVV url with port and path
	"^([%w_.-%%]+[%w_-%%]%.(%a%a+):[0-6]?%d?%d?%d?%d/%S+)",
	"%f[%S]([%w_.-%%]+[%w_-%%]%.(%a%a+):[0-6]?%d?%d?%d?%d/%S+)",
	-- X.Y.Z:WWWW url with port (ts server for example)
	"^([%w_.-%%]+[%w_-%%]%.(%a%a+):[0-6]?%d?%d?%d?%d)%f[%D]",
	"%f[%S]([%w_.-%%]+[%w_-%%]%.(%a%a+):[0-6]?%d?%d?%d?%d)%f[%D]",
	-- X.Y.Z/WWWWW url with path
	"^([%w_.-%%]+[%w_-%%]%.(%a%a+)/%S+)",
	"%f[%S]([%w_.-%%]+[%w_-%%]%.(%a%a+)/%S+)",
	-- X.Y.Z url
	"^([%w_.-%%]+[%w_-%%]%.(%a%a+))",
	"%f[%S]([%w_.-%%]+[%w_-%%]%.(%a%a+))",
]]
}

local messageTypes = {
	'CHAT_MSG_SAY',
	'CHAT_MSG_WHISPER', 
	'CHAT_MSG_WHISPER_INFORM',
	'CHAT_MSG_YELL',
	'CHAT_MSG_GUILD', 
	'CHAT_MSG_OFFICER',
	'CHAT_MSG_EMOTE',
	'CHAT_MSG_CHANNEL',
	'CHAT_MSG_PARTY',
	'CHAT_MSG_RAID',
	'CHAT_MSG_RAID_LEADER',
	'CHAT_MSG_RAID_WARNING',
	'CHAT_MSG_BATTLEGROUND',
	'CHAT_MSG_BATTLEGROUND_LEADER',
}

local urlFilter = function(self, event, text, ...)
	for _, pattern in ipairs(urlPatterns) do
		local result, matches = gsub(text, pattern, urlStyle)
		if matches > 0 then
			return false, result, ...
		end
	end
end

for _, event in ipairs(messageTypes) do
	ChatFrame_AddMessageEventFilter(event, urlFilter)
end

local orig1 = SetItemRef
SetItemRef = function(link, text, button)
	if link:sub(0, 3) == 'url' then
		link = link:sub(5)
		
		local dialog = StaticPopup_Show('UrlCopyDialog')
		dialog.wideEditBox:SetText(link)
		dialog.wideEditBox:SetFocus()
		dialog.wideEditBox:HighlightText()
		getglobal(dialog:GetName()..'Button2'):Hide()
		
		return
	end
	
	return orig1(link, text, button)
end

StaticPopupDialogs['UrlCopyDialog'] = {
	text = 'URL Copy',
	timeout = 0,
	hasEditBox = 1,
	hasWideEditBox = 1,
	whileDead = 1,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
	button3 = CLOSE,
	--[[OnShow = function()
		local editBox = _G[this:GetName() .. 'WideEditBox']
		if editBox then
			editBox:SetText(currentLink)
			editBox:SetFocus()
			editBox:HighlightText(0)
		end
		local button = _G[this:GetName() .. 'Button2']
		if button then
			button:ClearAllPoints()
			button:SetWidth(200)
			button:SetPoint('CENTER', editBox, 'CENTER', 0, -30)
		end
	end,]]
}

