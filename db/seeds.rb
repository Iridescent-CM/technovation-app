if Region.create(name: "US/Canada").valid?
  puts "Created Region: #{Region.last.name}"
end

if Season.create(year: Time.current.year, starts_at: Time.current).valid?
  puts "Created Season: #{Season.current.year}"
end

if ScoreCategory.create({ name: "Ideation",
                          score_attributes_attributes: {
                            0 => {
                              label: "Did the team identify a real problem in their community?",
                              score_values_attributes: {
                                0 => {
                                  value: 0,
                                  label: "No",
                                },
                              },
                            },
                          },
                        }).valid?
  category = ScoreCategory.last
  puts "Created ScoreCategory: #{category.name}, #{category.score_attributes.collect(&:label)}, #{category.score_attributes.flat_map(&:score_values).collect(&:label)}"
end
