class AddIsfinalistToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :isfinalist, :boolean
  end
end
