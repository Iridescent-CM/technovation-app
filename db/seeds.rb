Region::Create.run(region: { name: "US/Canada" }) do |op|
  puts "Created Region: #{op.model.name}"
end

Season.create(year: Time.current.year, starts_at: Time.current)
puts "Created Season: #{op.model.year}"

ScoreCategory::Create.run(score_category: {
                            name: "Ideation",
                            score_attributes_attributes: {
                              0 => { label: "Did the team identify a real problem in their community?",
                                      score_values_attributes: { 0 => { value: 0, label: "No", } }, },
                            },
                          }) do |op|
  puts "Created ScoreCategory: #{op.model.name}, #{op.model.score_attributes.collect(&:label)}, #{op.model.score_attributes.flat_map(&:score_values).collect(&:label)}"
end

