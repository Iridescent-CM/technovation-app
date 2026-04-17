module ChapterAmbassador
  class EventTeamsController < ChapterAmbassadorController
    include RegionalPitchEvents::AvailableTeams
    include RegionalPitchEvents::ManageEventTeams
    include RegionalPitchEvents::RequireAddTeamsToRegionalPitchEventEnabled
  end
end
