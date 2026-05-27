local ADDON_NAME, ADDON = ...
local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(ADDON_NAME, "enUS", true)
if ( not L ) then return end
-----------------------------------------------------------------------------------

L["struct_name"] = "Quick Search"

L["search_hint"] = "Use /... to search for emotes"
L["no_emotes_found"] = "No matching emotes found"
L["search_more_results"] = "And %d more..."

-----------------------------------------------------------------------------------
