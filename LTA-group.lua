LTA.Group = {}
local Group = LTA.Group
Group.Members = {}
Group.MasterLooters = {}
Group.Watcher = CreateFrame("frame")
Group.Watcher:RegisterEvent("GROUP_ROSTER_UPDATE")
Group.Watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
Group.Watcher:SetScript("OnEvent", function(...) Group:Update(...) end)

function Group:Update(event)
  LTA:Debug("Updating group info")
  local Group = LTA.Group
  local members = {}
  local mls = {}
  Group.Size = GetNumGroupMembers()
  LTA:DumpTable("group", Group)
  LTA:Debug("group size is: " .. tostring(Group.Size))
  for i=1,Group.Size do
    local member={}
    member.name, member.rank, member.subgroup, member.level, member.class, member.fileName, 
      member.zone, member.online, member.isDead, member.role, member.isML = GetRaidRosterInfo(i);
    --LTA:Debug("Found group member: " .. member.name)
    table.insert(members, member)
    if member.isML then
      --LTA:Debug("Adding to master looter list")
      table.insert(mls, member.name)
    end
  end
  Group.Members = members
  Group.MasterLooters = mls
end
