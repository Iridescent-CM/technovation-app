class AddJudgingRegionToUser < ActiveRecord::Migration
  def change
    add_column :users, :judging_region, :integer
  end
end
