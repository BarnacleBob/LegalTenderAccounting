LTA:Debug("init loot shit")
LTA.Loot={}
local Loot=LTA.Loot
Loot.Looters = {}
--Loot.MLWatcher = CreateFrame("Frame")
--Loot.MLWatcher:SetScript("OnEvent", function(...) Loot.MLUpdate(...) end)
--Loot.MLWatcher:SetScript("OnEvent", function(...) Loot.RosterUpdate(...) end)

Loot.Watcher = CreateFrame("Frame")
Loot.Watcher:SetScript("OnEvent", function(...) Loot.HandleMsg(...) end)

LTA:Debug("Done loot init")

function Loot:StartWatch()
  LTA:Debug("Starting Loot watcher")
  Loot.MLUpdate()
  LTA:Debug("registering loot events")
  self.Watcher:RegisterEvent("CHAT_MSG_LOOT")
  --LTA:Debug("registering ml update events")
  --self.MLWatcher:RegisterEvent("GROUP_ROSTER_UPDATE")
end

function Loot:StopWatch()
  LTA:Debug("Disabling Loot watcher")
  self.Watcher:UnregisterEvent("CHAT_MSG_LOOT")
  --self.MLWatcher:UnregisterEvent("UPDATE_MASTER_LOOT_LIST")
end

function Loot:RosterUpdate(...)
  LTA:DumpVarArgs("roster update", ...)
end

function Loot:MLUpdate()
  LTA:Debug("master looter update event")
  Loot.Looters = {}
  for _, member in pairs(LTA.Group.Members) do
    if member.isML == true then
      LTA:Debug("Found master looter: " .. member.name)
      table.insert(Loot.Looters, member.name)
    end
  end
end

function Loot:HandleMsg(...)
  LTA:DumpVarArgs("HandleLootMsg", ...)
end
