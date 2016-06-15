class AddCommentToScoredValues < ActiveRecord::Migration
  def change
    add_column :scored_values, :comment, :text
  end
end
