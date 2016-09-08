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

LTA:Info("Initializing")          
