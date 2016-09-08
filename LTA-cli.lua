LTA:Debug("Initializing CLI")

LTA.CLI={}

local CLI=LTA.CLI

SLASH_LTA1 = '/lta';

CLI.Handlers = {}

CLI.Handlers["debug"] = function (args)
  if LTA.debug then
    LTA:Info("Disabling debug output")
    LTA.debug = nil
  else
    LTA:Info("Enabling debug output")
    LTA.debug = true
  end
end

function CLI:Handler (msg)
  LTA:Debug("Processing cli message: " .. msg:len())
  if msg:len() > 0 then
    LTA:Info("Process command")
    local cmd = msg:match("[^%s]+")
    local args = msg:sub(cmd:len() + 2)
    LTA:Debug(("Cmd: %s, args: %s"):format(cmd, args))
    for handlerCmd, handler in pairs(CLI.Handlers) do
      if cmd == handlerCmd then
        CLI.Handlers[handlerCmd](args)
      else
        LTA:Info("CLI command " .. cmd .. " not found")
      end
    end
  else
    LTA:Info("Hi from Legal Tender!")
    LTA:Info("CLI commands:")
    for i, _ in pairs(CLI.Handlers) do
      LTA:Info("    " .. i)
    end
  end
end

SlashCmdList["LTA"] = function(...) CLI:Handler(...) end
