module Admin
  class EventTeamsController < AdminController
    include RegionalPitchEvents::AvailableTeams
    include RegionalPitchEvents::ManageEventTeams
  end
end