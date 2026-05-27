local V_Addon = LibStub:NewLibrary("V_Addon-1.0", 0)
if ( not V_Addon ) then return end
--------------------------------------------------------------------------------

function V_Addon.InstallEventHandler(obj)
    if ( type(obj) ~= "table" ) then return end
    if ( obj._V_eventHandlerInstalled ) then return end
    obj._V_eventHandlerInstalled = true

    local events = {}
    local eventsFrame = CreateFrame("FRAME")
    local onUpdate = {}

    eventsFrame:SetScript("OnEvent", function(self, event, ...)
        local list = events[event] or {}
        for i,func in ipairs(list) do
            func(...)
        end
    end)

    eventsFrame:SetScript("OnUpdate", function(self, ...)
        local drop = {}
        for k,f in pairs(onUpdate) do
            if (f(self, ...)) then
                tinsert(drop, k)
            end
        end
        for _,k in ipairs(drop) do
            onUpdate[k] = nil
        end
    end)

    function obj:RegisterEvent(e, f)
        if ( not events[e] ) then
            events[e] = {}
            eventsFrame:RegisterEvent(e)
        end
        tinsert(events[e], f)
    end

    function obj:OnUpdate(k, f)
        if ( f == nil ) then
            onUpdate[k] = nil
        else
            onUpdate[k] = f
        end
    end

end

--------------------------------------------------------------------------------

function V_Addon.InstallNamespaces(obj, ns)
    if ( type(obj) ~= "table" ) then return end
    if ( type(ns) ~= "table" ) then return end
    if ( obj._V_namespacesInstalled ) then return end
    obj._V_namespacesInstalled = true

    for _,m in ipairs(ns) do
        obj[m] = obj[m] or {}
    end

    function obj:InitializeNamespaces()
        for _,m in ipairs(ns) do
            local namespace = self[m]
            local init = namespace and namespace.OnInitializeNamespace
            if ( init ) then
                init()
            end
        end
        for _,m in ipairs(ns) do
            if ( self[m] ) then
                self[m].OnInitializeNamespace = nil
            end
        end
    end

end

--------------------------------------------------------------------------------
