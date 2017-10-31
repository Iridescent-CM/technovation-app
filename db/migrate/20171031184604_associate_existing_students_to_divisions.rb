class AssociateExistingStudentsToDivisions < ActiveRecord::Migration[5.1]
  def up
    StudentProfile.joins(:account).find_each do |s|
      s.account.update_column(:division_id, Division.for(s).id)
    end
  end
end
