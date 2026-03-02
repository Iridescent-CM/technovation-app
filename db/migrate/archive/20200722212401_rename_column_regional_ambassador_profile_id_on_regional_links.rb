class RenameColumnRegionalAmbassadorProfileIdOnRegionalLinks < ActiveRecord::Migration[5.1]
  def change
    rename_column :regional_links, :regional_ambassador_profile_id, :chapter_ambassador_profile_id
  end
end
