module Admin
  class TeamMemberInvitesController < AdminController
    include Admin::DeleteTeamMemberInviteConcern
  end
end
