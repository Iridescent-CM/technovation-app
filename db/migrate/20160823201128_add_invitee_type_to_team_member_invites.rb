class AddInviteeTypeToTeamMemberInvites < ActiveRecord::Migration[4.2]
  def change
    add_column :team_member_invites, :invitee_type, :string
    add_index :team_member_invites, :invitee_type
  end
end
