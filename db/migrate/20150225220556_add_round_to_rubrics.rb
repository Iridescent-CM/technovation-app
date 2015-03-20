class AddRoundToRubrics < ActiveRecord::Migration
  def change
    add_column :rubrics, :round, :string
  end
end
