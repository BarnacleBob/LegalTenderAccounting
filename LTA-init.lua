print ("Hi from lta-init")

LTA = {}
LTA.debug = true

function LTA:Debug(msg)
  if self.debug then
    print("LTA DBG: " .. msg)
  end
end

function LTA:Info(msg)
  print("LTA: " .. msg)
end

function LTA:DumpVarArgs(name, ...)
  self:Debug("Dumping VarArgs for " .. name)
  for _, v in ipairs({...}) do
    print(type(v) .. ": " .. tostring(v))
  end
end

function LTA:CopyTable(orig)
  --shallow copy a table 
  local copy
  copy = {}
  for orig_key, orig_value in pairs(orig) do
    copy[orig_key] = orig_value
  end
  return copy
end

function LTA:DumpTable(name, t)
  LTA:Debug("dumping table: " .. name)
  for key, value in pairs(t) do
    LTA:Debug(tostring(key) .. ": " .. tostring(value))
  end
end
