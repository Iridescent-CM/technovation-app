class CreateTeamMemberInvites < ActiveRecord::Migration
  def change
    create_table :team_member_invites do |t|
      t.integer :inviter_id, null: false
      t.integer :team_id, foreign_key: true, null: false
      t.string :invitee_email, null: false
      t.string :invite_token, null: false

      t.foreign_key :accounts, column: :inviter_id
      t.timestamps null: false
    end

    add_index :team_member_invites, :invite_token, unique: true
  end
end
