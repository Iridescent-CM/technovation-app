class AssociateExistingStudentsToDivisions < ActiveRecord::Migration[5.1]
  class StudentProfile < ActiveRecord::Base
    belongs_to :account
  end

  def up
    StudentProfile.joins(:account).find_each do |s|
      s.account.update_column(:division_id, Division.for(s).id)
    end
  end
end
