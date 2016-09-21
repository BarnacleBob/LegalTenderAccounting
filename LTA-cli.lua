LTA.CLI={}
local CLI=LTA.CLI

SLASH_LTA1 = '/lta';

CLI.Handlers = {}

CLI.Handlers["debug"] = function (args)
  if LTA.Options.Debug then
    LTA:Info("Disabling debug output")
    LTA.Options.Debug = nil
  else
    LTA:Info("Enabling debug output")
    LTA.Options.Debug = true
  end
end

CLI.Handlers["dv"] = function (arg)
  if not arg or arg == "" then
    LTA:Info("Cowardly refusing to dump global scope")
    return
  else
    local sv = _G
    LTA:Debug("searching global scope for " .. arg)
    -- lua pattern matching sucks.  end the string with a . so we can get all the parts
    for v in string.gmatch(arg .. ".", "([^%.]+)%.") do
      LTA:Debug("searching " .. tostring(sv) .. " for " .. v)
      if type(sv[v]) == nil then
        LTA:Debug(v .. " not found")
        LTA:Info(arg .. " not found")
      else
        sv = sv[v]
      end
    end

    LTA:Debug("sv is " .. tostring(sv))
    LTA:DumpTable(arg, sv)
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
