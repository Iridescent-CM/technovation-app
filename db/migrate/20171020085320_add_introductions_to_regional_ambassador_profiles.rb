class AddIntroductionsToRegionalAmbassadorProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :regional_ambassador_profiles, :intro_summary, :text
  end
end
