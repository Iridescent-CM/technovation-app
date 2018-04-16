class AddAllOnboardedToTeams < ActiveRecord::Migration[5.1]
  def up
    add_column :teams, :all_students_onboarded, :boolean, default: false

    Team.current.includes(:students).find_each do |t|
      if t.students.any? && t.students.all?(&:onboarded)
        t.update_column(:all_students_onboarded, true)
      elsif t.students.any?
        t.update_column(:all_students_onboarded, false)
      else
        t.update_column(:has_students, false)
      end
    end
  end

  def down
    remove_column :teams, :all_students_onboarded
  end
end
