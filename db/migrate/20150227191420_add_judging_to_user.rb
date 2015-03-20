class AddJudgingToUser < ActiveRecord::Migration
  def change
    add_column :users, :judging, :boolean
  end
end
