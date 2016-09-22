LTA.Loot={}
local Loot=LTA.Loot
Loot.Looters = {}

Loot.Watcher = CreateFrame("Frame")
Loot.Watcher:SetScript("OnEvent", function(...) Loot.HandleMsg(...) end)

function Loot:StartWatch()
  LTA:Debug("Starting Loot watcher")
  self.Watcher:RegisterEvent("CHAT_MSG_LOOT")
end

function Loot:StopWatch()
  LTA:Debug("Disabling Loot watcher")
  self.Watcher:UnregisterEvent("CHAT_MSG_LOOT")
end

function Loot:IsML(name)
  for _, ml in pairs(LTA.Group.MasterLooters) do
    if ml == name then
      return true
    end
  end
  return false
end

function Loot:HandleMsg(event, ...)
  LTA:DumpVarArgs("HandleLootMsg", ...)
  -- ("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)
  local sd = LTA.SavedData
  LTA:Debug("Last Encounter: " .. sd.LastEncounter)
  
  if type(sd.LastEncounter) == nil then
    LTA:Debug("We have no last enounter to log this item to")
    return nil
  end

  local LastEncounter = sd.EncounterLogs[sd.LastEncounter]
  LTA:DumpTable("Last encounter", LastEncounter)

  local lm = {}
  local msg, sender, lang, channelString, target, flags, uk1, channelNumber, channelName, uk2, counter = ...
  lm.msg = msg
  lm.sender = sender
  lm.lang = lang
  lm.channelString = channelString
  lm.target = target
  lm.flags = flags
  lm.uk1 = uk1
  lm.channelNumber = channelNumber
  lm.channelName = channelName
  lm.uk2 = uk2
  lm.counter = counter

  LTA:Debug("Found a new message: " .. msg)
  local item = {}
  local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(msg)
  item.name = name
  item.link = link
  item.quality = quality
  item.iLevel = iLevel
  item.reqLevel = reqLevel
  item.class = class
  item.subclass = subclass
  item.maxStack = maxStack
  item.equipSlot = equipSlot
  item.texture = texture
  item.vendorPrice = vendorPrice
  lm.item = item
  LTA:DumpTable("Item", item)
  
  LTA:DumpTable("lm", lm)
  if LastEncounter ~= nil then
    LTA:Debug("inserting loot event into last encounter")
    table.insert(LastEncounter.Loot, lm)
  end
end
