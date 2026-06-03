class MakeTeamDescriptionOptional < ActiveRecord::Migration[5.1]
  def change
    change_column_null :teams, :description, true
  end
end
