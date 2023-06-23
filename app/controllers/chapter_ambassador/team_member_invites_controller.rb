module ChapterAmbassador
  class TeamMemberInvitesController < ChapterAmbassadorController
    include Admin::DeleteTeamMemberInviteConcern
  end
end
