local ADDON_NAME, ADDON = ...
local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(ADDON_NAME, "deDE")
if ( not L ) then return end
-----------------------------------------------------------------------------------

-- ä \195\164
-- ö \195\182
-- ü \195\188
-- Ä \195\132
-- Ö \195\150
-- Ü \195\156
-- ß \195\159

L["special_token"] = {
    MOUNTSPECIAL = "(Aufbäum-Animation für die meisten Reittiere)",
    PROMISE = "(PROMISE benötigt ein Ziel)",
    TRAIN = "(\"Choo-Choo-Zug\"-Animation und Geräusch)",
}

----------------------------------------------------------
