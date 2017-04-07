class CreateTeamMemberInvites < ActiveRecord::Migration[4.2]
  def change
    create_table :team_member_invites do |t|
      t.integer :inviter_id, null: false
      t.integer :team_id, foreign_key: true, null: false
      t.string :invitee_email
      t.integer :invitee_id
      t.string :invite_token, null: false
      t.integer :status, null: false, index: true, default: 0

      t.foreign_key :accounts, column: :inviter_id
      t.foreign_key :accounts, column: :invitee_id
      t.timestamps null: false
    end

    add_index :team_member_invites, :invite_token, unique: true
  end
end
