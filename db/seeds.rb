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
