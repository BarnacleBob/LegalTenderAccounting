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

LTA.MobToEncounterMap = {}

function LTA:Init()
  LTA:Info("Initializing")

  local function ES(...)
    LTA:EncounterStarted(...)
  end

  local function ZCStart()
    LTA.Encounter:StartWatch()
    LTA.Loot:StartWatch()
  end

  local function ZCEnd()
    LTA.Encounter:StopWatch()
    LTA.Group:StopWatch()
    LTA.Loot:StopWatch()
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
  local sd = LTASavedData
  sd.EncounterLogs[encounter.Key] = encounter
  LTA:DumpTable("sd", sd)
  LTA:DumpTable("el", sd.EncounterLogs)
  LTA:DumpTable("el log", sd.EncounterLogs[encounter.Key])
  
  sd.LastEncounter = sd.EncounterLogs[encounter.Key]
  LTA:DumpTable("Last encounter", sd.LastEncounter)
end
