class RemoveHasScoredFromRubrics < ActiveRecord::Migration
  def change
    remove_column :rubrics, :has_scored
  end
end
