
local V_Emote = _G._V_Emote
if ( not V_Emote or type(V_Emote) ~= "table") then
    _G._V_Emote = LibStub:NewLibrary("V_Emote-1.0", 2)
    return
end
_G._V_Emote = nil

local L = LibStub("AceLocale-3.0"):GetLocale("V_Emote", true)
local V_Pattern = LibStub("V_Pattern-1.0")

--------------------------------------------------------------------------------

do
    for k,list in pairs(L.strings) do
        local strings = {}
        for token,msg in pairs(list) do
            strings[token] = msg
        end
        wipe(list)
        for token,msg in pairs(strings) do
            list[token] = V_Pattern.CreateConstPattern(msg)
        end
    end
end

function V_Emote.GetStrings(type)
    local original = L.strings[type]
    if ( not original ) then
        return nil
    end
    local list = {}
    for k,v in pairs(original) do
        list[k] = v:GetString()
    end
    return list
end

--------------------------------------------------------------------------------

V_Emote.emoteAlias = {}
V_Emote.emoteAlias.RASP = "RUDE"

--------------------------------------------------------------------------------

local events = {}

--------------------------------------------------------------------------------

do

    local orderedKeys = { "SELF", "SELF_TO_OTHER", "OTHER", "OTHER_TO_SELF", "OTHER_TO_OTHER", }
    local callbacks = {}

    function events.CHAT_MSG_TEXT_EMOTE(msg, senderName)
        for _,k in ipairs(orderedKeys) do
            local list = L.strings[k]
            for token,pattern in pairs(list) do
                token = V_Emote.emoteAlias[token] or token
                local tokenFuncs = callbacks[token]
                if ( tokenFuncs ) then
                    local ok, sender, target = pattern:GetMatch(msg)
                    if ( ok ) then
                        for _, func in ipairs(tokenFuncs) do
                            func(k, sender, target)
                        end
                        return
                    end
                end
            end
        end
    end

    -- V_Emote.OnEmote("HELLO", function(type, sender, target) print(type, sender, target) end)
    function V_Emote.OnEmote(token, func)
        if ( type(token) ~= "string" ) then
            return
        end
        if ( type(func) ~= "function" ) then
            return
        end
        token = V_Emote.emoteAlias[token] or token
        callbacks[token] = callbacks[token] or {}
        tinsert(callbacks[token], func)
    end

end

--------------------------------------------------------------------------------

V_Emote.MAXEMOTEINDEX = 0
V_Emote.emoteCommands = {}

for i=1,1000,1 do
    local token = _G["EMOTE"..i.."_TOKEN"]
    if ( token ) then
        local cmds = {}
        for j=1,10,1 do
            local cmd = _G["EMOTE"..i.."_CMD"..j];
            if ( cmd ) then
                tinsert(cmds, cmd)
            end
        end
        V_Emote.emoteCommands[token] = cmds
        V_Emote.MAXEMOTEINDEX = i
    end
end

--------------------------------------------------------------------------------

-- 1 = animation
-- 2 = Sound
-- 3 = Animation + Sound
V_Emote.emoteEffects = {}
V_Emote.emoteEffects.APPLAUD = 3
V_Emote.emoteEffects.ATTACKMYTARGET = 3
V_Emote.emoteEffects.ANGRY = 1
V_Emote.emoteEffects.BASHFUL = 1
V_Emote.emoteEffects.BEG = 3
V_Emote.emoteEffects.BLUSH = 1
V_Emote.emoteEffects.BOGGLE = 1
V_Emote.emoteEffects.BORED = 2
V_Emote.emoteEffects.BOW = 1
V_Emote.emoteEffects.BYE = 3
V_Emote.emoteEffects.CACKLE = 3
V_Emote.emoteEffects.CHARGE = 3
V_Emote.emoteEffects.CHEER = 3
V_Emote.emoteEffects.CHICKEN = 3
V_Emote.emoteEffects.CHUCKLE = 3
V_Emote.emoteEffects.CLAP = 3
V_Emote.emoteEffects.COMMEND = 3
V_Emote.emoteEffects.CONFUSED = 1
V_Emote.emoteEffects.CONGRATULATE = 3
V_Emote.emoteEffects.COWER = 1
V_Emote.emoteEffects.CRY = 3
V_Emote.emoteEffects.CURIOUS = 1
V_Emote.emoteEffects.CURTSEY = 1
V_Emote.emoteEffects.DANCE = 1
V_Emote.emoteEffects.DRINK = 1
V_Emote.emoteEffects.EAT = 1
V_Emote.emoteEffects.FLEE = 3
V_Emote.emoteEffects.FLEX = 1
V_Emote.emoteEffects.FLIRT = 3
V_Emote.emoteEffects.FOLLOW = 3
V_Emote.emoteEffects.GASP = 1
V_Emote.emoteEffects.GIGGLE = 3
V_Emote.emoteEffects.GLOAT = 3
V_Emote.emoteEffects.GOLFCLAP = 3
V_Emote.emoteEffects.GREET = 1
V_Emote.emoteEffects.GROVEL = 1
V_Emote.emoteEffects.GROWL = 1
V_Emote.emoteEffects.GUFFAW = 3
V_Emote.emoteEffects.HAIL = 1
V_Emote.emoteEffects.HEALME = 3
V_Emote.emoteEffects.HELLO = 3
V_Emote.emoteEffects.HELPME = 3
V_Emote.emoteEffects.INSULT = 1
V_Emote.emoteEffects.JOKE = 3
V_Emote.emoteEffects.KISS = 3
V_Emote.emoteEffects.KNEEL = 1
V_Emote.emoteEffects.LAUGH = 3
V_Emote.emoteEffects.LAYDOWN = 1
V_Emote.emoteEffects.LOST = 1
V_Emote.emoteEffects.MAP = 1
V_Emote.emoteEffects.MOUNTSPECIAL = 3
V_Emote.emoteEffects.MOURN = 3
V_Emote.emoteEffects.NO = 3
V_Emote.emoteEffects.NOD = 3
V_Emote.emoteEffects.OOM = 3
V_Emote.emoteEffects.OPENFIRE = 3
V_Emote.emoteEffects.PLEAD = 1
V_Emote.emoteEffects.POINT = 1
V_Emote.emoteEffects.PONDER = 1
V_Emote.emoteEffects.PRAY = 1
V_Emote.emoteEffects.PUZZLE = 1
V_Emote.emoteEffects.RASP = 3
V_Emote.emoteEffects.ROAR = 3
V_Emote.emoteEffects.ROFL = 3
V_Emote.emoteEffects.ROLLEYES = 3
V_Emote.emoteEffects.RUDE = 3
V_Emote.emoteEffects.SALUTE = 1
V_Emote.emoteEffects.SEXY = 2
V_Emote.emoteEffects.SHRUG = 1
V_Emote.emoteEffects.SHY = 1
V_Emote.emoteEffects.SIGH = 2
V_Emote.emoteEffects.SLEEP = 3
V_Emote.emoteEffects.SNICKER = 2
V_Emote.emoteEffects.SURRENDER = 1
V_Emote.emoteEffects.TALK = 1
V_Emote.emoteEffects.TALKEX = 1
V_Emote.emoteEffects.TAUNT = 3
V_Emote.emoteEffects.THANK = 3
V_Emote.emoteEffects.THIRSTY = 2
V_Emote.emoteEffects.TIRED = 2
V_Emote.emoteEffects.TRAIN = 3
V_Emote.emoteEffects.VICTORY = 1
V_Emote.emoteEffects.VIOLIN = 3
V_Emote.emoteEffects.WAIT = 3
V_Emote.emoteEffects.WAVE = 1
V_Emote.emoteEffects.WELCOME = 3
V_Emote.emoteEffects.WHISTLE = 2
V_Emote.emoteEffects.YAWN = 2
V_Emote.emoteEffects.YW = 3

--------------------------------------------------------------------------------

local frame = CreateFrame("FRAME")
frame:SetScript("OnEvent", function(self, event, ...)
    if ( events[event] ) then
        events[event](...)
    end
end)
for event,v in pairs(events) do
    frame:RegisterEvent(event)
end

--------------------------------------------------------------------------------
