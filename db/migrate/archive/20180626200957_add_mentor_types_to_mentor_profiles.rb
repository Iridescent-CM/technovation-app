class AddMentorTypesToMentorProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :mentor_profiles, :mentor_type, :integer
  end
end
