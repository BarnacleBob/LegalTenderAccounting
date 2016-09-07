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
