class AddBioToMentorProfiles < ActiveRecord::Migration
  def change
    add_column :mentor_profiles, :bio, :text
  end
end
