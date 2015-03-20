class AddIswinnerToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :iswinner, :boolean
  end
end
