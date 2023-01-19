class FixReturningBeginnerStudentsWhoBecomeJuniorStudents < ActiveRecord::Migration[6.1]
  def up
    accounts = Account.where("'2022' = ANY(seasons)")
      .where("accounts.date_of_birth < '2010-08-01'")
      .joins(:student_profile)
      .where("student_profiles.parent_guardian_email = accounts.email")

    accounts.each do |account|
      puts "Student: #{account.first_name} #{account.last_name}"
      puts "Account email address: #{account.email}"
      puts "Parent/Guardian email address: #{account.student_profile.parent_guardian_email}"
      puts "Age by cutoff: #{account.age_by_cutoff}"
      puts ""
    end

    student_profile_ids = accounts.collect { |a| a.student_profile.id }
    total_student_profiles_updated = StudentProfile.where(id: student_profile_ids).update_all(parent_guardian_email: nil)

    puts "Total number of students updated: #{total_student_profiles_updated}"
  end
end
