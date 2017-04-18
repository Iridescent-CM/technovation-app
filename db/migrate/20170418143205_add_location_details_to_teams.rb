class AddLocationDetailsToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :city, :string
    add_column :teams, :state_province, :string
    add_column :teams, :country, :string
  end
end
