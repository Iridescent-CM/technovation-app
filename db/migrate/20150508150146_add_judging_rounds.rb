class AddJudgingRounds < ActiveRecord::Migration
  def change
    add_column :users, :semifinals_judge, :boolean
    add_column :users, :finals_judge, :boolean
  end
end
