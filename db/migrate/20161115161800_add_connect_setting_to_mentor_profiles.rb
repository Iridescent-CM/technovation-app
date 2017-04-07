class AddConnectSettingToMentorProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :mentor_profiles, :connect_with_mentors, :boolean, null: false, default: true
  end
end
