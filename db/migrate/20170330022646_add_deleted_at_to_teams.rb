class AddDeletedAtToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :deleted_at, :datetime
  end
end
