class AddHasScoredToRubrics < ActiveRecord::Migration
  def change
    add_column :rubrics, :has_scored, :boolean, default: false
  end
end
