if Region.create(name: "US/Canada").valid?
  puts "Created Region: #{Region.last.name}"
end

if Season.create(year: Time.current.year, starts_at: Time.current).valid?
  puts "Created Season: #{Season.current.year}"
end

if CreateScoringRubric.([{
     category: "Ideation",
     questions: [{ label: "Did the team identify a real problem in their community?",
                   values: [{ value: 0, label: "No" },
                            { value: 3, label: "Yes" }] }]
   },
   { category: "Technical" },
   { category: "Entrepreneurship" },
   { category: "Subjective", expertise: false },
   { category: "Bonus", expertise: false },
])

  ScoreCategory.all.each do |category|
    puts "Created ScoreCategory: #{category.name}"

    category.score_questions.each do |score_question|
      puts "Created ScoreQuestion: #{score_question.label}"

      score_question.score_values.each do |score_value|
        puts "Created ScoreValue: #{score_value.label} - #{score_value.value}"
      end
    end
  end
end

if Expertise.create(name: "Science").valid?
  puts "Created Expertise: #{Expertise.last.name}"
end

if Expertise.create(name: "Engineering").valid?
  puts "Created Expertise: #{Expertise.last.name}"
end

if Expertise.create(name: "Project Management").valid?
  puts "Created Expertise: #{Expertise.last.name}"
end

if (team = Team.create(name: "The Techno Girls",
                       description: "A great team of smart and capable girls!",
                       division: Division.high_school,
                       region: Region.last)).valid?

  puts "Created Team: #{team.name}"

  team.submissions.create!(code: "code", description: "description", pitch: "pitch", demo: "demo")
  puts "Created Submission"
end

if (team = Team.create(name: "Girl Power",
                       description: "Another great team of smart and capable girls!",
                       division: Division.high_school,
                       region: Region.last)).valid?

  puts "Created Team: #{team.name}"

  team.submissions.create!(code: "code", description: "description", pitch: "pitch", demo: "demo")
  puts "Created Submission"
end

if (judge = JudgeAccount.create(email: "judge@judging.com",
                                password: "judge@judging.com",
                                password_confirmation: "judge@judging.com",
                                judge_profile_attributes: {
                                  scoring_expertise_ids: ScoreCategory.is_expertise.pluck(:id),
                                  company_name: "ACME, Inc.",
                                  job_title: "Engineer",
                                },
                                first_name: "Judgy",
                                last_name: "McGee",
                                date_of_birth: Date.today - 31.years,
                                city: "Chicago",
                                region: "IL",
                                country: "US",
                               )).valid?
  puts "Created Judge: #{judge.email} with password #{judge.password}"
end

if (student = StudentAccount.create(email: "student@student.com",
                                    password: "student@student.com",
                                    password_confirmation: "student@student.com",
                                    student_profile_attributes: {
                                      school_name: "John Hughes High",
                                      parent_guardian_email: "parent@parent.com",
                                      parent_guardian_name: "Parent Name",
                                    },
                                    first_name: "Student",
                                    last_name: "McGee",
                                    date_of_birth: Date.today - 14.years,
                                    city: "Chicago",
                                    region: "IL",
                                    country: "US",
                                   )).valid?
  puts "Created Student: #{student.email} with password #{student.password}"
end

if (mentor = MentorAccount.create(email: "mentor@mentor.com",
                                  password: "mentor@mentor.com",
                                  password_confirmation: "mentor@mentor.com",
                                  mentor_profile_attributes: {
                                    school_company_name: "Boeing",
                                    job_title: "Aerospace Engineer",
                                    expertise_ids: Expertise.pluck(:id)[0..1],
                                  },
                                  first_name: "Mentor",
                                  last_name: "McGee",
                                  date_of_birth: Date.today - 34.years,
                                  city: "Boulder",
                                  region: "CO",
                                  country: "US",
                                 )).valid?
  puts "Created Mentor: #{mentor.email} with password #{mentor.password}"
end

if (admin = AdminAccount.create(email: "admin@admin.com",
                                password: "admin@admin.com",
                                password_confirmation: "admin@admin.com",
                                first_name: "Test",
                                last_name: "Admin",
                                date_of_birth: Date.today,
                                city: "Chicago",
                                region: "IL",
                                country: "US",
                               )).valid?
  puts "Created Admin: #{admin.email} with password #{admin.password}"
end
