if Region.create(name: "US/Canada").valid?
  puts "Created Region: #{Region.last.name}"
end

if Season.create(year: Time.current.year, starts_at: Time.current).valid?
  puts "Created Season: #{Season.current.year}"
end

if ScoreCategory.create(name: "Ideation").valid?
  category = ScoreCategory.last
  puts "Created ScoreCategory: #{category.name}"

  score_attribute = category.score_attributes.create(
    label: "Did the team identify a real problem in their community?"
  )
  puts "Created ScoreAttribute: #{score_attribute.label}"

  score_value = score_attribute.score_values.create(value: 0, label: "No")
  puts "Created ScoreValue: #{score_value.label} - #{score_value.value}"
end
