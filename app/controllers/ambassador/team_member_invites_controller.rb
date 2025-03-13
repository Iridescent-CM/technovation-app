module Ambassador
  class TeamMemberInvitesController < AmbassadorController
    include Admin::DeleteTeamMemberInviteConcern
  end
end
