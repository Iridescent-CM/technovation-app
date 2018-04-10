class AddAllOnboardedToTeams < ActiveRecord::Migration[5.1]
  def up
    add_column :teams, :all_students_onboarded, :boolean, default: false

    Team.current.find_each do |t|
      if t.has_students and t.students.all?(&:onboarded)
        t.update_column(:all_students_onboarded, true)
      else
        t.update_column(:all_students_onboarded, false)
      end
    end
  end

  def down
    remove_column :teams, :all_students_onboarded
  end
end
