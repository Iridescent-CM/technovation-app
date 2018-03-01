class AddMultipleRegionsToRegionalAmbassadorProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :regional_ambassador_profiles, :secondary_regions, :string, array: true, default: []
  end
end
