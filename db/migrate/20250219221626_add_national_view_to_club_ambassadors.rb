class AddNationalViewToClubAmbassadors < ActiveRecord::Migration[6.1]
  def change
    add_column :chapter_ambassador_profiles, :national_view, :boolean, default: false
  end
end
