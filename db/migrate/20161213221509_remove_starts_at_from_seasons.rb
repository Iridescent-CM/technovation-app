class RemoveStartsAtFromSeasons < ActiveRecord::Migration[4.2]
  def change
    remove_column :seasons, :starts_at, :date
  end
end
