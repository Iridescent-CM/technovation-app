class AddWelcomedAtToMentorProfiles < ActiveRecord::Migration[5.1]
  def up
    add_column :mentor_profiles, :welcomed_at, :datetime
  end
end
