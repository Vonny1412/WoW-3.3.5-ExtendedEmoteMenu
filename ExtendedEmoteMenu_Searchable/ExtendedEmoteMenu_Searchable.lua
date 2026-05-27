local ADDON_NAME, ADDON = ...
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME, true)
local V_Emote = LibStub("V_Emote-1.0")
-----------------------------------------------------------------------------------

local STRUCT_ID = "searchable"

local MAX_SEARCH_RESULTS = 8
local UPDATE_INTERVAL = 0.33

local SEARCH_PATTERN_ORDER = {
    "^%s", -- start of text
    " %s", -- start of word
    "%s", -- anything else
}

-----------------------------------------------------------------------------------

local expliciteShown = false
local nextUpdate = 0
local lastEnteredText = nil

local emoteStringsSelf = V_Emote.GetStrings("SELF")
local emoteStringsSelfToOther = V_Emote.GetStrings("SELF_TO_OTHER")

local tokenByCommand = {}
for token,cmds in pairs(V_Emote.emoteCommands) do
    for _,cmd in ipairs(cmds) do
        tokenByCommand[cmd:lower()] = token
    end
end

local function IsEnabled()
    return ExtendedEmoteMenu_GetSelectedStructureID() == STRUCT_ID
end

local function HighlightFirstVisibleMatch(text, command)
    local lowerText = text:lower()
    local lowerCommand = command:lower()

    local pos = 1

    while true do
        local a, b = lowerText:find(lowerCommand, pos, true)
        if ( not a ) then
            return text
        end

        local p1, p2 = text:find("%%2%$s", 1, false)

        if ( not p1 or a < p1 or a > p2 ) then
            return text:sub(1, a - 1)
                .. "|cAAffffff"
                .. text:sub(a, b)
                .. "|r"
                .. text:sub(b + 1)
        end

        pos = p2 + 1
    end
end

local function OnEmoteClick(button, ...)
    button.keepShownOnClick = expliciteShown
    ExtendedEmoteMenu_OnEmoteClick(button, ...)
    local editBox = _G[DEFAULT_CHAT_FRAME:GetName().."EditBox"]
    if ( editBox ) then
        editBox:SetText("")
    end
end

local function IsSlashCommand(text)
    local slash = text:sub(1, 1)
    local command = text:sub(2)
    command = command:gsub("^%s+", "")
    command = command:gsub("%s+$", "")
    command = command:gsub("[%%|]", "")
    return slash == "/", command
end

-----------------------------------------------------------------------------------

local function DoUpdate()

    local editBox = _G[DEFAULT_CHAT_FRAME:GetName().."EditBox"]
    if ( not editBox ) then
        return
    end

    if ( not editBox:IsShown() and not expliciteShown ) then
        ExtendedEmoteMenu_Hide()
        return
    end

    local enteredText = ""
    if ( editBox:IsShown() ) then
        enteredText = editBox:GetText()
    end
    if ( enteredText == lastEnteredText ) then
        return
    end
    lastEnteredText = enteredText
    enteredText = enteredText:lower()

    local isSlash, command = IsSlashCommand(enteredText)
    if ( not isSlash and not expliciteShown ) then
        ExtendedEmoteMenu_Hide()
        return
    end

    local menu = ExtendedEmoteMenu_GetExtendedMenu()

    local _expliciteShown = expliciteShown
    ExtendedEmoteMenu_Show()
    ExtendedEmoteMenu_ClearMenu(menu)
    expliciteShown = _expliciteShown -- set it back if menu auto opened

    if ( command == "" ) then
        ExtendedEmoteMenu_AddButton(menu, L["search_hint"])
        ExtendedEmoteMenu_PrettifyMenu(menu)
        return
    end

    local targetName = UnitName("target")
    if ( targetName == UnitName("player") ) then
        targetName = nil
    end

    local emoteStrings = {}
    for token in pairs(V_Emote.emoteCommands) do
        emoteStrings[token] = ExtendedEmoteMenu_GetEmoteString(token, targetName)
    end

    local directToken = tokenByCommand[enteredText]

    local foundTokenOrdered = {}
    local foundToken = {}

    for _,searchPattern in ipairs(SEARCH_PATTERN_ORDER) do
        searchPattern = format(searchPattern, command)

        for token,emoteString in pairs(emoteStrings) do
            if ( not foundToken[token] and token ~= directToken ) then
                if ( emoteString:lower():find(searchPattern) ) then
                    foundToken[token] = true
                    tinsert(foundTokenOrdered, token)
                end
            end
        end
    end

    if ( not foundTokenOrdered[1] and not directToken ) then
        UIMenu_AddButton(menu, L["no_emotes_found"])
        ExtendedEmoteMenu_PrettifyMenu(menu)
        return
    end

    local foundTokenCount = #foundTokenOrdered
    local foundTokenRestCount = 0
    if ( foundTokenCount > MAX_SEARCH_RESULTS ) then
        foundTokenRestCount = foundTokenCount - MAX_SEARCH_RESULTS
        for i = #foundTokenOrdered, (MAX_SEARCH_RESULTS+1), -1 do
            foundTokenOrdered[i] = nil
        end
    end

    for i=1,foundTokenCount,1 do
        local foundToken = foundTokenOrdered[i]
        if ( foundToken ) then
            local text = emoteStrings[foundToken]
            if ( text ) then
                text = HighlightFirstVisibleMatch(text, command)
                text = text:gsub("%%2%$s", targetName)
            else
                text = ExtendedEmoteMenu_GetEmoteSpecialString(foundToken)
            end
            if ( text ) then
                ExtendedEmoteMenu_AddButton(menu, text, nil, OnEmoteClick, nil, foundToken)
            end
        end
    end

    if ( foundTokenRestCount > 0 ) then
        local text = format(L["search_more_results"], foundTokenRestCount)
        local button = ExtendedEmoteMenu_AddButton(menu, text)
    end

    if ( directToken ) then
        local text = emoteStrings[directToken]
        if ( text ) then
            text = text:gsub("%%2%$s", targetName)
        else
            text = ExtendedEmoteMenu_GetEmoteSpecialString(directToken)
        end
        if ( text ) then
            if ( foundTokenCount > 0 ) then
                ExtendedEmoteMenu_AddButton(menu, "")
            end
            ExtendedEmoteMenu_AddButton(menu, text, enteredText, OnEmoteClick, nil, directToken)
        end
    end

    ExtendedEmoteMenu_PrettifyMenu(menu)

end

-----------------------------------------------------------------------------------

local events = {}

events.PLAYER_TARGET_CHANGED = function(...)
    lastEnteredText = nil
    nextUpdate = 0
end

local function OnUpdate(self, elapsed)
    if ( not IsEnabled() ) then
        return
    end
    nextUpdate = nextUpdate - elapsed
    if ( nextUpdate > 0 ) then
        return
    end
    DoUpdate()
    nextUpdate = UPDATE_INTERVAL
end

local function OnEvent(self, event, ...)
    if ( not IsEnabled() ) then
        return
    end
    local func = events[event]
    if ( func ) then
        func(...)
    end
end

local frame = CreateFrame("frame")
frame:SetScript("OnUpdate", OnUpdate)
frame:SetScript("OnEvent", OnEvent);

for e,f in pairs(events) do
    frame:RegisterEvent(e)
end

-----------------------------------------------------------------------------------

local function OnShow(self)
    if ( not IsEnabled() ) then
        return
    end

    expliciteShown = true
    lastEnteredText = nil
    nextUpdate = 0

    --local menu = ExtendedEmoteMenu_GetExtendedMenu()
    --UIMenu_StopCounting(menu)
    UIMenu_StopCounting(self)
end

local function OnHide(sub)
    if ( not IsEnabled() ) then
        return
    end
    expliciteShown = nil
end

-----------------------------------------------------------------------------------

ExtendedEmoteMenu_RegisterStructure(STRUCT_ID, {
    name = L["struct_name"],
    data = { [""] = { { items = { } } } }, -- initially empty
    onShow = OnShow,
    onHide = OnHide,
    keepShown = true,
})

-----------------------------------------------------------------------------------