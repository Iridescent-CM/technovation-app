class AddBioToMentorProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :mentor_profiles, :bio, :text
  end
end
