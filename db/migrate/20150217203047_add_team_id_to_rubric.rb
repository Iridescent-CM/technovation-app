class AddTeamIdToRubric < ActiveRecord::Migration
  def change
    add_column :rubrics, :team_id, :integer
  end
end
