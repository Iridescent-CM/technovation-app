class AddAllOnboardedToTeams < ActiveRecord::Migration[5.1]
  class Team < ActiveRecord::Base
    include Seasoned

    has_many :memberships, dependent: :destroy

    has_many :students, -> { order("memberships.created_at") },
      through: :memberships,
      source: :member,
      source_type: "StudentProfile"
  end

  class StudentProfile < ActiveRecord::Base
    has_many :teams,
      through: :memberships
  end

  def up
    add_column :teams, :all_students_onboarded, :boolean, default: false

    Team.current.includes(:students).references(:memberships).find_each do |t|
      if t.students.any? && t.students.all?(&:onboarded)
        t.update_columns(
          all_students_onboarded: true,
          has_students: true
        )
      elsif t.students.none?
        t.update_column(:has_students, false)
      end
    end
  end

  def down
    remove_column :teams, :all_students_onboarded
  end
end
