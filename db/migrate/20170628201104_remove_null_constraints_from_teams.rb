class RemoveNullConstraintsFromTeams < ActiveRecord::Migration[5.1]
  def change
    change_column_null :teams, :description, true
    change_column_null :teams, :division_id, true
  end
end
