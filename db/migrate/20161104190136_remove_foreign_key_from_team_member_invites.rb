class RemoveForeignKeyFromTeamMemberInvites < ActiveRecord::Migration[4.2]
  def up
    remove_foreign_key :team_member_invites, column: :inviter_id
    remove_foreign_key :team_member_invites, column: :invitee_id
  end

  def down
    add_foreign_key :team_member_invites, :accounts, column: :inviter_id
    add_foreign_key :team_member_invites, :accounts, column: :invitee_id
  end
end
