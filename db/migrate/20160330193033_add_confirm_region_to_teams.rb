class AddConfirmRegionToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :confirm_region, :boolean
  end
end
