-- Run Sequence:
-- LTA-init.lua:  runs first to setup generic functions and the LTA table
-- LTA-cli.lua:   sets up the cli environment
-- LTA-zone.lua:  functions to watch for various zone changes

LTA.EncounterMap = {}
local em = LTA.EncounterMap

--Encounter data is em[zone][encounter] = list of mobs
em[1175] = {} -- BloodMaulSlagMines
em[1175][1652] = {75786} -- Roltall
em[1175][1653] = {74787} -- Slave Watcher Crushto
em[1175][1654] = {74790} -- Gugrokk
em[1175][1655] = {74366, 74475} -- 74366 Forgemaster Gog'duh, 74475 Magmolatus
em[1520] = {} -- Emerald Nightmare
em[1520][1877] = {104636} -- Cenarius
em[1520][1873] = {105393} -- Ilgynoth
em[1520][1854] = {102679,102683,102682,102681} -- Dragons 102679 Ysondre, 102683 (Emeriss), 102682 (Lethon), 102681 (Taerar)
em[1520][1853] = {102672} -- Nythendra
em[1520][1876] = {106087} -- Renferal
em[1520][1841] = {100497} -- Ursok
em[1520][1864] = {103769} -- Xavius

LTA.MobToEncounterMap = {}

function LTA:Init()
  LTA:Info("Initializing")

  LTA.Group:Update("Init")
  LTA.Group:StartWatcher()
  
  local function ES(...)
    LTA:EncounterStarted(...)
  end

  local function ZCStart()
    LTA:Info("LegalTenderAccounting now watching for encounters")
    LTA.Encounter:StartWatch()
    LTA.Loot:StartWatch()
  end

  local function ZCEnd()
    LTA.Encounter:StopWatch()
    LTA.Group:StopWatch()
    LTA.Loot:StopWatch()
    LTA:Info("LegalTenderAccounting done watching for encounters")
  end

  for zone, encounters in pairs(em) do
    LTA.Zone:WatchFor(zone, ZCStart, ZCEnd)
  
    for encounter, mobIds in pairs(encounters) do
      LTA.Encounter:WatchFor({encounter}, ES)
      LTA.Encounter:WatchFor(mobIds, ES)
      for _, mobId in pairs(mobIds) do
        LTA.MobToEncounterMap[mobId] = encounter
      end
    end
  end
end

function LTA:EncounterStarted (mobId)
  LTA:Debug("Encounter started with mob " .. mobId)
  if LTA.Group.Size == nil or LTA.Group.Size == 0 then
    LTA:Info("You are not in a group.  Not logging encounter")
    return
  end
  local encounter = {}
  local _, m, d, y = CalendarGetDate();
  LTA:Debug(m .. "-" .. d .. "-" .. y)
  encounter.RaidDate = ("%u-%u-%u"):format(y,m,d)
  LTA:Debug("Got date: " .. encounter.RaidDate)
  encounter.StartTime = ("%u:%u.%u"):format(LTA.GameTime:Get())
  LTA:Debug("Got start time: " .. encounter.StartTime)
  --LTA:DumpTable("map", self.MobToEncounterMap)
  encounter.Id = self.MobToEncounterMap[mobId]
  LTA:Debug("got encounter id" .. encounter.Id)
  encounter.RaidMembers = LTA:CopyTable(LTA.Group.Members)
  --LTA:DumpTable("RaidMembers", encounter.RaidMembers)
  encounter.GuildMembers = LTA.Guild:GetOnlineMembers()
  --LTA:DumpTable("guild", encounter.GuildMembers)
  encounter.GuildName, _, _ = GetGuildInfo("player")
  LTA:Debug("Guild name: " .. encounter.GuildName)
  encounter.Loot = {}

  encounter.Key = ("%s %s %u"):format(encounter.RaidDate, encounter.StartTime, encounter.Id)

  LTA:Info("Logging encounter " .. encounter.Key) 
  local sd = LTA.SavedData
  sd.EncounterLogs[encounter.Key] = encounter
  LTA:DumpTable("sd", sd)
  LTA:DumpTable("el", sd.EncounterLogs)
  LTA:DumpTable("el log", sd.EncounterLogs[encounter.Key])
  
  sd.LastEncounter = encounter.Key
  LTA:Debug("Last encounter" .. sd.LastEncounter)
  LTA.LEDBG = sd.EncounterLogs[encounter.Key]
end
