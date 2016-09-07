LTA:Debug("Initializing CLI")

LTA.CLI={}

local CLI=LTA.CLI

SLASH_LTA1 = '/lta';

function CLI:Handler (msg)
  LTA:Debug("Processing cli message")
  print("your command was " .. msg)
end

SlashCmdList["LTA"] = CLI:Handler

