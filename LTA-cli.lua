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

CLI.Handlers["guild"] = function()
  LTA.Guild:GetOnlineMembers()
end

CLI.Handlers["group"] = function()
  LTA:Debug("Group size is " .. LTA.Group.Size)
  LTA:Debug("group members:")
  for _,member in pairs(LTA.Group.Members) do
    LTA:Debug(member.name)
  end
end

CLI.Handlers["startloot"] = function()
  LTA.Loot:StartWatch()
end

CLI.Handlers["stoploot"] = function()
  LTA.Loot:StopWatch()
end

function CLI:Handler (msg)
  local handlers = CLI.Handlers
  LTA:Debug("Processing cli message")
  if msg:len() > 0 then
    local cmd = msg:match("[^%s]+")
    local args = msg:sub(cmd:len() + 2)
    LTA:Debug(("Cmd: %s, args: %s"):format(cmd, args))
    if handlers[cmd] then
      handlers[cmd](args)
    else
      LTA:Info("CLI command " .. cmd .. " not found")
    end
  else
    LTA:Info("CLI commands:")
    for i, _ in pairs(CLI.Handlers) do
      LTA:Info("    " .. i)
    end
  end
end

SlashCmdList["LTA"] = function(...) CLI:Handler(...) end
