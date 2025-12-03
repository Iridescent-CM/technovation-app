class UpdateMentorProfilesAcceptingTeamInvitesToTrue < ActiveRecord::Migration[7.0]
  def change
    change_column_default :mentor_profiles, :accepting_team_invites, true
  end
end
