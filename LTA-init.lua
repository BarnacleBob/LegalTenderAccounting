LTA = {}

function LTA:HandleInitEvent(self, event, arg)
  if event == "ADDON_LOADED" and arg == "LegalTenderAccounting" then
    LTA:Debug("Aaddon loadded event: " .. event .. " " .. arg)
    if not LTADataVersion then
      LTA:Info("Initializing new saved data table")
      LTADataVersion = 1
      local dv = LTADataVersion
      LTASavedData={}
      local sd = LTASavedData
      
      sd.Options = {}
      sd.Options.Debug = false
      
      sd.VersionedData = {}
      sd.VersionedData[dv] = {}
      local vd = sd.VersionedData[dv]
      vd.EncounterLogs = {}
      vd.LastEncounter = nil
    end

    -- here we can migrate a saved data version from one to the next relatively easily
    -- actually we dont need to migrate local data.  server side can just parse them individually
    -- just need to save new data versions into a new table
    
    LTA:Debug("data version " .. LTADataVersion)
    LTA:DumpTable("sd", LTASavedData)
    LTA:DumpTable("vd", LTASavedData.VersionedData)
    LTA:DumpTable("data", LTASavedData.VersionedData[LTADataVersion])
    
    LTA.SavedData = LTASavedData.VersionedData[LTADataVersion]
    LTA:Debug("setting lta.options to " .. tostring(LTASavedData.Options))
    LTA.Options = LTASavedData.Options
    LTA:Debug("lta.options set to " .. tostring(LTASavedData.Options))

    LTA:Debug("calling main init")
    LTA:Init()
  end
end

LTA.InitWatcher = CreateFrame("frame")
LTA.InitWatcher:RegisterEvent("ADDON_LOADED")
LTA.InitWatcher:SetScript("OnEvent", function(...) LTA:HandleInitEvent(...) end)

function LTA:Debug(msg)
  -- default to debug unless we have an options array
  if type(self.Options) or type(self.Options.Debug) == nil or self.Options.Debug then
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
  LTA:Debug("dumping table: ")
  LTA:Debug(name .. " " .. tostring(t))
  for key, value in pairs(t) do
    LTA:Debug("  " .. tostring(key) .. ": " .. tostring(value))
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
