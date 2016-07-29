class AddBioToRegionalAmbassadorProfiles < ActiveRecord::Migration
  def change
    add_column :regional_ambassador_profiles, :bio, :text
  end
end
