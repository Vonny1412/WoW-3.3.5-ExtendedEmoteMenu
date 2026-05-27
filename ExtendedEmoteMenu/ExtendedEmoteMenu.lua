local ADDON_NAME, ADDON = ...
local V_Addon = LibStub("V_Addon-1.0")
-----------------------------------------------------------------------------------

V_Addon.InstallEventHandler(ADDON)
V_Addon.InstallNamespaces(ADDON, {
    "Database",
    "Core",
})

ADDON:RegisterEvent("ADDON_LOADED", function(addonName)
    if ( addonName ~= ADDON_NAME ) then
        return
    end
    ADDON:InitializeNamespaces()
end)

-----------------------------------------------------------------------------------
