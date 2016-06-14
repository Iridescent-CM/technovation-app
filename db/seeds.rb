if Region.create(name: "US/Canada").valid?
  puts "Created Region: #{Region.last.name}"
end

if Season.create(year: Time.current.year, starts_at: Time.current).valid?
  puts "Created Season: #{Season.current.year}"
end

if CreateScoringRubric.({
     category: "Ideation",
     questions: [{ label: "Did the team identify a real problem in their community?",
                   values: [{ value: 0, label: "No" },
                            { value: 3, label: "Yes" }] }]
   })

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

if (team = Team.create(name: "The Techno Girls",
                       description: "A great team of smart and capable girls!",
                       division: Division.high_school,
                       region: Region.last)).valid?

  puts "Created Team: #{team.name}"

  team.submissions.create!
  puts "Created Submission"
end

if (team = Team.create(name: "Girl Power",
                       description: "Another great team of smart and capable girls!",
                       division: Division.high_school,
                       region: Region.last)).valid?

  puts "Created Team: #{team.name}"

  team.submissions.create!
  puts "Created Submission"
end

if (judge = CreateJudge.(email: "judge@judging.com",
                         password: "judge@judging.com",
                         password_confirmation: "judge@judging.com",
                         expertises: ScoreCategory.all)).valid?
  puts "Created Judge: #{judge.email} with password #{judge.password}"
end
