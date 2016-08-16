class AddSearchableToMentorProfiles < ActiveRecord::Migration
  def change
    add_column :mentor_profiles, :searchable, :boolean, null: false, default: false
    add_index :mentor_profiles, :searchable
  end
end
