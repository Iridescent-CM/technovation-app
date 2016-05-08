class RenameWhentooccurOnEvents < ActiveRecord::Migration
  def change
    rename_column :events, :whentooccur, :when_to_occur
  end
end
