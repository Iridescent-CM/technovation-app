if Region.create(name: "US/Canada").valid?
  puts "Created Region: #{Region.last.name}"
end

if Season.create(year: Time.current.year, starts_at: Time.current).valid?
  puts "Created Season: #{Season.current.year}"
end

if (category = CreateScoringRubric.(
     category: "Ideation",
     attributes: [{ label: "Did the team identify a real problem in their community?",
                    values: [{ value: 0, label: "No" },
                             { value: 3, label: "Yes" }] }]
   )).valid?
  puts "Created ScoreCategory: #{category.name}"

  category.score_attributes.each do |score_attribute|
    puts "Created ScoreAttribute: #{score_attribute.label}"

    score_attribute.score_values.each do |score_value|
      puts "Created ScoreValue: #{score_value.label} - #{score_value.value}"
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
