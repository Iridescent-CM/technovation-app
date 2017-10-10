class AddIntroductionsToRegionalAmbassadorProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :regional_ambassador_profiles, :intro_summary, :text
    add_column :regional_ambassador_profiles, :links, :jsonb, default: []
  end
end
