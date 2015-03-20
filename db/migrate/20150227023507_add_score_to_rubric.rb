class AddScoreToRubric < ActiveRecord::Migration
  def change
    add_column :rubrics, :score, :integer
  end
end
