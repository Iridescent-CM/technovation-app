class AddRubricsCountToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :rubrics_count, :integer
  end
end
