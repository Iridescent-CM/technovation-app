class CreateTeamSubmissions < ActiveRecord::Migration[4.2]
  def change
    create_table :team_submissions do |t|
      t.boolean :integrity_affirmed, null: false, default: false
      t.references :team, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
