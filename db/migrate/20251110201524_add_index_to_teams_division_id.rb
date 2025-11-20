class AddIndexToTeamsDivisionId < ActiveRecord::Migration[7.0]
  def change
    add_index :teams, :division_id
  end
end
