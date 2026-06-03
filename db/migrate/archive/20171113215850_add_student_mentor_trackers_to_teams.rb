class AddStudentMentorTrackersToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :has_students, :boolean, null: false, default: false
    add_column :teams, :has_mentor, :boolean, null: false, default: false
  end
end
