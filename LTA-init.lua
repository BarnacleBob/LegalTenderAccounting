print ("Hi from lta-init")

LTA = {}
LTA.debug = true

function LTA:HandleInitEvent(event, arg)
  LTA:Debug("Aaddon loadded event: " .. event .. " " .. arg)
  if event == "ADDON_LOADED" and arg1 == "LegalTenderAccounting" then
    if not LTASavedData then
      LTA:Debug("Initializing sd var")
      LTASavedData={}
    end
    
    if type(LTASavedData["DataVersion"]) == nil then
      LTA:Debug("Building data array version 1")
      LTASavedData.DataVersion=1
      LTASavedData.EncounterLogs = {}
      TLASavedData.LastEncounter = nil
    end
    
    LTA:Debug("setting lta.saved data to ltasaveddata")
    LTA.SavedData = LTASavedData
  end
  LTA:Debug("calling main init")
  LTA:Init()
end

LTA.InitWatcher = CreateFrame("frame")
LTA.InitWatcher:RegisterEvent("ADDON_LOADED")
LTA.InitWatcher:SetScript("OnEvent", function(...) LTA:HandleInitEvent(...) end)

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
  LTA:Debug("dumping table: " .. name .. " " .. tostring(t))
  for key, value in pairs(t) do
    LTA:Debug(tostring(key) .. ": " .. tostring(value))
  end
end

function LTA:Concat(t, s)
  local o = ""
  for k, v in ipairs(t) do
    o = o .. v .. s
  end
  return o
end


LTA.GameTime = {

  -----------------------------------------------------------
  -- function <PREFIX>_GameTime:Get()
  --
  -- Return game time as (h,m,s) where s has 3 decimals of
  -- precision (though it's only likely to be precise down
  -- to ~20th of seconds since we're dependent on frame
  -- refreshrate).
  --
  -- During the first minute of play, the seconds will
  -- consistenly be "00", since we haven't observed any
  -- minute changes yet.
  --
  --

  Get = function(self)
    if(self.LastMinuteTimer == nil) then
      local h,m = GetGameTime();
      return h,m,0;
    end
    local s = GetTime() - self.LastMinuteTimer;
    if(s>59.999) then
      s=59.999;
    end
    return self.LastGameHour, self.LastGameMinute, s;
  end,


  -----------------------------------------------------------
  -- function <PREFIX>_GameTime:OnUpdate()
  --
  -- Called by: Private frame <OnUpdate> handler
  --
  -- Construct high precision server time by polling for
  -- server minute changes and remembering GetTime() when it
  -- last did
  --

  OnUpdate = function(self)
    local h,m = GetGameTime();
    if(self.LastGameMinute == nil) then
      self.LastGameHour = h;
      self.LastGameMinute = m;
      return;
    end
    if(self.LastGameMinute == m) then
      return;
    end
    self.LastGameHour = h;
    self.LastGameMinute = m;
    self.LastMinuteTimer = GetTime();
  end,

  -----------------------------------------------------------
  -- function <PREFIX>_GameTime:Initialize()
  --
  -- Create frame to pulse OnUpdate() for us
  --

  Initialize = function(self)
    self.Frame = CreateFrame("Frame");
    self.Frame:SetScript("OnUpdate", function() self:OnUpdate(); end);
  end
}

LTA.GameTime:Initialize();
