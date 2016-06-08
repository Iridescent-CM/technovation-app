Division::CreateHighSchool.run({}) do |op|
  puts "Created Division: #{op.model.name}"
end

Division::CreateMiddleSchool.run({}) do |op|
  puts "Created Division: #{op.model.name}"
end

Region::Create.run(region: { name: "US/Canada" }) do |op|
  puts "Created Region: #{op.model.name}"
end

Season::Create.run(season: { year: Time.current.year,
                             starts_at: Time.current }) do |op|
  puts "Created Season: #{op.model.year}"
end

ScoreCategory::Create.run(score_category: {
                            name: "Ideation",
                            score_attributes_attributes: {
                              0 => { label: "Did the team identify a real problem in their community?",
                                      score_values_attributes: { 0 => { value: 0, label: "No", } }, },
                            },
                          }) do |op|
  puts "Created ScoreCategory: #{op.model.name}, #{op.model.score_attributes.collect(&:label)}, #{op.model.score_attributes.flat_map(&:score_values).collect(&:label)}"
end

