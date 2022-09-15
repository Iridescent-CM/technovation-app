class ChangeDefaultConnectWithMentorsBackToTrue < ActiveRecord::Migration[6.1]
  def change
    change_column_default :mentor_profiles, :connect_with_mentors, from: false, to: true
  end
end
