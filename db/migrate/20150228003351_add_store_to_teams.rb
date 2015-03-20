class AddStoreToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :store, :string
  end
end
