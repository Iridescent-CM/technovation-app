class ChangeDefaultConnectWithMentorsToFalseAgain < ActiveRecord::Migration[6.1]
  def change
    change_column_default :mentor_profiles, :connect_with_mentors, from: true, to: false
  end
end