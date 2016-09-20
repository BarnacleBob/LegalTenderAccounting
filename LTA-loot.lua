LTA:Debug("init loot shit")
LTA.Loot={}
local Loot=LTA.Loot
Loot.Looters = {}

Loot.Watcher = CreateFrame("Frame")
Loot.Watcher:SetScript("OnEvent", function(...) Loot.HandleMsg(...) end)

LTA:Debug("Done loot init")

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
  local sd = LTASavedData
  LTA:DumpTable("Last encounter", sd.LastEncounter)
    
  if type(LTA.LastEncounter) == nil then
    LTA:Debug("We have no last enounter to log this item to")
    return nil
  end
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
  
  -- Looks like item ids are stored in some magic unicode string to make a linked item.
  -- gonna process server side the entire set of messages
  --LTA:Debug("msg type:" .. type(msg))
  --LTA:Debug("found spaces: " .. string.find(msg, "%s"))
  --for i=1, string.len(msg) do
  --  LTA:Debug(msg:byte(i) .. ": " .. string.char(msg:byte(i)))
  --end
  --for word in string.gmatch(msg, "%S+") do
  --  LTA.Debug(word)
  --end
  
  LTA:DumpTable("lm", lm)
  if LTA.LastEncounter ~= nil then
    LTA:Debug("inserting loot event into last encounter")
    table.insert(LTA.LastEncounter.Loot, lm)
  end
end
