class RenameUsedScreenOrientationVerifiedOnTechnicalChecklists < ActiveRecord::Migration[4.2]
  def change
    rename_column :technical_checklists, :used_screen_orientation_verified, :used_sharing_verified
  end
end
