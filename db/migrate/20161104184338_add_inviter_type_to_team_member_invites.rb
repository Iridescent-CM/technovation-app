class AddInviterTypeToTeamMemberInvites < ActiveRecord::Migration
  def change
    add_column :team_member_invites, :inviter_type, :string
  end
end
