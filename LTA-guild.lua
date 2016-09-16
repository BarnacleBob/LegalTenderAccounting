LTA.Guild = {}
local Guild = LTA.Guild

function Guild:GetOnlineMembers()
  local GetGuildRosterInfo = GetGuildRosterInfo -- apparently caching heavily used functions is good
  local showOffline = GetGuildRosterShowOffline()
  local members={}
  
  LTA:Debug("Getting online guild members")
  
  if showOffline then
    LTA.Debug("Disabling show offline members")
    SetGuildRosterShowOffline(false)
    GuildRoster()
  end
  
  local i=0
  repeat
    i = i + 1
    local member = {}
    member.name, member.rank, member.rankIndex, member.level, member.class, member.zone, member.note, 
      member.officernote, member.online, member.status, member.classFileName, 
      member.achievementPoints, member.achievementRank, member.isMobile, member.isSoREligible,
      member.standingID = GetGuildRosterInfo(i);
    LTA:Debug("Found guild member " .. member.name)
    table.insert(members, member)
  until not member.online

  if showOffline then
    LTA.Debug("re-enabling show offline members")
    SetGuildRosterShowOffline(true)
    GuildRoster()
  end

  return members
end
