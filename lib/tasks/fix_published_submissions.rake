desc "Ensure all submissions publishable are published"
task fix_submissions: :environment do
  StudentProfile.current.onboarding.find_each do |student|
    student.update(onboarded: student.can_be_marked_onboarded?)
  end

  Team.current.find_each do |team|
    team.update(
      has_students: team.students.any?,
      all_students_onboarded: team.students.any? && team.students.all?(&:onboarded?)
    )
  end

  TeamSubmission.current.select(&:only_needs_to_submit?).each(&:published!)
end