class RemoveStartsAtFromSeasons < ActiveRecord::Migration
  def change
    remove_column :seasons, :starts_at, :date
  end
end
