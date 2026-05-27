local ADDON_NAME, ADDON = ...
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME, true)
local V_Emote = LibStub("V_Emote-1.0")
-----------------------------------------------------------------------------------

local STRUCT_ID = "alphabetically"

-----------------------------------------------------------------------------------

local struct = {}
do

    local MAX_ITEMS_PER_MENU = 32

    local tokenByCommand = {}
    local commands = {}

    for token,cmds in pairs(V_Emote.emoteCommands) do
        local cmd = cmds[1]:lower()
        if ( cmd ) then
            tokenByCommand[cmd] = token
            tinsert(commands, cmd)
        end
    end

    table.sort(commands)

    local commandsByChar = {}
    local chars = "abcdefghijklmnopqrstuvwxyz"

    local mainItems = {}
    struct[""] = {
        {
            items = mainItems,
        },
    }

    for i = 1, #chars do
        local c = string.sub(chars, i, i)
        commandsByChar[c] = {}
    end

    for _, cmd in ipairs(commands) do
        local c = string.sub(cmd, 2, 2):lower()
        if ( commandsByChar[c] ) then
            tinsert(commandsByChar[c], cmd)
        end
    end

    local nestedCounter = 0

    local function GetRangeLabel(firstCmd, lastCmd)
        local firstPrefix = string.sub(firstCmd, 2, 3):upper()
        local lastPrefix = string.sub(lastCmd, 2, 3):upper()

        return firstPrefix .. "-" .. lastPrefix
    end

    local function AddMenuGroup(label, groupCommands)
        nestedCounter = nestedCounter + 1

        tinsert(mainItems, {
            text = label,
            nested = nestedCounter,
        })

        local emoteItems = {}
        struct[nestedCounter] = {
            {
                items = emoteItems,
            },
        }

        for _,cmd in ipairs(groupCommands) do
            tinsert(emoteItems, {
                text = cmd,
                value = tokenByCommand[cmd],
                shortcut = nil, -- gets updated automatically
            })
        end
    end

    local function mod(a, b)
        return a - math.floor(a / b) * b
    end

    local function AddSplitMenuGroups(groupCommands)
        local count = #groupCommands
        local numGroups = math.ceil(count / MAX_ITEMS_PER_MENU)
        local baseSize = math.floor(count / numGroups)
        local remainder = mod(count, numGroups)

        local startIndex = 1

        for groupIndex = 1, numGroups do
            local groupSize = baseSize

            if ( groupIndex <= remainder ) then
                groupSize = groupSize + 1
            end

            local endIndex = startIndex + groupSize - 1

            local chunk = {}

            for i = startIndex, endIndex do
                tinsert(chunk, groupCommands[i])
            end

            local firstCmd = groupCommands[startIndex]
            local lastCmd = groupCommands[endIndex]
            local label = GetRangeLabel(firstCmd, lastCmd)

            AddMenuGroup(label, chunk)

            startIndex = endIndex + 1
        end
    end

    for i = 1, #chars do
        local c = string.sub(chars, i, i)
        local groupCommands = commandsByChar[c]

        if ( #groupCommands > 0 ) then
            if ( #groupCommands > MAX_ITEMS_PER_MENU ) then
                AddSplitMenuGroups(groupCommands)
            else
                AddMenuGroup(c:upper(), groupCommands)
            end
        else
            tinsert(mainItems, {
                text = c:upper(),
                nested = nil,
            })
        end
    end

end

-----------------------------------------------------------------------------------

ExtendedEmoteMenu_RegisterStructure(STRUCT_ID, {
    name = L["struct_name"],
    data = struct,
    onUpdateButton = ExtendedEmoteMenu_UpdateButtonShortcut,
})

-----------------------------------------------------------------------------------