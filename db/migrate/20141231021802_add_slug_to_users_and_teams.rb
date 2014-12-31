class AddSlugToUsersAndTeams < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_index :users, :slug, unique: true

    add_column :teams, :slug, :string
    add_index :teams, :slug, unique: true
  end
end
