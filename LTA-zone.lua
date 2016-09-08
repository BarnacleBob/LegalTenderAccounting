-- Helper functions to watch for zone changes
LTA:Debug("Initializing Zone Watcher")

LTA.Zone = {}

local Zone = LTA.Zone
Zone.OnEnters = {}
Zone.OnExits  = {}

function Zone:OnExit(zone_id, calback)
  LTA:Debug("registering on exit callback for " .. zone_id)
  self.OnExits[zone_id] = calback
  LTA:DumpTable("self.OnExits", self.OnExits)
end
function Zone:OnEnter(zone_id, calback)
  LTA:Debug("registering on exit callback for " .. zone_id)
  self.OnEnters[zone_id] = calback
  LTA:DumpTable("self.OnEnters", self.OnEnters)
end

function Zone:WatchFor(zone_id, enter, exit)
  LTA:Debug("Registering a watch on zone " .. zone_id)
  Zone:OnEnter(zone_id, enter)
  Zone:OnExit(zone_id, exit)
end

Zone.Watcher = CreateFrame("Frame")
local watcher = Zone.Watcher

watcher:RegisterEvent("ZONE_CHANGED")
watcher:RegisterEvent("ZONE_CHANGED_INDOORS")
watcher:RegisterEvent("ZONE_CHANGED_NEW_AREA")
--watcher:RegisterEvent("PLAYER_ENTERING_WORLD")

function Zone:HandleZoneChange()
  LTA:Debug("Handling Zone Change Event")
  --LTA:Debug("Event type: " .. tostring(event))

  if not self.Current then
    self.Current={}
  end
  
  self.Last = LTA:CopyTable(self.Current)
    
  local x, y, _, map = UnitPosition("player")
  self.Current.Id = map
  self.Current.Name = GetRealZoneText(map)
  SetMapToCurrentZone()
  self.Current.LocalId = GetCurrentMapAreaID()
  self.Current.LocalName = GetZoneText()
  LTA:Debug(("Was in %u (%s) with local %u (%s)"):format(self.Last.Id, self.Last.Name, self.Last.LocalId, self.Last.LocalName))
  LTA:Debug(("Now in %u (%s) with local %u (%s)"):format(self.Current.Id, self.Current.Name, self.Current.LocalId, self.Current.LocalName))
  
  if self.Current.Id ~= self.Last.Id then
    LTA:Debug("Zone actually changed.  finding handlers")

    LTA:Debug("exits: " .. type(self.OnExits))
    LTA:DumpTable("self.OnExits", self.OnExits)
    LTA:DumpTable("self.OnEnters", self.OnEnters)
    if self.Last.Id and self.OnExits[self.Last.Id] then
      LTA:Debug("Calling exit handler")
      self.OnExits[self.Last.Id](self.Last)
    end
    if self.OnEnters[self.Current.Id] then
      LTA:Debug("Calling enter handler")
      self.OnEnters[self.Current.Id](self.Current)
    end
  end
end

watcher:SetScript("OnEvent", function(...) Zone:HandleZoneChange(...) end)
