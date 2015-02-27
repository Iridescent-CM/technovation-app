class AddRubricsAverageToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :rubrics_average, :integer
  end
end
