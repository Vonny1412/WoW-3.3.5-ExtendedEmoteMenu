local ADDON_NAME, ADDON = ...
local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(ADDON_NAME, "enUS", true)
if ( not L ) then return end
-----------------------------------------------------------------------------------

L["special_token"] = {
    MOUNTSPECIAL = "(Rear-up animation for most mounts)",
    PROMISE = "(PROMISE requires a target)",
    TRAIN = "(\"Choo Choo Train\" animation and sound)",
}

-----------------------------------------------------------------------------------
