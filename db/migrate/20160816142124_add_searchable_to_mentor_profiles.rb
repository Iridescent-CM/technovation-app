class AddSearchableToMentorProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :mentor_profiles, :searchable, :boolean, null: false, default: false
    add_index :mentor_profiles, :searchable
  end
end
