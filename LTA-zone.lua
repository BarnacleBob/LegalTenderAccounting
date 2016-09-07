-- Helper functions to watch for zone changes
LTA:Debug("Initializing Zone Watcher")
LTA.Zone = {}

local Zone = LTA.Zone
Zone.OnEnters = {}
Zone.OnExits  = {}

function Zone:OnEnter(zone_id, callback)
  Zone.OnEnters[zone_id] = calback
end

function Zone:OnExit(zone_id, calback)
  Zone.OnExits[zone_id] = calback
end

function Zone:WatchFor(zone_id, enter, exit)
  Zone.OnEnters[zone_id] = enter
  Zone.OnExits[zone_id] = exit
end

Zone.Watcher = CreateFrame("Frame")
local watcher = Zone.Watcher

watcher:RegisterEvent("ZONE_CHANGED")
watcher:RegisterEvent("ZONE_CHANGED_INDOORS")
watcher:RegisterEvent("ZONE_CHANGED_NEW_AREA")

function Zone:HandleZoneChange(...)
  LTA:Debug("Zone Change: " .. event .. " arg type " .. type(...))
end

watcher:SetScript("OnEvent", Zone.HandleZoneChange)
