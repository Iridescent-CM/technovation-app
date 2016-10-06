desc "Bootstrap the db"
task bootstrap: :environment do
  %w{science coding engineering project_management finance marketing design}.each do |name|
    if Expertise.exists?(name: name.titleize)
      puts "Found Expertise: #{name.titleize}"
    elsif Expertise.create(name: name.titleize).persisted?
      puts "Created Expertise: #{name.titleize}"
    else
      puts "Failed to find or create Expertise: #{name.titleize}"
    end
  end

  email = "info@technovationchallenge.org"

  if AdminAccount.exists?(email: email)
    puts "Found Admin: #{email}"
  else
    AdminAccount.create!(first_name: "Technovation",
                          last_name: "Staff",
                          email: email,
                          password: ENV.fetch("ADMIN_PASSWORD"),
                          password_confirmation: ENV.fetch("ADMIN_PASSWORD"),
                          city: "San Francisco",
                          state_province: "CA",
                          country: "US",
                          geocoded: "San Francisco, CA, US",
                          date_of_birth: 100.years.ago)
    puts "Created Admin: #{email}"
  end
end
