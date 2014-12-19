class CreateTeams < ActiveRecord::Migration
  def change
    # create the teams
    create_table :teams do |t|
      t.string :name
      t.text :about
      t.integer :year, null: false, default: 2014
      t.integer :division, default: 2, null: false
      t.integer :region, null: false
      t.timestamps
    end
    add_index :teams, :division
    add_index :teams, :year

    # create the applications
    create_table :team_requests do |t|
      t.belongs_to :user
      t.belongs_to :team
      t.boolean :user_request, null: false, default: true
      t.boolean :approved, null: false, default: false
      t.timestamps
    end
  end
end
