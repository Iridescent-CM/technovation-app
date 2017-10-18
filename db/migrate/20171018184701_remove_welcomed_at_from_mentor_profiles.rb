class RemoveWelcomedAtFromMentorProfiles < ActiveRecord::Migration[5.1]
  def up
    remove_column :mentor_profiles, :welcomed_at, :datetime
  end
end
