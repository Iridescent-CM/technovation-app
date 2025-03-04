desc "Assign mentors to students primary chapterable"
task assign_mentors_to_students_primary_chapterable: :environment do
  Team.current.where(has_mentor: true, has_students: true)
    .includes(memberships: {member: {account: :chapterable_assignments}})
    .find_each do |team|

    puts "Team: #{team.id} - #{team.name}"

    students = team.students.select { |s| s.account.assigned_to_chapterable? }
    student_primary_assignments = students.map { |s| s.account.current_chapterable_assignment }.uniq { |assignment| assignment.chapterable_id }
    mentors = team.mentors

    if student_primary_assignments.empty?
      puts "Skipping team: #{team.id} - #{team.name} - no student primary assignments"
      next
    end

    mentors.each do |mentor|
      mentor_chapterable_ids = mentor.account.chapterable_assignments.where(profile_type: "MentorProfile").pluck(:chapterable_id)

      assignments_to_add = student_primary_assignments.reject do |assignment|
        mentor_chapterable_ids.include?(assignment.chapterable_id)
      end

      if assignments_to_add.empty?
        puts "Skipping - no assignments to add for #{mentor.account.email}"
        next
      end

      assignments_to_add.each do |assignment|
        puts "Assigning account #{mentor.account.id} - #{mentor.account.email} to #{assignment.chapterable_type} #{assignment.chapterable_id}"
        mentor.account.chapterable_assignments.create(
          profile: mentor.account.mentor_profile,
          chapterable_id: assignment.chapterable_id,
          chapterable_type: assignment.chapterable_type.capitalize,
          season: Season.current.year,
          primary: false
        )
      end
    end
  end
end
