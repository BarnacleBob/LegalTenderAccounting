LTA:Debug("Initializing CLI")

SLASH_LTA1 = '/lta';

local function CLI_Handler (msg)
  print("your command was " .. msg)
end

SlashCmdList["LTA"] = CLI_Handler

