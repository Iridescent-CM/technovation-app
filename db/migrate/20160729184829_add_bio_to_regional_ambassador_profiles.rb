class AddBioToRegionalAmbassadorProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :regional_ambassador_profiles, :bio, :text
  end
end
