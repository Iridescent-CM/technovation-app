desc "Ensure all submissions publishable are published"
task fix_submissions: :environment do
  puts "### STUDENTS"
  StudentProfile.current.onboarding.find_each do |student|
    if student.onboarded != student.can_be_marked_onboarded?
      puts "#{student.id} #{student.email}"
      puts "\tonboarded?: #{yesno student.onboarded} -> #{yesno student.can_be_marked_onboarded?}"
      result = student.update(onboarded: student.can_be_marked_onboarded?)
      puts "\tupdated? #{yesno result}"
    end
  end

  puts "\n### TEAMS"
  Team.current.find_each do |team|
    has_students = team.students.any?
    all_onboarded = team.students.any? && team.students.all?(&:onboarded?)
    if team.has_students != has_students or
        team.all_students_onboarded != all_onboarded
      puts "#{team.id} #{team.name}"
      puts "\thas students?: #{yesno team.has_students} -> #{yesno has_students}"
      puts "\tall onboarded?: #{yesno team.all_students_onboarded} -> #{yesno all_onboarded}"
      result = team.update(
        has_students: has_students,
        all_students_onboarded: all_onboarded
      )
      puts "\tupdated? #{yesno result}"
    end
  end

  puts "\n### PUBLISHING"
  TeamSubmission.current.select(&:only_needs_to_submit?).each do |sub|
    puts "Publishing #{sub.app_name} by #{sub.team_name}"
    sub.publish!
  end
end

task recalc_completeness: :environment do
  TeamSubmission.current.find_each do |sub|
    old = sub.percent_complete
    sub.touch
    change = "SAME"
    if old < sub.percent_complete
      change = "BETTER"
    elsif old > sub.percent_complete
      change = "WORSE"
    end
    puts "#{change} #{sub.app_name} #{old} -> #{sub.percent_complete}"
  end
end

def yesno(bool)
  bool ? "Yes" : "No"
end
