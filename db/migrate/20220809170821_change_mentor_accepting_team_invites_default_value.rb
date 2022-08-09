class ChangeMentorAcceptingTeamInvitesDefaultValue < ActiveRecord::Migration[6.1]
  def change
    change_column_default :mentor_profiles, :accepting_team_invites, from: true, to: false
  end
end
