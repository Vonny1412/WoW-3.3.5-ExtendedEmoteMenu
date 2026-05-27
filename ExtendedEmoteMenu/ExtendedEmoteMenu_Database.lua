local ADDON_NAME, ADDON = ...
local ADDON_DB = ADDON.Database
local V_Table = LibStub("V_Table-1.0")
-----------------------------------------------------------------------------------

local DATABASE_DEFAULT = {
    dbv = 1,
    selectedStructure = nil,
}

-----------------------------------------------------------------------------------

function ADDON_DB.OnInitializeNamespace()
    if ( ExtendedEmoteMenuDB == nil ) then
        ExtendedEmoteMenuDB = V_Table.CopyTable(DATABASE_DEFAULT)
    else
        ExtendedEmoteMenuDB = V_Table.ApplyDefaults(ExtendedEmoteMenuDB, DATABASE_DEFAULT)
    end
    --if ( ADDON_DB.UpdateToVersion(12345) ) then
    --end
end

-----------------------------------------------------------------------------------

function ADDON_DB.GetDefaultVersion()
    return DATABASE_DEFAULT.dbv
end

function ADDON_DB.GetCurrentVersion()
    return ExtendedEmoteMenuDB.dbv
end

function ADDON_DB.SetCurrentVersion(v)
    ExtendedEmoteMenuDB.dbv = v
end

function ADDON_DB.UpdateToVersion(toVersion)
    if ( ADDON_DB.GetCurrentVersion() < toVersion ) then
        ADDON_DB.SetCurrentVersion(toVersion)
        return true
    end
    return false
end

-----------------------------------------------------------------------------------

function ADDON_DB.GetSelectedStructure()
    return ExtendedEmoteMenuDB.selectedStructure
end

function ADDON_DB.SetSelectedStructure(to)
    ExtendedEmoteMenuDB.selectedStructure = to
end

-----------------------------------------------------------------------------------
