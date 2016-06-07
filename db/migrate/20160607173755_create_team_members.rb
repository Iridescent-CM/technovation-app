class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.integer :role, null: false

      t.timestamps null: false
    end
  end
end
