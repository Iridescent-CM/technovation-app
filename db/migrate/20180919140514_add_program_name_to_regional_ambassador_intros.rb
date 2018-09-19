class AddProgramNameToRegionalAmbassadorIntros < ActiveRecord::Migration[5.1]
  def change
    add_column :regional_ambassador_profiles, :program_name, :string
  end
end
