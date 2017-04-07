class AddAcceptingTeamInvitesToMentorProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :mentor_profiles, :accepting_team_invites, :boolean, null: false, default: true
  end
end
