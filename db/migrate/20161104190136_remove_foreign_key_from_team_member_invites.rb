class RemoveForeignKeyFromTeamMemberInvites < ActiveRecord::Migration
  def up
    remove_foreign_key :team_member_invites, column: :inviter_id
  end

  def down
    add_foreign_key :team_member_invites, :accounts, column: :inviter_id
  end
end
