LTA:Debug("Initializing CLI")

LTA.CLI={}

local CLI=LTA.CLI

SLASH_LTA1 = '/lta';

function CLI:Handler (msg)
  LTA:Debug("Processing cli message")
  LTA:Debug("msg type is " .. type(msg))
  print("your command was " .. msg)
end

SlashCmdList["LTA"] = function(...) CLI:Handler(...) end

