class RemovePrimaryContactIdFromChapters < ActiveRecord::Migration[6.1]
  def change
    remove_column :chapters, :primary_contact_id
  end
end
