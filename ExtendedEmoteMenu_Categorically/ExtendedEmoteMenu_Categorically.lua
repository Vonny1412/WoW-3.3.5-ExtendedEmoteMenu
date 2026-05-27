local ADDON_NAME, ADDON = ...
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME, true)
local V_Emote = LibStub("V_Emote-1.0")
-----------------------------------------------------------------------------------

local STRUCT_ID = "categorically"

-----------------------------------------------------------------------------------

local struct = {}
struct[""] = {
    {
        header = format(L["format_header"], L["social"]),
        items = {
            { nested = 1, text = format(L["format_button3"], L["greeting"], L["farewell"], L["commands"]) },
            { nested = 2, text = format(L["format_button3"], L["conversation"], L["agreement"], L["rejection"]) },
            { nested = 3, text = format(L["format_button3"], L["encouragement"], L["gratitude"], L["praise"]) },
            { nested = 4, text = format(L["format_button2"], L["affection"], L["flirting"]) },
        },
    },
    {
        header = format(L["format_header"], L["expression"]),
        items = {
            { nested = 5, text = format(L["format_button3"], L["facial"], L["signals"], L["movement"]) },
            { nested = 6, text = format(L["format_button2"], L["actions"], L["interaction"]) },
            { nested = 7, text = format(L["format_button2"], L["instincts"], L["bestial"]) },
            { nested = 8, text = format(L["format_button2"], L["entertaining"], L["silly"]) },
        },
    },
    {
        header = format(L["format_header"], L["mood"]),
        items = {
            { nested = 9, text = format(L["format_button4"], L["hungry"], L["thirsty"], L["tired"], L["cold"]) },
            { nested = 10, text = format(L["format_button2"], L["cheerful"], L["gloating"]) },
            { nested = 11, text = format(L["format_button3"], L["sad"], L["remorseful"], L["submissive"]) },
            { nested = 12, text = format(L["format_button3"], L["curious"], L["uncertain"], L["skeptical"]) },
            { nested = 13, text = format(L["format_button3"], L["irritated"], L["angry"], L["mocking"]) },
            { nested = 14, text = format(L["format_button3"], L["fearful"], L["disappointed"], L["embarrassed"]) },
            { nested = 15, text = format(L["format_button3"], L["impatient"], L["sulking"], L["distant"]) },
            { nested = 16, text = format(L["format_button3"], L["nervous"], L["confused"], L["amazed"]) },
        },
    },
    {
        header = format(L["format_header"], L["confrontation"]),
        items = {
            { nested = 17, text = format(L["format_button3"], L["provoking"], L["threatening"], L["insulting"]) },
            { nested = 18, text = format(L["format_button1"], L["combat"]) },
        },
    },
    {
        header = format(L["format_header"], L["special"]),
        items = {
            { value = "MOUNTSPECIAL", text = "/mountspecial" },
        },
    },
}

struct[1] = {
    {
        header = format(L["format_header"], L["greeting"]),
        items = {
            { value = "WELCOME" },
            { value = "GREET" },
            { value = "HELLO" },
            { value = "HAIL" },
            { value = "SALUTE" },
            { value = "INTRODUCE" },
        },
    },
    {
        header = format(L["format_header"], L["farewell"]),
        items = {
            { value = "BYE" },
            { value = "GOING" },
            { value = "BRB" },
        },
    },
    {
        header = format(L["format_header"], L["commands"]),
        items = {
            { value = "WAIT" },
            { value = "GO" },
            { value = "BECKON" },
            { value = "SILENCE" },
            { value = "WARN" },
            { value = "SHOO" },
        },
    },
}

struct[2] = {
    {
        header = format(L["format_header"], L["conversation"]),
        items = {
            { value = "LISTEN" },
            { value = "TALKQ" },
            { value = "TALK" },
            { value = "TALKEX" },
            { value = "OFFER" },
            { value = "PROMISE" },
        },
    },
    {
        header = format(L["format_header"], L["agreement"]),
        items = {
            { value = "NOD" },
            { value = "AGREE" },
        },
    },
    {
        header = format(L["format_header"], L["rejection"]),
        items = {
            { value = "NO" },
            { value = "DISAGREE" },
            { value = "OBJECT" },
            { value = "VETO" },
        },
    },
}

struct[3] = {
    {
        header = format(L["format_header"], L["encouragement"]),
        items = {
            { value = "CALM" },
            { value = "BREATH" },
            { value = "ENCOURAGE" },
            { value = "LUCK" },
            { value = "PRAY" },
        },
    },
    {
        header = format(L["format_header"], L["gratitude"]),
        items = {
            { value = "THANK" },
            { value = "YW" },
        },
    },
    {
        header = format(L["format_header"], L["praise"]),
        items = {
            { value = "AWE" },
            { value = "CLAP" },
            { value = "CHEER" },
            { value = "APPLAUD" },
            { value = "CONGRATULATE" },
            { value = "PROUD" },
            { value = "COMMEND" },
            { value = "PRAISE" },
            { value = "DING" },
        },
    },
}

struct[4] = {
    {
        header = format(L["format_header"], L["affection"]),
        items = {
            { value = "PAT" },
            { value = "HUG" },
            { value = "CUDDLE" },
            { value = "MASSAGE" },
            { value = "PET" },
            { value = "HOLDHAND" },
            { value = "TICKLE" },
            { value = "COMFORT" },
            { value = "SOOTHE" },
        },
    },
    {
        header = format(L["format_header"], L["flirting"]),
        items = {
            { value = "KISS" },
            { value = "FLIRT" },
            { value = "CHARM" },
            { value = "WINK" },
            { value = "SEXY" },
            { value = "LOVE" },
            { value = "SHAKE" },
            { value = "MOAN" },
        },
    },
}

struct[5] = {
    {
        header = format(L["format_header"], L["facial"]),
        items = {
            { value = "LOOK" },
            { value = "STARE" },
            { value = "BLINK" },
        },
    },
    {
        header = format(L["format_header"], L["signals"]),
        items = {
            { value = "POINT" },
            { value = "WAVE" },
            { value = "SNAP" },
            { value = "WHISTLE" },
            { value = "RAISE" },
            { value = "HIGHFIVE" },
            { value = "SHOUT" },
        },
    },
    {
        header = format(L["format_header"], L["movement"]),
        items = {
            { value = "CURTSEY" },
            { value = "BOW" },
            { value = "KNEEL" },
            { value = "LAYDOWN" },
            { value = "DUCK" },
            { value = "BOUNCE" },
            { value = "POUNCE" },
            { value = "SNEAK" },
            { value = "FLEX" },
        },
    },
}

struct[6] = {
    {
        header = format(L["format_header"], L["actions"]),
        items = {
            { value = "MAP" },
            { value = "BACKPACK" },
            { value = "SEARCH" },
            { value = "WORK" },
            { value = "PULSE" },
        },
    },
    {
        header = format(L["format_header"], L["interaction"]),
        items = {
            { value = "RUFFLE" },
            { value = "POKE" },
            { value = "ARM" },
            { value = "PUNCH" },
            { value = "PINCH" },
            { value = "BONK" },
            { value = "SMACK" },
            { value = "SLAP" },
            { value = "COVEREARS" },
        },
    },
}

struct[7] = {
    {
        header = format(L["format_header"], L["instincts"]),
        items = {
            { value = "SNIFF" },
            { value = "SCRATCH" },
            { value = "BITE" },
            { value = "GASP" },
            { value = "COUGH" },
            { value = "GROAN" },
            { value = "LICK" },
            { value = "DROOL" },
            { value = "HICCUP" },
        },
    },
    {
        header = format(L["format_header"], L["bestial"]),
        items = {
            { value = "PURR" },
            { value = "HISS" },
            { value = "BARK" },
            { value = "GROWL" },
            { value = "SNARL" },
            { value = "ROAR" },
            { value = "SQUEAL" },
            { value = "MOO" },
        },
    },
}

struct[8] = {
    {
        header = format(L["format_header"], L["entertaining"]),
        items = {
            { value = "JOKE" },
            { value = "JK" },
            { value = "DANCE" },
            { value = "SHIMMY" },
            { value = "SING" },
        },
    },
    {
        header = format(L["format_header"], L["silly"]),
        items = {
            { value = "TRAIN" },
            { value = "MOON" },
            { value = "FART" },
            { value = "NOSEPICK" },
            { value = "RUDE" },
--            { value = "RASP" },
            { value = "TEASE" },
        },
    },
}

struct[9] = {
    {
        header = format(L["format_header"], L["hungry"]),
        items = {
            { value = "HUNGRY" },
            { value = "EAT" },
            { value = "BURP" },
        },
    },
    {
        header = format(L["format_header"], L["thirsty"]),
        items = {
            { value = "THIRSTY" },
            { value = "DRINK" },
            { value = "CHUG" },
        },
    },
    {
        header = format(L["format_header"], L["tired"]),
        items = {
            { value = "YAWN" },
            { value = "TIRED" },
            { value = "SLEEP" },
        },
    },
    {
        header = format(L["format_header"], L["cold"]),
        items = {
            { value = "SHIVER" },
            { value = "COLD" },
            { value = "SNEEZE" },
        },
    },
}

struct[10] = {
    {
        header = format(L["format_header"], L["cheerful"]),
        items = {
            { value = "SMILE" },
            { value = "HAPPY" },
            { value = "GIGGLE" },
            { value = "SNICKER" },
            { value = "CHUCKLE" },
            { value = "CACKLE" },
            { value = "LAUGH" },
        },
    },
    {
        header = format(L["format_header"], L["gloating"]),
        items = {
            { value = "GRIN" },
            { value = "SMIRK" },
            { value = "SCOFF" },
            { value = "GUFFAW" },
            { value = "ROFL" },
            { value = "GLOAT" },
            { value = "MOCK" },
        },
    },
}

struct[11] = {
    {
        header = format(L["format_header"], L["sad"]),
        items = {
            { value = "SAD" },
            { value = "CRY" },
            { value = "WHINE" },
            { value = "MOURN" },
        },
    },
    {
        header = format(L["format_header"], L["remorseful"]),
        items = {
            { value = "APOLOGIZE" },
            { value = "MERCY" },
            { value = "REGRET" },
        },
    },
    {
        header = format(L["format_header"], L["submissive"]),
        items = {
            { value = "PLEAD" },
            { value = "BEG" },
            { value = "GROVEL" },
        },
    },
}

struct[12] = {
    {
        header = format(L["format_header"], L["curious"]),
        items = {
            { value = "EYEBROW" },
            { value = "CURIOUS" },
        },
    },
    {
        header = format(L["format_header"], L["uncertain"]),
        items = {
            { value = "SHRUG" },
            { value = "THINK" },
            { value = "PONDER" },
            { value = "LOST" },
        },
    },
    {
        header = format(L["format_header"], L["skeptical"]),
        items = {
            { value = "EYE" },
            { value = "SHIFTY" },
            { value = "PEER" },
            { value = "SUSPICIOUS" },
            { value = "BOGGLE" },
            { value = "DOUBT" },
            { value = "BADFEELING" },
        },
    },
}

struct[13] = {
    {
        header = format(L["format_header"], L["irritated"]),
        items = {
            { value = "SCOWL" },
            { value = "SCOLD" },
            { value = "MUTTER" },
            { value = "SNORT" },
            { value = "GLOWER" },
            { value = "HEADACHE" },
        },
    },
    {
        header = format(L["format_header"], L["angry"]),
        items = {
            { value = "ANGRY" },
            { value = "GLARE" },
            { value = "BLAME" },
        },
    },
    {
        header = format(L["format_header"], L["mocking"]),
        items = {
            { value = "ROLLEYES" },
            { value = "FACEPALM" },
            { value = "GOLFCLAP" },
            { value = "VIOLIN" },
            { value = "PITY" },
        },
    },
}

struct[14] = {
    {
        header = format(L["format_header"], L["fearful"]),
        items = {
            { value = "SCARED" },
            { value = "SHUDDER" },
            { value = "CRINGE" },
            { value = "COWER" },
            { value = "PANIC" },
        },
    },
    {
        header = format(L["format_header"], L["disappointed"]),
        items = {
            { value = "SIGH" },
            { value = "FROWN" },
        },
    },
    {
        header = format(L["format_header"], L["embarrassed"]),
        items = {
            { value = "SHY" },
            { value = "BLUSH" },
            { value = "EMBARRASS" },
            { value = "BASHFUL" },
        },
    },
}

struct[15] = {
    {
        header = format(L["format_header"], L["impatient"]),
        items = {
            { value = "TWIDDLE" },
            { value = "BORED" },
            { value = "FIDGET" },
            { value = "TAP" },
            { value = "HURRY" },
        },
    },
    {
        header = format(L["format_header"], L["sulking"]),
        items = {
            { value = "POUT" },
            { value = "CROSSARMS" },
            { value = "FLOP" },
            { value = "JEALOUS" },
        },
    },
    {
        header = format(L["format_header"], L["distant"]),
        items = {
            { value = "GAZE" },
            { value = "ABSENT" },
            { value = "BLANK" },
        },
    },
}

struct[16] = {
    {
        header = format(L["format_header"], L["nervous"]),
        items = {
            { value = "NERVOUS" },
            { value = "SWEAT" },
            { value = "FAINT" },
        },
    },
    {
        header = format(L["format_header"], L["confused"]),
        items = {
            { value = "CONFUSED" },
            { value = "PUZZLE" },
        },
    },
    {
        header = format(L["format_header"], L["amazed"]),
        items = {
            { value = "SURPRISED" },
            { value = "AMAZE" },
            { value = "IDEA" },
        },
    },
}

struct[17] = {
    {
        header = format(L["format_header"], L["provoking"]),
        items = {
            { value = "BRANDISH" },
            { value = "CHALLENGE" },
            { value = "TAUNT" },
            { value = "CHICKEN" },
        },
    },
    {
        header = format(L["format_header"], L["threatening"]),
        items = {
            { value = "THREATEN" },
            { value = "CRACK" },
            { value = "SHAKEFIST" },
        },
    },
    {
        header = format(L["format_header"], L["insulting"]),
        items = {
            { value = "SPIT" },
            { value = "SNUB" },
            { value = "INSULT" },
            { value = "STINK" },
        },
    },
}

struct[18] = {
    {
        header = format(L["format_header"], L["combat1"]),
        items = {
            { value = "INCOMING" },
            { value = "ENEMY" },
            { value = "FLEE" },
            { value = "READY" },
            { value = "OPENFIRE" },
            { value = "SIGNAL" },
            { value = "FOLLOW" },
            { value = "ATTACKMYTARGET" },
        },
    },
    {
        header = format(L["format_header"], L["combat2"]),
        items = {
            { value = "CHARGE" },
            { value = "OOM" },
            { value = "HEALME" },
            { value = "HELPME" },
            { value = "BLEED" },
        },
    },
    {
        header = format(L["format_header"], L["combat3"]),
        items = {
            { value = "VICTORY" },
            { value = "TRUCE" },
            { value = "SURRENDER" },
            { value = "REVENGE" },
        },
    },
}


local effectShorts = {}
effectShorts[1] = format(L["format_header"], "[A]")
effectShorts[2] = format(L["format_header"], "[S]")
effectShorts[3] = format(L["format_header"], "[AS]")

for _,page in pairs(struct) do
    for _,group in pairs(page) do
        if ( group.items ) then
            for _,item in pairs(group.items) do
                local token = item.value
                if ( token ) then
                    local effect = V_Emote.emoteEffects[token]
                    if ( effect ) then
                        item.shortcut = effectShorts[effect]
                    end
                end
            end
        end
    end
end

-----------------------------------------------------------------------------------

ExtendedEmoteMenu_RegisterStructure(STRUCT_ID, {
    name = L["struct_name"],
    data = struct,
    onUpdateButton = ExtendedEmoteMenu_UpdateButtonText,
})

-----------------------------------------------------------------------------------
