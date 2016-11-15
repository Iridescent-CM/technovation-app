class AddConnectSettingToMentorProfiles < ActiveRecord::Migration
  def change
    add_column :mentor_profiles, :connect_with_mentors, :boolean, null: false, default: true
  end
end
