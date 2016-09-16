LTA.Group = {}
local Group = LTA.Group
Group.Members = {}
Group.Watcher = CreateFrame("frame")
Group.Watcher:RegisterEvent("GROUP_ROSTER_UPDATE")
Group.Watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
watcher:SetScript("OnEvent", function(...) Group:Update(...) end)

function Group:Update(event)
  LTA:Debug("Updating group info in response to " .. event)
  local members = Group.Members
  members = {}
  Group.Size = GetNumGroupMembers()
  LTA:Debug("group size is: " .. tostring(Group.Size))
  for i=1,Group.Size do
    local member={}
    member.name, member.rank, member.subgroup, member.level, member.class, member.fileName, 
      member.zone, member.online, member.isDead, member.role, member.isML = GetRaidRosterInfo(i);
    LTA:Debug("Found group member: " .. member.name)
    table.insert(members, member)
  end
end
