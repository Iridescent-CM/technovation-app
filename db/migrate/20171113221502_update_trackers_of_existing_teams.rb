class UpdateTrackersOfExistingTeams < ActiveRecord::Migration[5.1]
  def up
    Team.find_each do |t|
      t.update_columns(
        has_students: t.students.any?,
        has_mentor: t.mentors.any?
      )
    end
  end
end
