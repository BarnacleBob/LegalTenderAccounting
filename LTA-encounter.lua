LTA.Encounter = {}
local Encounter = LTA.Encounter

Encounter.InProgress = nil
Encounter.Watches = {}

Encounter.BossTable = {
  "boss1", "boss2", "boss3", "boss4", "boss5",
}


function Encounter:WatchFor(watch_ids, callback)
  LTA:Debug("Registering encounter watche for " .. table.concat(watch_ids, ", "))
  for _, id in pairs(watch_ids) do
    self.Watches[id]=callback
  end
  --LTA:DumpTable("Watches is now", self.Watches)
end

function Encounter:GetBossIds()
  LTA:Debug("Scanning for boss ids")
  local idset = {}
  local nameplates = {"boss1", "boss2", "boss3", "boss4", "boss5"}
  for _, nameplate in pairs(nameplates) do
    --LTA:Debug("Scanner checking " .. nameplate)
    local guid = UnitGUID(nameplate)
    --LTA:Debug("got guid: " .. tostring(guid))
    if guid then
      local _, _, _, _, _, mobId = strsplit("-", guid)
      LTA:Debug("Found " .. mobId .. " on " .. nameplate)
      idset[tonumber(mobId)] = true
    end
  end
  --LTA:DumpTable("Found encounter ids", found)
  local ids = {}
  for id, _ in pairs(idset) do
    table.insert(ids, id)
  end
  --LTA:DumpTable("list of ids", ids)
  return ids
end

Encounter.Watcher = CreateFrame("Frame")
local watcher = Encounter.Watcher
watcher:SetScript("OnEvent", function(...) Encounter:EventHandler(...) end)

function Encounter:EventHandler(...)
  LTA:Debug("Handling encounter event")
  if not self.InProgress then
    local BossIds = Encounter:GetBossIds()
    if next(BossIds) == nil then
      LTA:Debug("Not in progress and has no bosses")
      LTA:Debug("Enter Dungeon sometimes calls this")
    else
      LTA:Debug("Not in progress and has bosses")
      LTA:Debug("Real encounter start event")
      
      self.InProgress = true
      
      LTA:DumpTable("watches", self.Watches)
      for _, id in ipairs(BossIds) do
        LTA:Debug("checking if we care about encounter id " .. id)
        if type(self.Watches[id]) ~= nil then
          -- we have an encounter we care about
          LTA:Debug("Found Encounter " .. id .. " calling handler ")
          local callback = self.Watches[id]
          callback(id)
        end
      end
    end
  else
    local BossIds = Encounter:GetBossIds()
    if next(BossIds) == nil then
      LTA:Debug("In progress and has no bosses")
      LTA:Debug("Encounter end event")
      self.InProgress = nil
    else
      LTA:Debug("In progress and has bosses")
      LTA:Debug("Encounter continuing")
    end
  end
end

function Encounter:StartWatch()
  LTA:Debug("Starting encounter watcher")
  --watcher:RegisterEvent("ENCOUNTER_START")
  self.Watcher:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
end

function Encounter:StopWatch()
  LTA:Debug("Disabling encounter watcher")
  --watcher:UnregisterEvent("ENCOUNTER_START")
  self.Watcher:UnregisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
end
