class ConvertAmabassadorSinceYearToStringOnRegionalAmbassadorProfiles < ActiveRecord::Migration[4.2]
  def up
    change_column :regional_ambassador_profiles, :ambassador_since_year, :string
  end
end
