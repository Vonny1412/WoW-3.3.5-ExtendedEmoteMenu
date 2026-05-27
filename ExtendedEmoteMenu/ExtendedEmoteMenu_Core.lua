local ADDON_NAME, ADDON = ...
local ADDON_Core = ADDON.Core
local ADDON_DB = ADDON.Database
local V_Addon = LibStub("V_Addon-1.0")
local V_Emote = LibStub("V_Emote-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME, true)
-----------------------------------------------------------------------------------

local MENU_TIMEOUT = 5
local ICON_EXPAND = "|T"..[[Interface\ChatFrame\ChatFrameExpandArrow]]..":0|t"
local ICON_CHECKED = "|T"..[[Interface\Buttons\UI-CheckBox-Check]]..":0|t"

local registeredStructures = {}
local selectedStructure = nil

local stringsSelf = V_Emote.GetStrings("SELF")
local stringsSelfToOther = V_Emote.GetStrings("SELF_TO_OTHER")

-----------------------------------------------------------------------------------

function ExtendedEmoteMenu_GetExtendedMenuName(id)
    return "ExtendedEmoteMenu"..(id or "")
end

function ExtendedEmoteMenu_GetExtendedMenu(id)
    return _G[ExtendedEmoteMenu_GetExtendedMenuName(id)]
end

function ExtendedEmoteMenu_IsShown()
    local menu = ExtendedEmoteMenu_GetExtendedMenu()
    if ( menu ) then
        return menu:IsShown()
    end
    return false
end

function ExtendedEmoteMenu_Show()
    local menu = ExtendedEmoteMenu_GetExtendedMenu()
    if ( not menu or ExtendedEmoteMenu_IsShown() ) then
        return
    end
    menu:Show()
end

function ExtendedEmoteMenu_Hide()
    local menu = ExtendedEmoteMenu_GetExtendedMenu()
    if ( not menu or not ExtendedEmoteMenu_IsShown() ) then
        return
    end
    menu:Hide()
end

function ExtendedEmoteMenu_Toggle()
    if ( ExtendedEmoteMenu_IsShown() ) then
        ExtendedEmoteMenu_Hide()
    else
        ExtendedEmoteMenu_Show()
    end
end

function ExtendedEmoteMenu_OnEmoteClick(self)
    DoEmote(self.value)
end

function ExtendedEmoteMenu_UpdateButtonText(button, text)
    button:SetText(text)
end

function ExtendedEmoteMenu_UpdateButtonShortcut(button, text)
    local shortcutString = getglobal(button:GetName().."ShortcutText")
    shortcutString:SetText(text)
    shortcutString:Show()
end

function ExtendedEmoteMenu_GetEmoteString(token, target)
    if ( not token ) then
        return nil
    end
    local string = nil
    if ( target ) then
        string = stringsSelfToOther[token] or stringsSelf[token] or nil
    else
        string = stringsSelf[token] or nil
    end
    --if ( not string ) then
    --    string = L["special_token"][token]
    --end
    return string
end

function ExtendedEmoteMenu_GetEmoteSpecialString(token)
    if ( not token ) then
        return nil
    end
    local string = L["special_token"][token]
    return string
end

-----------------------------------------------------------------------------------

function ExtendedEmoteMenu_RegisterStructure(id, struct)
    registeredStructures[id] = struct
end

function ExtendedEmoteMenu_GetSelectedStructureID()
    return ADDON_DB.GetSelectedStructure()
end

local function GetRandomStructureID()
    -- make it random just for the fun
    local ids = {}
    for id,_ in pairs(registeredStructures) do
        ids[#ids + 1] = id
    end
    if ( #ids == 0 ) then
        return nil
    end
    return ids[math.random(#ids)]
end

local function SelectStructure(structID)
    if ( structID and not registeredStructures[structID] ) then
        structID = nil
    end
    if ( not structID ) then
        --structID = GetRandomStructureID()
        structID = "categorically"
    end
    if ( not structID ) then
        error("ExtendedEmoteMenu: No menu structures installed.")
    end

    selectedStructure = registeredStructures[structID]
    ADDON_DB.SetSelectedStructure(structID)

    -- update
    local menu = ExtendedEmoteMenu_GetExtendedMenu("StructureMenu")
    if ( menu ) then
        for id=1,menu.numButtons,1 do
            local button = getglobal(menu:GetName().."Button"..id)
            local shortcutString = getglobal(button:GetName().."ShortcutText")
            if ( button.value == structID ) then
                shortcutString:Show()
            else
                shortcutString:Hide()
            end
        end
    end
end

local function GetStructure()
    if ( selectedStructure ) then
        return selectedStructure
    end
    local id = ADDON_DB.GetSelectedStructure()
    SelectStructure(id)
    return selectedStructure
end

-----------------------------------------------------------------------------------

function ExtendedEmoteMenu_ClearMenu(self)
    for id=1,self.numButtons,1 do
        local button = getglobal(self:GetName().."Button"..id)
        button:SetText(nil)
        button.func = nil
        button.nested = nil
        button.value = nil
        button.keepShownOnClick = nil -- custom property
        button.dontUpdate = nil -- custom property
        button:Hide()
        button:Enable()
        local shortcutString = getglobal(button:GetName().."ShortcutText")
        shortcutString:SetText(nil)
        shortcutString:Hide()
    end
    self.numButtons = 0;
    self:SetHeight((0 * UIMENU_BUTTON_HEIGHT) + (UIMENU_BORDER_HEIGHT * 2))
end

function ExtendedEmoteMenu_PrettifyMenu(self)
    for id=1,self.numButtons,1 do
        local button = getglobal(self:GetName().."Button"..id)
        local buttonText = button:GetText()
        if ( not buttonText ) then
            --button:Disable()
        end
        if ( button.nested ) then
            local shortcutString = getglobal(button:GetName().."ShortcutText")
            shortcutString:SetText(ICON_EXPAND)
            shortcutString:Show()
        end
        if ( button.func == nil ) then
            button:SetScript("OnClick", nil)
            if ( buttonText and not button.nested ) then
                --button:EnableMouse(false)
                button:Disable()
            end
        else
            button:SetScript("OnClick", UIMenuButton_OnClick)
        end
    end
    UIMenu_AutoSize(self)
end

-----------------------------------------------------------------------------------

local extendedMenus = {}
local extendedMenusParents = {}

function ExtendedEmoteMenu_AddButton(self, text, shortcut, func, nested, value, ...)
    UIMenu_AddButton(self, text, shortcut, func, nested, value, ...)
    local button = getglobal(self:GetName().."Button"..self.numButtons)
    if ( value and text ) then
        button.dontUpdate = 1
    end
    return button
end

local function CreateMenu(struct, id, saveInList)
    local sections = struct[id]
    if ( not sections ) then
        -- todo error
        return
    end

    local selfName = ExtendedEmoteMenu_GetExtendedMenuName(id)
    local parent = extendedMenusParents[selfName] or {
        frame = UIParent,
        menu = nil,
    }

    local self = _G[selfName] or CreateFrame("Frame", selfName, parent.frame, "UIMenuTemplate")
    self:SetClampedToScreen(true)
    self:Hide()

    UIMenu_Initialize(self)
    self.parentMenu = parent.menu
    self.chatFrame = DEFAULT_CHAT_FRAME

    if ( saveInList ) then
        extendedMenus[id] = self
    end

    for s,sect in ipairs(sections) do

        if ( sect.header ) then
            UIMenu_AddButton(self, sect.header)
        end

        for i,item in ipairs(sect.items) do

            local func = item.func or ( item.value and ExtendedEmoteMenu_OnEmoteClick ) or nil
            local nestedName = item.nested and ExtendedEmoteMenu_GetExtendedMenuName(item.nested) or nil
            local button = ExtendedEmoteMenu_AddButton(self, item.text, item.shortcut, func, nestedName, item.value)
            button.keepShownOnClick = true


            if ( nestedName ) then
                extendedMenusParents[nestedName] = {
                    frame = self,
                    menu = selfName,
                }
                CreateMenu(struct, item.nested, saveInList)
            end

        end

        if ( s < #sections ) then
            UIMenu_AddButton(self) -- spacer
        end
    end

    ExtendedEmoteMenu_PrettifyMenu(self)
    return self
end

local function RecreateWholeMenu()

    for id,menu in pairs(extendedMenus) do
        ExtendedEmoteMenu_ClearMenu(menu)
    end
    extendedMenus = {}

    local struct = GetStructure() -- load structure
    CreateMenu(struct.data, "", true) -- "" is always entry point

    local mainMenu = ExtendedEmoteMenu_GetExtendedMenu()
    if ( FCF_GetButtonSide(DEFAULT_CHAT_FRAME) == "right" ) then
        mainMenu:ClearAllPoints();
        mainMenu:SetPoint("BOTTOMRIGHT", ChatFrameMenuButton, "TOPLEFT");
    else
        mainMenu:ClearAllPoints();
        mainMenu:SetPoint("BOTTOMLEFT", ChatFrameMenuButton, "TOPRIGHT");
    end
end

-----------------------------------------------------------------------------------

function ExtendedEmoteMenu_LocalizeMenu(self)

    local targetName = UnitName("target")
    if ( targetName == UnitName("player") ) then
        targetName = nil
    end

    local struct = GetStructure()
    local onUpdateButton = struct.onUpdateButton
    if ( not onUpdateButton ) then
        return
    end

    local selfs = {}
    if ( self ) then
        tinsert(selfs, self)
    else
        for _,self in pairs(extendedMenus) do
            tinsert(selfs, self)
        end
    end
    for _,self in pairs(selfs) do

        for id=1,self.numButtons,1 do
            local button = getglobal(self:GetName().."Button"..id)
            local token = button.value
            if ( token and not button.dontUpdate ) then
                local string = ExtendedEmoteMenu_GetEmoteString(token, targetName) or ExtendedEmoteMenu_GetEmoteSpecialString(token)
                local text = string:gsub("%%2%$s", targetName)
                onUpdateButton(button, text)
                button:Show()
            end
        end

        UIMenu_AutoSize(self)
    end
end

-----------------------------------------------------------------------------------

-- create structure selection menu
local function CreateStructureSelectMenu()

    local function SelectStructureButtonClicked(button)
        local structID = button.value
        SelectStructure(structID)
        RecreateWholeMenu()
    end

    local items = {}
    for id,struct in pairs(registeredStructures) do
        tinsert(items, {
            text = struct.name,
            func = SelectStructureButtonClicked,
            value = id,
            shortcut = ICON_CHECKED,
            keepShownOnClick = true,
        })
    end

    local menu = CreateMenu({StructureMenu={
        {
            items = items
        }
    }}, "StructureMenu", false)

    menu.parentMenu = "ChatMenu"

end

-----------------------------------------------------------------------------------

hooksecurefunc(ChatMenu, "Show", function()
    for k,m in pairs(extendedMenus) do
        m:Hide()
    end
end)

hooksecurefunc("UIMenuButton_OnClick", function(self)
    if ( self.keepShownOnClick ) then
        local parent = self:GetParent()
        parent:Show();
        UIMenu_StopCounting(parent)
    end
end)

hooksecurefunc("UIMenu_StartCounting", function(self)
    if ( not ExtendedEmoteMenu_IsShown() ) then
        return
    end
    local struct = GetStructure()
    if ( struct.keepShown ) then
        self.timeleft = UIMENU_TIMEOUT;
        self.counting = 0;
    end
end)

ADDON:RegisterEvent("PLAYER_LOGIN", function(addonName)

    CreateStructureSelectMenu()

    RecreateWholeMenu() -- create menu initially
    local mainMenu = ExtendedEmoteMenu_GetExtendedMenu()
    mainMenu.onlyAutoHideSelf = true

    mainMenu:SetScript("OnShow", function(self)
        self.timeleft = MENU_TIMEOUT;
        self.counting = 0;

        ExtendedEmoteMenu_GetExtendedMenu("StructureMenu"):Hide()

        ChatMenu:Hide()
        EmoteMenu:Hide()
        LanguageMenu:Hide()
        VoiceMacroMenu:Hide()
        ExtendedEmoteMenu_LocalizeMenu()

        local struct = GetStructure()
        if ( struct.onShow ) then
            struct.onShow(mainMenu)
        end
    end)

    mainMenu:SetScript("OnHide", function(self)
        local struct = GetStructure()
        if ( struct.onHide ) then
            struct.onHide(mainMenu)
        end
    end)

end)

ADDON:RegisterEvent("PLAYER_TARGET_CHANGED", function()
    if ( ExtendedEmoteMenu_IsShown() ) then
        ExtendedEmoteMenu_LocalizeMenu()
    end
end)

ChatFrameMenuButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
ChatFrameMenuButton:SetScript("OnClick", function(self, button)
    PlaySound("igChatEmoteButton")
    if ( button == "RightButton" ) then
        ChatFrame_OpenMenu()
    else
        ExtendedEmoteMenu_Toggle()
    end
end)

-- rebuild ChatMenu
do
    local self = ChatMenu
    ExtendedEmoteMenu_ClearMenu(self)

    UIMenu_AddButton(self, SAY_MESSAGE, SLASH_SAY1, ChatMenu_Say)
    UIMenu_AddButton(self, PARTY_MESSAGE, SLASH_PARTY1, ChatMenu_Party)
    UIMenu_AddButton(self, RAID_MESSAGE, SLASH_RAID1, ChatMenu_Raid)
    UIMenu_AddButton(self, BATTLEGROUND_MESSAGE, SLASH_BATTLEGROUND1, ChatMenu_Battleground)
    UIMenu_AddButton(self, GUILD_MESSAGE, SLASH_GUILD1, ChatMenu_Guild)
    UIMenu_AddButton(self, YELL_MESSAGE, SLASH_YELL1, ChatMenu_Yell)
    UIMenu_AddButton(self, WHISPER_MESSAGE, SLASH_WHISPER1, ChatMenu_Whisper)
    UIMenu_AddButton(self, REPLY_MESSAGE, SLASH_REPLY1, ChatMenu_Reply)
    UIMenu_AddButton(self, nil, nil, nil)
    UIMenu_AddButton(self, LANGUAGE, nil, nil, "LanguageMenu")
    UIMenu_AddButton(self, MACRO, SLASH_MACRO1, ShowMacroFrame)
    UIMenu_AddButton(self, nil, nil, nil)
    UIMenu_AddButton(self, EMOTE_MESSAGE, nil, nil, ExtendedEmoteMenu_GetExtendedMenuName("StructureMenu"))

    ExtendedEmoteMenu_PrettifyMenu(self)
end

-----------------------------------------------------------------------------------
