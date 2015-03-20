class AddChallengeToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :challenge, :string
  end
end
