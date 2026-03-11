class AddDeclineReasonToTeamMemberInvites < ActiveRecord::Migration[7.0]
  def change
    add_column :team_member_invites, :decline_reason, :integer
  end
end
