class AddStatusToSeasonRegistration < ActiveRecord::Migration
  def change
    add_column :season_registrations, :status, :integer, null: false, default: SeasonRegistration.statuses[:active]
    add_index :season_registrations, :status
  end
end
