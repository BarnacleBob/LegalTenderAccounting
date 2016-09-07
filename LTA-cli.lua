LTA:Debug("Initializing CLI")

SLASH_LTA1 = '/lta';

function LTA:CLI_Handler(msg, editbox)
  print("your command was " .. msg .. " in " .. editbox)
end

SlashCmdList["LTA"] = LTA.CLI_Handler

