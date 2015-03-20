class AddStageToRubric < ActiveRecord::Migration
  def change
    add_column :rubrics, :stage, :integer
  end
end
