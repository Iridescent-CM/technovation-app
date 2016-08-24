class ConvertAmabassadorSinceYearToStringOnRegionalAmbassadorProfiles < ActiveRecord::Migration
  def up
    change_column :regional_ambassador_profiles, :ambassador_since_year, :string
  end
end
