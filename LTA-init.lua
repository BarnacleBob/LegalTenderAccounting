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

LTA:Info("Initializing")          
