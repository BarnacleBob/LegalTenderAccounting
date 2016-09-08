--local ZoneHandler = CreateFrame("Frame")
--ZoneHandler:RegisterEvent("ZONE_CHANGED")
--ZoneHandler:RegisterEvent("ZONE_CHANGED_INDOORS")
--ZoneHandler:RegisterEvent("ZONE_CHANGED_NEW_AREA")

--function HandleZoneChange(self, event, ...)
--  print("Zone Change: " .. event .. " arg type " .. type(...))
--end

--ZoneHandler:SetScript("OnEvent", HandleZoneChange)

-- Run Sequence:
-- LTA-init.lua:  runs first to setup generic functions and the LTA table
-- LTA-cli.lua:   sets up the cli environment
-- LTA-zone.lua:  functions to watch for various zone changes

LTA:Info("Initializing")
LTA.Zone:WatchFor(1448, function() LTA:Info("entering HFC") end, function() LTA:Info("left HFC") end)
LTA.Zone:WatchFor(1116, function() LTA:Info("entering Draenor") end, function() LTA:Info("left Draenor") end)
LTA.Zone:WatchFor(1464, function() LTA:Info("entering Tanaan") end, function() LTA:Info("left Tanaan") end)

